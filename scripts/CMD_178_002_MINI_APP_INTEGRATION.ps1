# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_178
# File ID   : CMD_178_002
# Module    : Frontend | Mini App Integration
# Component : Fix Directory Creation & Mini App Setup
# Version   : 1.0.1
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_178 - MINI APP INTEGRATION" -ForegroundColor Cyan
Write-Host "Command   : CMD_178" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RootDir = "D:\Nasrium"
Set-Location $RootDir

# Step 1: Explicitly create Mini App folder
Write-Host "[STEP 1] Creating Mini App directory..." -ForegroundColor Cyan
$miniAppDir = Join-Path $RootDir "mini_app"
if (-not (Test-Path $miniAppDir)) {
    New-Item -ItemType Directory -Path $miniAppDir -Force | Out-Null
    Write-Host "[OK] Directory created: $miniAppDir" -ForegroundColor Green
} else {
    Write-Host "[OK] Directory already exists: $miniAppDir" -ForegroundColor Yellow
}

# Step 2: Create HTML file
Write-Host ""
Write-Host "[STEP 2] Creating Mini App interface..." -ForegroundColor Cyan
$miniAppHTML = @"
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nasrium Game</title>
    <script src="https://telegram.org/js/telegram-web-app.js"></script>
    <style>
        body {
            font-family: Tahoma, sans-serif;
            background-color: #1a1a2e;
            color: #e94560;
            text-align: center;
            padding: 20px;
            margin: 0;
        }
        .container {
            background-color: #16213e;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
        }
        h1 { color: #0f3460; text-shadow: 1px 1px 2px black; }
        .btn {
            background-color: #e94560;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌟 به اکوسیستم NASRIUM خوش آمدید 🌟</h1>
        <p>وضعیت اتصال: <span id="status">در حال بارگذاری...</span></p>
        <button class="btn" onclick="sendData()">ارسال داده به ربات</button>
    </div>

    <script>
        const tg = window.Telegram.WebApp;
        tg.ready();
        tg.expand();
        
        document.getElementById('status').innerText = 'اتصال برقرار شد ✅';
        document.getElementById('status').style.color = '#4ecca3';

        function sendData() {
            const data = {
                action: 'launch_game',
                user: tg.initDataUnsafe?.user?.first_name || 'بازیکن'
            };
            tg.sendData(JSON.stringify(data));
            tg.close();
        }
    </script>
</body>
</html>
"@
$indexPath = Join-Path $miniAppDir "index.html"
Set-Content -Path $indexPath -Value $miniAppHTML -Encoding UTF8 -Force
Write-Host "[OK] mini_app/index.html created" -ForegroundColor Green

# Step 3: Update requirements.txt to include Flask
Write-Host ""
Write-Host "[STEP 3] Updating requirements.txt..." -ForegroundColor Cyan
"python-telegram-bot`nFlask" | Set-Content "requirements.txt" -Encoding UTF8
Write-Host "[OK] Flask added to requirements" -ForegroundColor Green

# Step 4: Update main.py to run Flask + Bot together
Write-Host ""
Write-Host "[STEP 4] Updating main.py for Flask + Bot..." -ForegroundColor Cyan
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
    # ساخت دکمه باز کردن Mini App
    webapp_url = "https://your-railway-app.up.railway.app/mini_app" # این آدرس بعداً اصلاح میشود
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
Write-Host "[OK] main.py updated with Flask and WebApp button" -ForegroundColor Green

# Step 5: Git Commit and Push
Write-Host ""
Write-Host "[STEP 5] Committing and pushing to GitHub..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_178: Add Mini App interface, Flask server, and WebApp button"
$branch = git branch --show-current
git push origin $branch --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_178_002 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT STEP IN RAILWAY:" -ForegroundColor Yellow
Write-Host "1. Wait for build to finish (Flask will be installed)" -ForegroundColor White
Write-Host "2. Test the bot /start in Telegram" -ForegroundColor White
Write-Host "3. We will update the WebApp URL in the next command!" -ForegroundColor Cyan
