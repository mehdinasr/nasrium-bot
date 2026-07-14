# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_157
# File ID   : CMD_157_001
# Module    : Infrastructure | GitHub Setup
# Component : Create GitHub Repo and Push
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_157 - GITHUB SETUP" -ForegroundColor Cyan
Write-Host "Command   : CMD_157" -ForegroundColor Yellow
Write-Host "File ID   : CMD_157_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | GitHub Setup" -ForegroundColor Yellow
Write-Host "Component : Create GitHub Repo and Push" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "MANUAL STEPS (GitHub.com):" -ForegroundColor Yellow
Write-Host ""
Write-Host "Step 1: Create GitHub Account" -ForegroundColor Cyan
Write-Host "  1. Go to https://github.com/signup" -ForegroundColor White
Write-Host "  2. Enter email, password, username" -ForegroundColor White
Write-Host "  3. Verify email" -ForegroundColor White
Write-Host ""
Write-Host "Step 2: Create Repository" -ForegroundColor Cyan
Write-Host "  1. Click '+' → 'New repository'" -ForegroundColor White
Write-Host "  2. Name: nasrium-bot" -ForegroundColor White
Write-Host "  3. Select 'Public'" -ForegroundColor White
Write-Host "  4. Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "Step 3: Install Git" -ForegroundColor Cyan
Write-Host "  1. Download from https://git-scm.com/download/win" -ForegroundColor White
Write-Host "  2. Install with default settings" -ForegroundColor White
Write-Host ""
Write-Host "Step 4: Push Code" -ForegroundColor Cyan
Write-Host "  Run these commands in PowerShell:" -ForegroundColor White
Write-Host ""
Write-Host "  cd D:\NASRIUM\railway-deploy" -ForegroundColor Green
Write-Host "  git init" -ForegroundColor Green
Write-Host "  git add ." -ForegroundColor Green
Write-Host "  git commit -m 'Initial NASRIUM deploy'" -ForegroundColor Green
Write-Host "  git branch -M main" -ForegroundColor Green
Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/nasrium-bot.git" -ForegroundColor Green
Write-Host "  git push -u origin main" -ForegroundColor Green
Write-Host ""
Write-Host "Step 5: Connect Railway" -ForegroundColor Cyan
Write-Host "  1. Go to https://railway.app" -ForegroundColor White
Write-Host "  2. Login with GitHub" -ForegroundColor White
Write-Host "  3. Click 'New Project'" -ForegroundColor White
Write-Host "  4. Select 'Deploy from GitHub repo'" -ForegroundColor White
Write-Host "  5. Select 'nasrium-bot'" -ForegroundColor White
Write-Host "  6. Click 'Deploy'" -ForegroundColor White
Write-Host ""
Write-Host "Step 6: Add Environment Variables" -ForegroundColor Cyan
Write-Host "  1. In Railway dashboard, click 'Variables'" -ForegroundColor White
Write-Host "  2. Add: BOT_TOKEN = your_telegram_bot_token" -ForegroundColor White
Write-Host "  3. Add: WEBHOOK_URL = (Railway will give you URL)" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_157_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_157
# File ID   : CMD_157_001
# Module    : Infrastructure | GitHub Setup
# Component : Create GitHub Repo and Push
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_157 - GITHUB SETUP" -ForegroundColor Cyan
Write-Host "Command   : CMD_157" -ForegroundColor Yellow
Write-Host "File ID   : CMD_157_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | GitHub Setup" -ForegroundColor Yellow
Write-Host "Component : Create GitHub Repo and Push" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "MANUAL STEPS (GitHub.com):" -ForegroundColor Yellow
Write-Host ""
Write-Host "Step 1: Create GitHub Account" -ForegroundColor Cyan
Write-Host "  1. Go to https://github.com/signup" -ForegroundColor White
Write-Host "  2. Enter email, password, username" -ForegroundColor White
Write-Host "  3. Verify email" -ForegroundColor White
Write-Host ""
Write-Host "Step 2: Create Repository" -ForegroundColor Cyan
Write-Host "  1. Click '+' → 'New repository'" -ForegroundColor White
Write-Host "  2. Name: nasrium-bot" -ForegroundColor White
Write-Host "  3. Select 'Public'" -ForegroundColor White
Write-Host "  4. Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "Step 3: Install Git" -ForegroundColor Cyan
Write-Host "  1. Download from https://git-scm.com/download/win" -ForegroundColor White
Write-Host "  2. Install with default settings" -ForegroundColor White
Write-Host ""
Write-Host "Step 4: Push Code" -ForegroundColor Cyan
Write-Host "  Run these commands in PowerShell:" -ForegroundColor White
Write-Host ""
Write-Host "  cd D:\NASRIUM\railway-deploy" -ForegroundColor Green
Write-Host "  git init" -ForegroundColor Green
Write-Host "  git add ." -ForegroundColor Green
Write-Host "  git commit -m 'Initial NASRIUM deploy'" -ForegroundColor Green
Write-Host "  git branch -M main" -ForegroundColor Green
Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/nasrium-bot.git" -ForegroundColor Green
Write-Host "  git push -u origin main" -ForegroundColor Green
Write-Host ""
Write-Host "Step 5: Connect Railway" -ForegroundColor Cyan
Write-Host "  1. Go to https://railway.app" -ForegroundColor White
Write-Host "  2. Login with GitHub" -ForegroundColor White
Write-Host "  3. Click 'New Project'" -ForegroundColor White
Write-Host "  4. Select 'Deploy from GitHub repo'" -ForegroundColor White
Write-Host "  5. Select 'nasrium-bot'" -ForegroundColor White
Write-Host "  6. Click 'Deploy'" -ForegroundColor White
Write-Host ""
Write-Host "Step 6: Add Environment Variables" -ForegroundColor Cyan
Write-Host "  1. In Railway dashboard, click 'Variables'" -ForegroundColor White
Write-Host "  2. Add: BOT_TOKEN = your_telegram_bot_token" -ForegroundColor White
Write-Host "  3. Add: WEBHOOK_URL = (Railway will give you URL)" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_157_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
