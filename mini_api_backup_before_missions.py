from Core.App.QuestEngine import QuestEngine
from Core.App.TargetFinderEngine import TargetFinderEngine
from Core.App.WalletEngine import WalletEngine
from Core.App.SimpleBuildingEngine import SimpleBuildingEngine
from flask import Flask, jsonify, send_from_directory, request
import os
import time
from pymongo import MongoClient
from Core.App.GameEngine import GameEngine
from Core.App.ResourceEngine import ResourceEngine
from Core.App.SyndicateEngine import SyndicateEngine
from Core.App.WarEngine import WarEngine
from Core.App.RaidEngine import RaidEngine
from Core.App.TroopEngine import TroopEngine

BASE_DIR = os.path.dirname(__file__)
app = Flask(__name__, static_folder=os.path.join(BASE_DIR, "mini_app", "static"), static_url_path="/static")

# ---- Database connection ----
MONGO_URL = os.environ.get("MONGO_URL", "mongodb://localhost:27017")
mongo_client = MongoClient(MONGO_URL, serverSelectionTimeoutMS=5000)
db = mongo_client["nasrium_db"]
players_collection = db["players"]
syndicates_collection = db["syndicates"]
wars_collection = db["wars"]

# ---- Base routes ----
@app.route("/")
def index():
    return send_from_directory(os.path.join(BASE_DIR, "mini_app"), "index.html")

@app.route("/health")
def health_check():
    try:
        mongo_client.admin.command("ping")
        db_status = "connected"
    except Exception as e:
        db_status = f"error: {e}"
    return jsonify(status="Nasrium Ecosystem is LIVE.", database=db_status)

@app.route("/webhook", methods=["POST"])
def webhook():
    return jsonify(status="ok")

# ---- Player registration ----
@app.route("/api/user/register", methods=["POST"])
def register_user():
    try:
        data = request.json
        uid = data.get("user_id")
        upline_id = data.get("upline_id")
        if not uid: return jsonify({"error": "User ID required"}), 400
        existing_user = players_collection.find_one({"user_id": uid})
        if not existing_user:
            default_data = {
                "user_id": uid,
                "upline_id": upline_id if upline_id else None,
                "gold": 1000, "gems": 10, "nsm_soft": 5, "nsm_hard": 0,
                "town_hall_level": 1, "is_nexus_maxed": False, "is_banned": False,
                "buildings": {"gold_mine": 1, "gem_drill": 0}, "troops": 0
            }
            players_collection.insert_one(default_data)
            return jsonify({"success": True, "message": "User registered with Upline"})
        else:
            return jsonify({"success": True, "message": "User already exists"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---- Resource collection ----
@app.route("/api/collect", methods=["POST"])
def collect_resources():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = ResourceEngine.calculate_collection(p)
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {
                "gold": result["new_gold"],
                "gems": result["new_gems"],
                "last_collect_time": result["new_collect_time"]
            }}
        )
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---- Nexus upgrade (GameEngine, nsm_soft-based) ----
@app.route("/api/upgrade/nexus", methods=["POST"])
def upgrade_nexus():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = GameEngine.attempt_nexus_upgrade(p)
        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "gold": result["new_gold"],
                    "nsm_soft": result["new_nsm_soft"],
                    "town_hall_level": result["new_level"],
                    "is_nexus_maxed": result["is_nexus_maxed"]
                }}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---- Raid attack ----
@app.route("/api/raid/attack", methods=["POST"])
def execute_raid():
    try:
        data = request.json
        attacker_uid = data.get("attacker_id")
        defender_uid = data.get("defender_id")
        if not attacker_uid or not defender_uid:
            return jsonify({"error": "Missing IDs"}), 400
        if attacker_uid == defender_uid:
            return jsonify({"error": "Cannot raid yourself"}), 400
        attacker = players_collection.find_one({"user_id": attacker_uid})
        defender = players_collection.find_one({"user_id": defender_uid})
        if not attacker or not defender:
            return jsonify({"error": "Player not found"}), 404
        result = RaidEngine.initiate_raid(attacker, defender)
        if result["success"]:
            players_collection.update_one(
                {"user_id": attacker_uid},
                {"$inc": {
                    "gold": result.get("loot_gold", 0),
                    "gems": result.get("loot_gems", 0),
                    "troops": -result.get("troops_lost", 0)
                }}
            )
            if result["result"] == "Victory":
                players_collection.update_one(
                    {"user_id": defender_uid},
                    {
                        "$inc": {
                            "gold": -result.get("loot_gold", 0),
                            "gems": -result.get("loot_gems", 0)
                        },
                        "$set": {"shield_active_until": time.time() + (12 * 3600)}
                    }
                )
                attacker_syn = attacker.get("syndicate")
                defender_syn = defender.get("syndicate")
                if attacker_syn and attacker_syn != "None":
                    tax = SyndicateEngine.get_tax_contribution(result.get("loot_gold", 0))
                    if tax > 0:
                        syndicates_collection.update_one(
                            {"name": attacker_syn},
                            {"$inc": {"vault_gold": tax}}
                        )
                WarEngine.record_attack_score(attacker_syn, defender_syn, wars_collection)
                players_collection.update_one(
                    {"user_id": attacker_uid},
                    {"$inc": {"raid_wins": 1}}
                )
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---- Raid shield ----
@app.route("/api/raid/shield", methods=["POST"])
def buy_shield():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "Missing ID"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = RaidEngine.activate_shield(p)
        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "nsm_hard": result["new_nsm_hard"],
                    "shield_active_until": result["shield_expiry"]
                }}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---- Train troops ----
