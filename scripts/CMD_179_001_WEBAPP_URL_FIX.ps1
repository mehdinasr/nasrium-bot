# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_179
# File ID   : CMD_179_001
# Module    : Frontend | Mini App Integration
# Component : Update WebApp URL to Railway Public Domain
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_179 - MINI APP URL FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_179" -ForegroundColor Yellow
Write-Host "Module    : Frontend | Mini App Integration" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

# Step 1: Update main.py with the real Railway URL
Write-Host "[STEP 1] Updating main.py with Railway Public URL..." -ForegroundColor Cyan
$mainPy = @"
import os
import threading
from flask import Flask, send_from_directory
from telegram import Update, ReplyKeyboardMarkup, KeyboardButton, WebAppInfo
from telegram.ext import Application, CommandHandler, ContextTypes

# --- Flask Web Server for Mini App & Health Check ---
app = Flask(__name__, static_folder='mini_app')

@app.route('/')
def health_check():
    return "Nasrium Bot is running!", 200

@app.route('/mini_app')
def serve_mini_app():
    return send_from_directory('mini_app', 'index.html')

def run_flask():
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port)

# --- Telegram Bot ---
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    # آدرس واقعی Mini App در Railway
    webapp_url = "https://nasrium-bot-production.up.railway.app/mini_app"
    keyboard = [[KeyboardButton(text="🎮 ورود به بازی NASRIUM", web_app=WebAppInfo(url=webapp_url))]]
    reply_markup = ReplyKeyboardMarkup(keyboard, resize_keyboard=True)
    
    await update.message.reply_text(
        "🌟 به اکوسیستم جهانی NASRIUM خوش آمدید! 🌟\n\n"
        "برای ورود به بازی و مدیریت دهکده خود دکمه زیر را بزنید:",
        reply_markup=reply_markup
    )

def main():
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
Write-Host "[OK] main.py updated with real URL" -ForegroundColor Green

# Step 2: Git Commit and Push
Write-Host ""
Write-Host "[STEP 2] Committing and pushing to GitHub..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_179: Connect Mini App to Railway public domain"
$branch = git branch --show-current
git push origin $branch --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_179_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Set WebApp Domain in BotFather!" -ForegroundColor Yellow
