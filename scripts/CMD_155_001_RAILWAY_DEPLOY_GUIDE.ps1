# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_155
# File ID   : CMD_155_001
# Module    : Infrastructure | Railway Deploy
# Component : Free VPS Deployment Guide
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_155 - RAILWAY DEPLOY GUIDE" -ForegroundColor Cyan
Write-Host "Command   : CMD_155" -ForegroundColor Yellow
Write-Host "File ID   : CMD_155_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Deploy" -ForegroundColor Yellow
Write-Host "Component : Free VPS Deployment Guide" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "RAILWAY FREE TIER SETUP GUIDE" -ForegroundColor Green
Write-Host ""
Write-Host "Step 1: Create Account" -ForegroundColor Yellow
Write-Host "  1. Go to https://railway.app" -ForegroundColor White
Write-Host "  2. Sign up with GitHub" -ForegroundColor White
Write-Host "  3. Verify email" -ForegroundColor White
Write-Host ""
Write-Host "Step 2: Create Project" -ForegroundColor Yellow
Write-Host "  1. Click 'New Project'" -ForegroundColor White
Write-Host "  2. Select 'Deploy from GitHub repo'" -ForegroundColor White
Write-Host "  3. Connect your GitHub account" -ForegroundColor White
Write-Host ""
Write-Host "Step 3: Deploy NASRIUM Bot" -ForegroundColor Yellow
Write-Host "  1. Upload bot code to GitHub" -ForegroundColor White
Write-Host "  2. Select repo in Railway" -ForegroundColor White
Write-Host "  3. Add environment variables:" -ForegroundColor White
Write-Host "     - BOT_TOKEN = your_telegram_bot_token" -ForegroundColor White
Write-Host "     - WEBHOOK_URL = railway_url" -ForegroundColor White
Write-Host ""
Write-Host "Step 4: Get Public URL" -ForegroundColor Yellow
Write-Host "  1. Railway gives you free subdomain" -ForegroundColor White
Write-Host "  2. Example: https://nasrium-bot.up.railway.app" -ForegroundColor White
Write-Host "  3. Set this as webhook in Telegram" -ForegroundColor White
Write-Host ""
Write-Host "FREE TIER LIMITS:" -ForegroundColor Red
Write-Host "  - 5$ credit per month" -ForegroundColor White
Write-Host "  - ~500 hours runtime" -ForegroundColor White
Write-Host "  - Enough for testing!" -ForegroundColor White
Write-Host ""
Write-Host "ALTERNATIVE: ORACLE CLOUD (ALWAYS FREE)" -ForegroundColor Cyan
Write-Host "  - https://www.oracle.com/cloud/free/" -ForegroundColor White
Write-Host "  - 2 AMD CPU, 1GB RAM, 50GB storage" -ForegroundColor White
Write-Host "  - Forever free, no charges" -ForegroundColor White
Write-Host "  - Need credit card for verification only" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_155_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
