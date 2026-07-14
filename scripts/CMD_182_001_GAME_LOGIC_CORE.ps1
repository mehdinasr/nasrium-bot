# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_182
# File ID   : CMD_182_001
# Module    : Backend | Game Logic Core
# Component : Economy Engine, Profile, Collect, Town Hall
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_182 - GAME LOGIC CORE" -ForegroundColor Cyan
Write-Host "Command   : CMD_182" -ForegroundColor Yellow
Write-Host "Module    : Backend | Game Logic Core" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

# Step 1: Update main.py with Game Logic
Write-Host "[STEP 1] Updating main.py with Economy Engine..." -ForegroundColor Cyan
$mainPy = @"
import os
import threading
from datetime import datetime
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
            players_collection.create_index("user_id", unique=True)
            print("✅ MongoDB connected successfully!")
        except Exception as e:
            print(f"❌ MongoDB connection failed: {e}")
    else:
        print("⚠️ MONGO_URL not found! Database will not work.")

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
        "wallet_address": None,
        "last_collect_time": datetime.utcnow()
    }
    players_collection.insert_one(new_player)
    return new_player

# --- Telegram Bot Commands ---
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    player = get_player(user.id)
    
    if not player:
        player = create_player(user.id, user.first_name)
        welcome_msg = (
            f"👑 خوش آمدی `{user.first_name}`!\n\n"
            f"تو به عنوان رهبر یک دهکده جدید ثبت شدی 🌟\n"
            f"🎁 جایزه شروع: `500` طلا و `10` جم!\n\n"
            f"از منوی زیر بازی رو شروع کن:"
        )
    else:
        welcome_msg = (
            f"سلام دوباره `{user.first_name}`! 👋\n"
            f"برای ورود به بازی دکمه زیر را بزن:"
        )

    webapp_url = "https://nasrium-bot-production.up.railway.app/mini_app"
    keyboard = [
        [InlineKeyboardButton(text="🎮 ورود به بازی NASRIUM", web_app=WebAppInfo(url=webapp_url))],
        [
            InlineKeyboardButton("👤 پروفایل", callback_data="cmd_profile"),
            InlineKeyboardButton("📦 جمعآوری", callback_data="cmd_collect")
        ]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text(welcome_msg, reply_markup=reply_markup)

async def profile(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    player = get_player(user.id)
    if not player:
        await update.message.reply_text("شما هنوز ثبت نام نکردهاید! ابتدا `/start` را بزنید.")
        return

    th_levels = ["Village", "Hamlet", "Town", "City", "Kingdom", "Empire", "Dominion", "Realm", "Nasrium"]
    th_name = th_levels[player['town_hall_level'] - 1]

    msg = (
        f"👤 پروفایل رهبر: `{player['first_name']}`\n"
        f"━━━━━━━━━━━━━━━\n"
        f"🏛️ سطح `Town Hall`: `{player['town_hall_level']}` (`{th_name}`)\n"
        f"💰 طلا: `{player['gold']}`\n"
        f"💎 جم: `{player['gems']}`\n"
        f"🪙 توکن `NSM` (کل): `{player['nsm_total']}`\n"
        f"💸 توکن `NSM` (قابل برداشت): `{player['nsm_withdrawable']}`\n"
    )
    await update.message.reply_text(msg)

async def collect(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    player = get_player(user.id)
    if not player:
        await update.message.reply_text("شما هنوز ثبت نام نکردهاید! ابتدا `/start` را بزنید.")
        return

    now = datetime.utcnow()
    last_collect = player.get("last_collect_time", now)
    
    time_diff = now - last_collect
    minutes_passed = max(0, time_diff.total_seconds() // 60)

    if minutes_passed < 1:
        await update.message.reply_text("⏳ منابع هنوز آماده نیستند! لطفا کمی صبر کنید.")
        return

    # نرخ تولید بر اساس سطح Town Hall
    th_lvl = player['town_hall_level']
    gold_earned = int(minutes_passed * 5 * th_lvl)
    gems_earned = int(minutes_passed * 0.1 * th_lvl)
    nsm_earned = int(minutes_passed * 0.5 * th_lvl)

    new_gold = player['gold'] + gold_earned
    new_gems = player['gems'] + gems_earned
    new_nsm = player['nsm_total'] + nsm_earned
    new_withdrawable = player['nsm_withdrawable'] + int(nsm_earned * 0.1) # 10% قابل برداشت

    players_collection.update_one(
        {"user_id": user.id},
        {"$set": {
            "gold": new_gold,
            "gems": new_gems,
            "nsm_total": new_nsm,
            "nsm_withdrawable": new_withdrawable,
            "last_collect_time": now
        }}
    )

    msg = (
        f"📦 منابع با موفقیت جمعآوری شد!\n"
        f"━━━━━━━━━━━━━━━\n"
        f"⏱️ زمان گذشته: `{int(minutes_passed)}` دقیقه\n"
        f"💰 طلا کسب شده: `{gold_earned}`\n"
        f"💎 جم کسب شده: `{gems_earned}`\n"
        f"🪙 توکن `NSM` کسب شده: `{nsm_earned}`\n"
        f"━━━━━━━━━━━━━━━\n"
        f"💡 برای دیدن موجودی از `/profile` استفاده کنید."
    )
    await update.message.reply_text(msg)

def main():
    init_db()
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()

    token = os.environ.get("BOT_TOKEN")
    if not token:
        print("ERROR: BOT_TOKEN not found!")
        return
        
    bot_app = Application.builder().token(token).build()
    bot_app.add_handler(CommandHandler("start", start))
    bot_app.add_handler(CommandHandler("profile", profile))
    bot_app.add_handler(CommandHandler("collect", collect))
    print("Nasrium Bot & Game Logic are starting...")
    bot_app.run_polling()

if __name__ == "__main__":
    main()
"@
$mainPy | Set-Content "main.py" -Encoding UTF8
Write-Host "[OK] main.py updated with Game Logic" -ForegroundColor Green

# Step 2: Git Commit and Push
Write-Host ""
Write-Host "[STEP 2] Committing and pushing to GitHub..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_182: Add Game Logic, Economy Engine, Profile and Collect"
$branch = git branch --show-current
git push origin $branch --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_182_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test the new commands in Telegram:" -ForegroundColor Yellow
Write-Host "/profile" -ForegroundColor White
Write-Host "/collect" -ForegroundColor White
