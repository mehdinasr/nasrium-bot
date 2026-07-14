# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_058
# File ID   : CMD_058_001
# Module    : Infrastructure | GitHub Railway Sync
# Component : Force Railway to use latest code
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_058 - GITHUB RAILWAY SYNC" -ForegroundColor Cyan
Write-Host "Command   : CMD_058" -ForegroundColor Yellow
Write-Host "File ID   : CMD_058_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | GitHub Railway Sync" -ForegroundColor Yellow
Write-Host "Component : Force latest code deploy" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Check current branch
Write-Host "[STEP 1] Checking current branch..." -ForegroundColor Cyan
$branch = git branch --show-current
Write-Host "Current branch: $branch" -ForegroundColor White

# Step 2: Check last commit
Write-Host ""
Write-Host "[STEP 2] Checking last commit..." -ForegroundColor Cyan
$lastCommit = git log -1 --oneline
Write-Host "Last commit: $lastCommit" -ForegroundColor White

# Step 3: Force push to trigger Railway
Write-Host ""
Write-Host "[STEP 3] Creating trigger commit..." -ForegroundColor Cyan
"trigger-$(Get-Date -Format 'yyyyMMddHHmmss')" | Set-Content ".railway-trigger" -Encoding UTF8
git add .
git commit -m "CMD_058: Force Railway sync - trigger rebuild" --allow-empty
git push origin $branch
Write-Host "[OK] Pushed trigger commit" -ForegroundColor Green

# Step 4: Verify push
Write-Host ""
Write-Host "[STEP 4] Verifying push..." -ForegroundColor Cyan
$latestCommit = git log -1 --oneline
Write-Host "Latest commit: $latestCommit" -ForegroundColor White

# Step 5: Instructions
Write-Host ""
Write-Host "[STEP 5] RAILWAY MANUAL STEPS:" -ForegroundColor Red
Write-Host ""
Write-Host "1. Go to Railway Dashboard" -ForegroundColor Yellow
Write-Host "2. Open 'adequate-perception'" -ForegroundColor White
Write-Host "3. Check if new deploy started" -ForegroundColor White
Write-Host ""
Write-Host "If still CMD_174:" -ForegroundColor Red
Write-Host "  - Click 'Settings'" -ForegroundColor White
Write-Host "  - Find 'Reset Cache' or 'Clear Build Cache'" -ForegroundColor Yellow
Write-Host "  - Click 'Deploy' again" -ForegroundColor White
Write-Host ""
Write-Host "OR:" -ForegroundColor Red
Write-Host "  - Delete project" -ForegroundColor White
Write-Host "  - New Project from GitHub" -ForegroundColor White
Write-Host "  - Choose: mehdinasr/nasrium-bot" -ForegroundColor Cyan

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_058_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
