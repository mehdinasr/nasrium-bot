# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_162
# File ID   : CMD_162_001
# Module    : Infrastructure | Railway Deploy
# Component : Deploy NASRIUM to Railway
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_162 - RAILWAY DEPLOY" -ForegroundColor Cyan
Write-Host "Command   : CMD_162" -ForegroundColor Yellow
Write-Host "File ID   : CMD_162_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Deploy" -ForegroundColor Yellow
Write-Host "Component : Deploy NASRIUM to Railway" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "MANUAL STEPS (Railway.app):" -ForegroundColor Yellow
Write-Host ""
Write-Host "Step 1: Login to Railway" -ForegroundColor Cyan
Write-Host "  URL: https://railway.app" -ForegroundColor White
Write-Host "  Click: Login with GitHub" -ForegroundColor White
Write-Host ""
Write-Host "Step 2: Create New Project" -ForegroundColor Cyan
Write-Host "  Click: New Project" -ForegroundColor White
Write-Host "  Select: Deploy from GitHub repo" -ForegroundColor White
Write-Host ""
Write-Host "Step 3: Select Repository" -ForegroundColor Cyan
Write-Host "  Search: nasrium-bot" -ForegroundColor White
Write-Host "  Select: mehdinasr/nasrium-bot" -ForegroundColor White
Write-Host "  Click: Deploy" -ForegroundColor White
Write-Host ""
Write-Host "Step 4: Add Environment Variables" -ForegroundColor Cyan
Write-Host "  Click: Variables tab" -ForegroundColor White
Write-Host "  Add: BOT_TOKEN = your_telegram_bot_token" -ForegroundColor White
Write-Host "  Add: WEBHOOK_URL = (Railway will generate this)" -ForegroundColor White
Write-Host ""
Write-Host "Step 5: Get Public URL" -ForegroundColor Cyan
Write-Host "  Railway will give you: https://xxx.up.railway.app" -ForegroundColor White
Write-Host "  This is your bot webhook URL!" -ForegroundColor Green
Write-Host ""
Write-Host "Step 6: Set Telegram Webhook" -ForegroundColor Cyan
Write-Host "  Open browser:" -ForegroundColor White
Write-Host "  https://api.telegram.org/botYOUR_TOKEN/setWebhook?url=https://xxx.up.railway.app" -ForegroundColor Yellow
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_162_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
