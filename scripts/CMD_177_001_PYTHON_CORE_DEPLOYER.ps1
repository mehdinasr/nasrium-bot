# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_177
# File ID   : CMD_177_001
# Module    : Infrastructure | Python Core Deployer
# Component : Build Python files locally and force push to GitHub
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_177 - PYTHON CORE DEPLOYER" -ForegroundColor Cyan
Write-Host "Command   : CMD_177" -ForegroundColor Yellow
Write-Host "File ID   : CMD_177_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Python Core Deployer" -ForegroundColor Yellow
Write-Host "Component : Build and Force Push Python Core" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

# Step 1: Create main.py (Bot core + Health Check)
Write-Host "[STEP 1] Creating main.py..." -ForegroundColor Cyan
$mainPy = @"
import os
import asyncio
from http.server import BaseHTTPRequestHandler, HTTPServer
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

# --- Web Server for Railway Health Check ---
class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Nasrium Bot is running!")

def run_health_server():
    port = int(os.environ.get("PORT", 8080))
    server = HTTPServer(('0.0.0.0', port), HealthCheckHandler)
    server.serve_forever()

# --- Telegram Bot ---
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("🌟 به اکوسیستم جهانی NASRIUM خوش آمدید! 🌟")

def main():
    # Start Health Check in background (important for Railway)
    import threading
    threading.Thread(target=run_health_server, daemon=True).start()

    # Start Telegram Bot
    token = os.environ.get("BOT_TOKEN")
    if not token:
        print("ERROR: BOT_TOKEN not found!")
        return
        
    app = Application.builder().token(token).build()
    app.add_handler(CommandHandler("start", start))
    print("Nasrium Bot is starting...")
    app.run_polling()

if __name__ == "__main__":
    main()
"@
$mainPy | Set-Content "main.py" -Encoding UTF8
Write-Host "[OK] main.py created" -ForegroundColor Green

# Step 2: Create requirements.txt
Write-Host ""
Write-Host "[STEP 2] Creating requirements.txt..." -ForegroundColor Cyan
"python-telegram-bot" | Set-Content "requirements.txt" -Encoding UTF8
Write-Host "[OK] requirements.txt created" -ForegroundColor Green

# Step 3: Create Dockerfile
Write-Host ""
Write-Host "[STEP 3] Creating Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "main.py"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile created" -ForegroundColor Green

# Step 4: Create railway.toml
Write-Host ""
Write-Host "[STEP 4] Creating railway.toml..." -ForegroundColor Cyan
$railwayToml = @"
[build]
builder = "DOCKERFILE"
dockerfilePath = "./Dockerfile"
"@
$railwayToml | Set-Content "railway.toml" -Encoding UTF8
Write-Host "[OK] railway.toml created" -ForegroundColor Green

# Step 5: Force Git to accept and push everything
Write-Host ""
Write-Host "[STEP 5] Force pushing to GitHub..." -ForegroundColor Cyan

# Ensure we are on main branch
git checkout -B main

# Force add all files (overrides .gitignore if needed)
git add -f main.py requirements.txt Dockerfile railway.toml

# Commit
git commit -m "CMD_177: Force push Python core, deleted all Node.js"

# Push forcefully
git push -u origin main --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_177_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "GITHUB IS NOW PYTHON READY!" -ForegroundColor Green
Write-Host "Go to Railway and click Redeploy." -ForegroundColor Yellow
