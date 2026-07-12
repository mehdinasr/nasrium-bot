# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_171
# File ID   : CMD_171_001
# Module    : Infrastructure | Railway Real Change
# Component : Make real code change to trigger deploy
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_171 - RAILWAY REAL CHANGE" -ForegroundColor Cyan
Write-Host "Command   : CMD_171" -ForegroundColor Yellow
Write-Host "File ID   : CMD_171_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Real Change" -ForegroundColor Yellow
Write-Host "Component : Make real code change to trigger deploy" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Modify package.json (real change)
Write-Host "[STEP 1] Modifying package.json..." -ForegroundColor Cyan
$pkg = Get-Content "package.json" | ConvertFrom-Json
$pkg.description = "NASRIUM Official Telegram Bot - Railway Deploy"
$pkg | ConvertTo-Json -Depth 10 | Set-Content "package.json" -Encoding UTF8
Write-Host "[OK] package.json modified" -ForegroundColor Green

# Step 2: Remove trigger file
Write-Host ""
Write-Host "[STEP 2] Removing trigger file..." -ForegroundColor Cyan
Remove-Item ".railway-trigger" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Trigger file removed" -ForegroundColor Green

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_171: Update description for Railway deploy"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_171_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway!" -ForegroundColor Yellow
Write-Host "Deploy button should be ACTIVE now!" -ForegroundColor Green
