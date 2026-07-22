from Core.App.TroopEngine import TroopEngine
import time
from Core.App.RaidEngine import RaidEngine
from Core.App.BuildingEngine import BuildingEngine
from Core.App.SyndicateEngine import SyndicateEngine
from Core.App.ResourceEngine import ResourceEngine
from flask import Flask, jsonify, send_from_directory, request
import os
from pymongo import MongoClient

BASE_DIR = os.path.dirname(__file__)
app = Flask(__name__, static_folder=os.path.join(BASE_DIR, "mini_app", "static"), static_url_path="/static")

# ---- Database connection ----
MONGO_URL = os.environ.get("MONGO_URL", "mongodb://localhost:27017")
mongo_client = MongoClient(MONGO_URL, serverSelectionTimeoutMS=5000)
db = mongo_client["nasrium_db"]
players_collection = db["players"]

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

# ==== PATCHES WILL BE INSERTED BELOW THIS LINE ====

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    
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

        # آپدیت دیتابیس با منابع جدید و زمان فعلی
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


@app.route("/api/user/register", methods=["POST"])
def register_user():
    try:
        data = request.json
        uid = data.get("user_id")
        upline_id = data.get("upline_id")
        if not uid: return jsonify({"error": "User ID required"}), 400

        # ثبت کاربر جدید و ثبت سرگروه او
        existing_user = players_collection.find_one({"user_id": uid})
        if not existing_user:
            default_data = {
                "user_id": uid,
                "upline_id": upline_id if upline_id else None,
                "gold": 1000, "gems": 10, "nsm_soft": 5, "nsm_hard": 0,
                "town_hall_level": 1, "is_nexus_maxed": False, "is_banned": False,
                "buildings": {"gold_mine": 1, "gem_drill": 0}
            }
            players_collection.insert_one(default_data)
            return jsonify({"success": True, "message": "User registered with Upline"})
        else:
            return jsonify({"success": True, "message": "User already exists"})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/upgrade/nexus", methods=["POST"])
def upgrade_nexus():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid: return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404
        if p.get("is_building", False):
            return jsonify({"success": False, "message": "Already under construction."}), 400
        success, updated = BuildingEngine.start_upgrade(p)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "gold": updated["gold"],
                    "construction_until": updated["construction_until"],
                    "is_building": updated["is_building"]
                }}
            )
            return jsonify({"success": True, "message": "Nexus upgrade started!", "construction_until": updated["construction_until"]})
        else:
            return jsonify({"success": False, "message": "Insufficient Gold."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/upgrade/nexus/finalize", methods=["POST"])
def finalize_nexus_upgrade():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid: return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404
        success, updated = BuildingEngine.finalize_upgrade(p)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "town_hall_level": updated["town_hall_level"],
                    "is_building": updated["is_building"],
                    "construction_until": updated["construction_until"]
                }}
            )
            return jsonify({"success": True, "message": "Nexus upgraded!", "new_level": updated["town_hall_level"]})
        else:
            return jsonify({"success": False, "message": "Construction not finished yet."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


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
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

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


@app.route("/api/troops/train", methods=["POST"])
def train_troops():
    try:
        data = request.json
        uid = data.get("user_id")
        unit_type = data.get("unit_type", "warrior")
        count = data.get("count", 1)
        if not uid:
            return jsonify({"error": "Missing ID"}), 400
        if unit_type not in TroopEngine.UNIT_TYPES:
            return jsonify({"error": "Invalid unit type"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        can_afford, total_cost = TroopEngine.can_train(p, unit_type, count)
        if not can_afford:
            return jsonify({"success": False, "message": f"Insufficient Gold. {total_cost} required."}), 400
        players_collection.update_one(
            {"user_id": uid},
            {"$inc": {"gold": -total_cost, "troops": count}}
        )
        return jsonify({
            "success": True,
            "unit_type": unit_type,
            "count": count,
            "cost": total_cost,
            "message": f"{count} {TroopEngine.UNIT_TYPES[unit_type]["label"]} trained!"
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

app.run(host="0.0.0.0", port=port)
