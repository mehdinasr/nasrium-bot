# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_170
# File ID   : CMD_170_001
# Module    : Infrastructure | Railway Cache Fix
# Component : Force Railway to detect changes
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_170 - RAILWAY CACHE FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_170" -ForegroundColor Yellow
Write-Host "File ID   : CMD_170_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Cache Fix" -ForegroundColor Yellow
Write-Host "Component : Force Railway to detect changes" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Add a dummy file to force change detection
Write-Host "[STEP 1] Adding trigger file..." -ForegroundColor Cyan
"trigger" | Set-Content ".railway-trigger" -Encoding UTF8
Write-Host "[OK] Trigger file added" -ForegroundColor Green

# Step 2: Commit and push
Write-Host ""
Write-Host "[STEP 2] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_170: Force Railway deploy trigger"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_170_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway!" -ForegroundColor Yellow
Write-Host "Deploy button should be ACTIVE now!" -ForegroundColor Green
