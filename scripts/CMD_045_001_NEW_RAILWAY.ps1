# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_045
# File ID   : CMD_045_001
# Module    : Infrastructure | New Railway Project
# Component : Guide for creating new Railway project
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_045 - NEW RAILWAY PROJECT" -ForegroundColor Cyan
Write-Host "Command   : CMD_045" -ForegroundColor Yellow
Write-Host "File ID   : CMD_045_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | New Railway Project" -ForegroundColor Yellow
Write-Host "Component : Guide for Railway setup" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "MANUAL STEPS IN RAILWAY DASHBOARD:" -ForegroundColor Red
Write-Host ""

Write-Host "STEP 1: Create New Project" -ForegroundColor Yellow
Write-Host "  - Click: 'New Project'" -ForegroundColor White
Write-Host "  - Select: 'Deploy from GitHub repo'" -ForegroundColor White
Write-Host ""

Write-Host "STEP 2: Select Repository" -ForegroundColor Yellow
Write-Host "  - Choose: mehdinasr/nasrium-bot" -ForegroundColor White
Write-Host "  - Click: 'Deploy'" -ForegroundColor White
Write-Host ""

Write-Host "STEP 3: Wait for Build" -ForegroundColor Yellow
Write-Host "  - Should detect Python automatically" -ForegroundColor White
Write-Host "  - Watch for green checkmark" -ForegroundColor White
Write-Host ""

Write-Host "STEP 4: Add Variables" -ForegroundColor Green
Write-Host "  - Click: 'Variables' tab" -ForegroundColor White
Write-Host "  - Click: 'New Variable'" -ForegroundColor White
Write-Host "  - Name: BOT_TOKEN" -ForegroundColor Cyan
Write-Host "  - Value: your_telegram_bot_token" -ForegroundColor Cyan
Write-Host "  - Click: 'Add'" -ForegroundColor White
Write-Host "  - Name: PORT" -ForegroundColor Cyan
Write-Host "  - Value: 8080" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 5: Redeploy" -ForegroundColor Yellow
Write-Host "  - Click: 'Deploy' again" -ForegroundColor White
Write-Host "  - Wait for green checkmark" -ForegroundColor White
Write-Host ""

Write-Host "STEP 6: Get Domain" -ForegroundColor Green
Write-Host "  - Click: 'Settings' tab" -ForegroundColor White
Write-Host "  - Find: 'Domain'" -ForegroundColor White
Write-Host "  - Copy: URL (like nasrium-bot.up.railway.app)" -ForegroundColor Cyan
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_045_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After deploy, send me the URL!" -ForegroundColor Magenta
