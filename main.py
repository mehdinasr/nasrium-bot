import os
import json
import asyncio
import logging
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

flask_app = Flask(__name__)
CORS(flask_app)

PORT = int(os.environ.get("PORT", 8080))
BOT_TOKEN = os.environ.get("BOT_TOKEN", "")
DATA_PATH = "data/users.json"

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
            "town_hall": 1,
            "barracks": 1,
            "mine": 1,
            "wall": 1,
            "created_at": datetime.now().isoformat()
        }
        save_users(users)
    return users[uid]

@flask_app.route("/")
def home():
    return jsonify({"status": "ok", "service": "nasrium", "version": "1.0.0"})

@flask_app.route("/api/health")
def health():
    return jsonify({"status": "ok"})

@flask_app.route("/api/user/<int:user_id>")
def get_user(user_id):
    user = get_or_create_user(user_id)
    return jsonify(user)

@flask_app.route("/api/collect", methods=["POST"])
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

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = get_or_create_user(update.effective_user.id)
    msg = "Welcome to NASRIUM! Balance: " + str(user["balance"]) + " NSM"
    await update.message.reply_text(msg)

async def collect_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = get_or_create_user(update.effective_user.id)
    amount = 100 * user.get("town_hall", 1)
    user["balance"] = user.get("balance", 0) + amount
    users = load_users()
    users[str(update.effective_user.id)] = user
    save_users(users)
    msg = "Collected " + str(amount) + " NSM! Balance: " + str(user["balance"])
    await update.message.reply_text(msg)

async def balance_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = get_or_create_user(update.effective_user.id)
    msg = "Balance: " + str(user["balance"]) + " NSM"
    await update.message.reply_text(msg)

def run_flask():
    flask_app.run(host="0.0.0.0", port=PORT)

async def main():
    if not BOT_TOKEN:
        logger.error("BOT_TOKEN not set!")
        return
    import threading
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()
    logger.info("Flask started on port " + str(PORT))
    application = Application.builder().token(BOT_TOKEN).build()
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("collect", collect_cmd))
    application.add_handler(CommandHandler("balance", balance_cmd))
    logger.info("Bot starting...")
    await application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == "__main__":
    asyncio.run(main())
