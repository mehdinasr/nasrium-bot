from flask import Flask, jsonify, send_from_directory, request
import os
from pymongo import MongoClient
from Core.App.GameEngine import GameEngine
from Core.App.ResourceEngine import ResourceEngine
from Core.App.SyndicateEngine import SyndicateEngine

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
                "buildings": {"gold_mine": 1, "gem_drill": 0}
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

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
