import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import time
from datetime import datetime

app = Flask(__name__)
CORS(app)

PORT = int(os.environ.get("PORT", 8080))
DATA_PATH = "data/users.json"
COOLDOWNS = {"collect": 60, "attack": 120}

def load_users():
    if os.path.exists(DATA_PATH):
        with open(DATA_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

def save_users(users):
    os.makedirs(os.path.dirname(DATA_PATH), exist_ok=True)
    with open(DATA_PATH, "w", encoding="utf-8") as f:
        json.dump(users, f, ensure_ascii=False, indent=2)

def get_or_create_user(user_id):
    users = load_users()
    uid = str(user_id)
    if uid not in users:
        users[uid] = {
            "user_id": user_id,
            "balance": 1000,
            "level": 1,
            "xp": 0,
            "town_hall": 1,
            "barracks": 1,
            "mine": 1,
            "wall": 1,
            "troops": [],
            "heroes": [],
            "cooldowns": {},
            "created_at": datetime.now().isoformat()
        }
        save_users(users)
    return users[uid]

@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "nasrium-api"})

@app.route("/api/user/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = get_or_create_user(user_id)
    return jsonify(user)

@app.route("/api/collect", methods=["POST"])
def collect():
    data = request.json
    user_id = str(data.get("user_id"))
    user = get_or_create_user(user_id)
    amount = 100 * user.get("town_hall", 1)
    user["balance"] = user.get("balance", 0) + amount
    users = load_users()
    users[user_id] = user
    save_users(users)
    return jsonify({"success": True, "new_balance": user["balance"], "collected": amount})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
