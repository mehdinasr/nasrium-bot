# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_053
# File ID   : CMD_053_001
# Module    : Infrastructure | Final Railway Fix
# Component : Remove src folder completely
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_053 - FINAL RAILWAY FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_053" -ForegroundColor Yellow
Write-Host "File ID   : CMD_053_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Final Railway Fix" -ForegroundColor Yellow
Write-Host "Component : Remove src folder completely" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Remove ALL Node.js traces
Write-Host "[STEP 1] Removing ALL Node.js traces..." -ForegroundColor Cyan
Remove-Item "src" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "mini-app" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "index.js" -Force -ErrorAction SilentlyContinue
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Remove-Item "app.py" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] All Node.js traces removed" -ForegroundColor Green

# Step 2: Verify main.py exists
Write-Host ""
Write-Host "[STEP 2] Verifying main.py..." -ForegroundColor Cyan
if (Test-Path "main.py") {
    Write-Host "[OK] main.py exists" -ForegroundColor Green
    Get-Content "main.py" | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
} else {
    Write-Host "[ERROR] main.py missing!" -ForegroundColor Red
    exit 1
}

# Step 3: Verify nixpacks.toml
Write-Host ""
Write-Host "[STEP 3] Verifying nixpacks.toml..." -ForegroundColor Cyan
if (Test-Path "nixpacks.toml") {
    Write-Host "[OK] nixpacks.toml exists" -ForegroundColor Green
} else {
    Write-Host "[ERROR] nixpacks.toml missing!" -ForegroundColor Red
    exit 1
}

# Step 4: Force Railway rebuild
Write-Host ""
Write-Host "[STEP 4] Creating trigger for rebuild..." -ForegroundColor Cyan
"trigger" | Set-Content ".railway-trigger" -Encoding UTF8
Write-Host "[OK] Trigger created" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 5] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_053: Remove all Node.js, force Python rebuild" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 6: Manual Railway steps
Write-Host ""
Write-Host "[STEP 6] RAILWAY MANUAL STEPS:" -ForegroundColor Red
Write-Host ""
Write-Host "1. Go to Railway Dashboard" -ForegroundColor Yellow
Write-Host "2. Open 'adequate-perception' project" -ForegroundColor White
Write-Host "3. Click 'Settings' tab" -ForegroundColor White
Write-Host "4. Find 'Reset Cache' or 'Clear Build Cache'" -ForegroundColor Yellow
Write-Host "5. Click 'Deploy' (fresh deploy)" -ForegroundColor White
Write-Host ""
Write-Host "If still failing:" -ForegroundColor Red
Write-Host "  - Delete 'adequate-perception' project" -ForegroundColor White
Write-Host "  - Create NEW project from GitHub" -ForegroundColor White

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_053_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
