# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_052
# File ID   : CMD_052_001
# Module    : Infrastructure | Fix main.py creation
# Component : Create main.py without PowerShell conflicts
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_052 - FIX MAIN.PY CREATION" -ForegroundColor Cyan
Write-Host "Command   : CMD_052" -ForegroundColor Yellow
Write-Host "File ID   : CMD_052_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Fix main.py creation" -ForegroundColor Yellow
Write-Host "Component : Create main.py without conflicts" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Create main.py using Python (no PowerShell conflicts)
Write-Host "[STEP 1] Creating main.py via Python..." -ForegroundColor Cyan

$pythonScript = @"
import os

main_py = '''import os
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
'''

with open("main.py", "w", encoding="utf-8") as f:
    f.write(main_py)

print("main.py created successfully")
"@

$pythonScript | Set-Content "temp_create.py" -Encoding UTF8
python "temp_create.py"
Remove-Item "temp_create.py" -Force
Write-Host "[OK] main.py created" -ForegroundColor Green

# Step 2: Create requirements.txt
Write-Host ""
Write-Host "[STEP 2] Creating requirements.txt..." -ForegroundColor Cyan
"flask>=2.0" | Set-Content "requirements.txt" -Encoding UTF8
"flask-cors>=4.0" | Add-Content "requirements.txt" -Encoding UTF8
"python-telegram-bot>=20.0" | Add-Content "requirements.txt" -Encoding UTF8
Write-Host "[OK] requirements.txt created" -ForegroundColor Green

# Step 3: Create nixpacks.toml
Write-Host ""
Write-Host "[STEP 3] Creating nixpacks.toml..." -ForegroundColor Cyan
$nixpacks = '[phases.setup]
nixPkgs = ["python311"]

[phases.install]
cmds = ["python -m venv /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt"]

[phases.build]
cmds = []

[start]
cmd = "/opt/venv/bin/python main.py"'
$nixpacks | Set-Content "nixpacks.toml" -Encoding UTF8
Write-Host "[OK] nixpacks.toml created" -ForegroundColor Green

# Step 4: Commit
Write-Host ""
Write-Host "[STEP 4] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_052: Recreate main.py with Python" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 5: Redeploy
Write-Host ""
Write-Host "[STEP 5] Redeploy in Railway..." -ForegroundColor Cyan
Write-Host "  1. Go to Railway Dashboard" -ForegroundColor White
Write-Host "  2. Open 'adequate-perception' project" -ForegroundColor White
Write-Host "  3. Click 'Deploy'" -ForegroundColor White
Write-Host "  4. Add Variables:" -ForegroundColor Yellow
Write-Host "     BOT_TOKEN = your_telegram_token" -ForegroundColor Cyan
Write-Host "     PORT = 8080" -ForegroundColor Cyan

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_052_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