@app.route("/api/troops/train", methods=["POST"])
def train_troops():
    try:
        data = request.json
        uid = data.get("user_id")
        u_type = data.get("unit_type", "warrior")
        count = data.get("count", 1)
        if not uid:
            return jsonify({"error": "Missing ID"}), 400
        if u_type not in TroopEngine.UNIT_TYPES:
            return jsonify({"error": "Invalid unit type"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        can_afford, total_cost = TroopEngine.can_train(p, u_type, count)
        if not can_afford:
            return jsonify({"success": False, "message": f"Insufficient Gold. {total_cost} required."}), 400
        players_collection.update_one(
            {"user_id": uid},
            {"$inc": {"gold": -total_cost, "troops": count}}
        )
        return jsonify({
            "success": True,
            "unit_type": u_type,
            "count": count,
            "cost": total_cost,
            "message": f"{count} {TroopEngine.UNIT_TYPES[u_type]['label']} trained!"
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/upgrade/building", methods=["POST"])
def upgrade_building():
    try:
        data = request.json
        uid = data.get("user_id")
        b_type = data.get("building_type")
        if not uid or not b_type:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = SimpleBuildingEngine.attempt_upgrade(b_type, p)
        if result["success"]:
            update_fields = {
                "gold": result["new_gold"],
                f"buildings.{b_type}": result["new_level"]
            }
            players_collection.update_one(
                {"user_id": uid},
                {"$set": update_fields}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/wallet/link", methods=["POST"])
def link_wallet():
    try:
        data = request.json
        uid = data.get("user_id")
        wallet_address = data.get("wallet_address")
        if not uid or not wallet_address:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        success, message = WalletEngine.link_wallet(p, wallet_address)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"ton_wallet": p["ton_wallet"], "is_verified_holder": p["is_verified_holder"]}}
            )
            return jsonify({"success": True, "message": message})
        else:
            return jsonify({"success": False, "message": message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/wallet/check_deposit", methods=["POST"])
def check_deposit():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        deposit_address = os.environ.get("WALLET_ADDRESS")
        result = WalletEngine.check_and_process_deposits(uid, p, db["processed_transactions"], deposit_address)
        if result["success"] and result["credited_nsm_hard"] > 0:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard"]}}
            )
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/wallet/withdraw", methods=["POST"])
def withdraw_ton():
    try:
        data = request.json
        uid = data.get("user_id")
        amount = data.get("amount", 0)
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = WalletEngine.attempt_withdrawal(p, amount)
        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard"]}}
            )
            SyndicateEngine.process_upline_commission(uid, amount, players_collection)
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/syndicate/create", methods=["POST"])
def create_syndicate_route():
    try:
        data = request.json
        uid = data.get("user_id")
        syn_name = data.get("syndicate_name")
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        success, result = SyndicateEngine.create_syndicate(p, syn_name)
        if not success:
            return jsonify({"success": False, "message": result}), 400
        syndicates_collection.insert_one(result)
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {"gold": p["gold"], "syndicate": p["syndicate"]}}
        )
        return jsonify({"success": True, "syndicate": result["name"]})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/syndicate/join", methods=["POST"])
def join_syndicate_route():
    try:
        data = request.json
        uid = data.get("user_id")
        syn_name = data.get("syndicate_name")
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        syn_doc = syndicates_collection.find_one({"name": syn_name})
        success, result = SyndicateEngine.join_syndicate(p, syn_doc)
        if not success:
            return jsonify({"success": False, "message": result}), 400
        syndicates_collection.update_one(
            {"name": syn_name},
            {"$push": {"members": uid}}
        )
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {"syndicate": syn_name}}
        )
        return jsonify({"success": True, "syndicate": syn_name})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/war/declare", methods=["POST"])
def declare_war_route():
    try:
        data = request.json
        syn_a = data.get("syndicate_a")
        syn_b = data.get("syndicate_b")
        if not syn_a or not syn_b:
            return jsonify({"error": "Both syndicate names required"}), 400
        success, result = WarEngine.declare_war(syn_a, syn_b, wars_collection)
        if not success:
            return jsonify({"success": False, "message": result}), 400
        return jsonify({"success": True, "war": {
            "syndicate_a": result["syndicate_a"],
            "syndicate_b": result["syndicate_b"],
            "ends_at": result["ends_at"]
        }})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/war/status", methods=["POST"])
def war_status_route():
    try:
        data = request.json
        syn_name = data.get("syndicate_name")
        war = wars_collection.find_one({
            "status": "active",
            "$or": [{"syndicate_a": syn_name}, {"syndicate_b": syn_name}]
        })
        if not war:
            return jsonify({"success": True, "active_war": None})
        war = WarEngine.finalize_if_expired(war, syndicates_collection, wars_collection)
        return jsonify({"success": True, "active_war": {
            "syndicate_a": war["syndicate_a"],
            "syndicate_b": war["syndicate_b"],
            "score_a": war["score_a"],
            "score_b": war["score_b"],
            "status": war["status"],
            "winner": war.get("winner"),
            "ends_at": war["ends_at"]
        }})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/raid/find_targets", methods=["POST"])
def find_targets():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        targets = TargetFinderEngine.find_targets(uid, p, players_collection, limit=5)
        return jsonify({"success": True, "targets": targets})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/quests/status", methods=["POST"])
def quest_status():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        quests = QuestEngine.get_quest_status(p)
        return jsonify({"success": True, "quests": quests})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/quests/claim", methods=["POST"])
def quest_claim():
    try:
        data = request.json
        uid = data.get("user_id")
        quest_id = data.get("quest_id")
        if not uid or not quest_id:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        success, message = QuestEngine.claim_quest(p, quest_id)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "completed_airdrop_quests": p["completed_airdrop_quests"],
                    "airdrop_bonus_points": p["airdrop_bonus_points"]
                }}
            )
            return jsonify({"success": True, "message": message})
        else:
            return jsonify({"success": False, "message": message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
