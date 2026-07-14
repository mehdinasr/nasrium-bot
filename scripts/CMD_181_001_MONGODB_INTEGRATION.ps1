# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_181
# File ID   : CMD_181_001
# Module    : Backend | Database Integration
# Component : MongoDB Connection & Player Persistence
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_181 - MONGODB INTEGRATION" -ForegroundColor Cyan
Write-Host "Command   : CMD_181" -ForegroundColor Yellow
Write-Host "Module    : Backend | Database Integration" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

# Step 1: Update requirements.txt
Write-Host "[STEP 1] Updating requirements.txt..." -ForegroundColor Cyan
"python-telegram-bot`nFlask`npymongo" | Set-Content "requirements.txt" -Encoding UTF8
Write-Host "[OK] pymongo added to requirements" -ForegroundColor Green

# Step 2: Update main.py with MongoDB logic
Write-Host ""
Write-Host "[STEP 2] Updating main.py with MongoDB persistence..." -ForegroundColor Cyan
$mainPy = @"
import os
import threading
from flask import Flask, send_from_directory
from pymongo import MongoClient
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup, WebAppInfo
from telegram.ext import Application, CommandHandler, ContextTypes

# --- Flask Web Server for Mini App & Health Check ---
app_flask = Flask(__name__, static_folder='mini_app')

@app_flask.route('/')
def health_check():
    return "Nasrium Bot is running!", 200

@app_flask.route('/mini_app')
def serve_mini_app():
    return send_from_directory('mini_app', 'index.html')

def run_flask():
    port = int(os.environ.get("PORT", 8080))
    app_flask.run(host='0.0.0.0', port=port)

# --- MongoDB Setup ---
MONGO_URL = os.environ.get("MONGO_URL")
mongo_client = None
db = None
players_collection = None

def init_db():
    global mongo_client, db, players_collection
    if MONGO_URL:
        try:
            mongo_client = MongoClient(MONGO_URL)
            db = mongo_client.nasrium_db
            players_collection = db.players
            # ایجاد ایندکس برای جلوگیری از ثبت نام تکراری
            players_collection.create_index("user_id", unique=True)
            print("✅ MongoDB connected successfully!")
        except Exception as e:
            print(f"❌ MongoDB connection failed: {e}")
    else:
        print("⚠️ MONGO_URL not found! Database will not work.")

# --- Database Helper Functions ---
def get_player(user_id):
    if players_collection is None: return None
    return players_collection.find_one({"user_id": user_id})

def create_player(user_id, first_name):
    if players_collection is None: return
    new_player = {
        "user_id": user_id,
        "first_name": first_name,
        "gold": 500,
        "gems": 10,
        "nsm_total": 0,
        "nsm_withdrawable": 0,
        "town_hall_level": 1,
        "wallet_address": None
    }
    players_collection.insert_one(new_player)
    return new_player

# --- Telegram Bot ---
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    player = get_player(user.id)
    
    if not player:
        player = create_player(user.id, user.first_name)
        welcome_msg = (
            f"👑 خوش آمدی `{user.first_name}`!\n\n"
            f"تو به عنوان رهبر یک دهکده جدید در اکوسیستم `NASRIUM` ثبت شدی 🌟\n"
            f"🎁 جایزه شروع: `500` طلا و `10` جم به حسابت اضافه شد!\n\n"
            f"برای مدیریت دهکده دکمه زیر را بزن:"
        )
    else:
        welcome_msg = (
            f"سلام دوباره `{user.first_name}`! 👋\n"
            f"💰 طلا: `{player['gold']}` | 💎 جم: `{player['gems']}`\n"
            f"🏛️ سطح `Town Hall`: `{player['town_hall_level']}`\n\n"
            f"برای ورود به بازی دکمه زیر را بزن:"
        )

    webapp_url = "https://nasrium-bot-production.up.railway.app/mini_app"
    keyboard = [[InlineKeyboardButton(text="🎮 ورود به بازی NASRIUM", web_app=WebAppInfo(url=webapp_url))]]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    await update.message.reply_text(welcome_msg, reply_markup=reply_markup)

def main():
    # راهاندازی دیتابیس
    init_db()

    # اجرای Flask در یک Thread جداگانه برای Railway
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()

    # اجرای ربات تلگرام
    token = os.environ.get("BOT_TOKEN")
    if not token:
        print("ERROR: BOT_TOKEN not found!")
        return
        
    bot_app = Application.builder().token(token).build()
    bot_app.add_handler(CommandHandler("start", start))
    print("Nasrium Bot & Flask Server are starting...")
    bot_app.run_polling()

if __name__ == "__main__":
    main()
"@
$mainPy | Set-Content "main.py" -Encoding UTF8
Write-Host "[OK] main.py updated with MongoDB logic" -ForegroundColor Green

# Step 3: Git Commit and Push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing to GitHub..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_181: Integrate MongoDB for persistent player data"
$branch = git branch --show-current
git push origin $branch --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_181_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "CRITICAL RAILWAY STEPS:" -ForegroundColor Red
Write-Host "1. Go to Railway Dashboard" -ForegroundColor White
Write-Host "2. Click 'New' -> 'Database' -> 'MongoDB'" -ForegroundColor Yellow
Write-Host "3. Copy the Connection URL (MONGO_URL)" -ForegroundColor Yellow
Write-Host "4. Add MONGO_URL to your Bot Variables" -ForegroundColor White
Write-Host "5. Redeploy the Bot" -ForegroundColor White
