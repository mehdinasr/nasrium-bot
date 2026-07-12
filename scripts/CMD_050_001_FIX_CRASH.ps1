# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_050
# File ID   : CMD_050_001
# Module    : Infrastructure | Fix Railway Crash
# Component : Remove old Node.js files, force Python
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_050 - FIX RAILWAY CRASH" -ForegroundColor Cyan
Write-Host "Command   : CMD_050" -ForegroundColor Yellow
Write-Host "File ID   : CMD_050_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Fix Railway Crash" -ForegroundColor Yellow
Write-Host "Component : Remove old Node.js files" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Remove ALL old Node.js files
Write-Host "[STEP 1] Removing old Node.js files..." -ForegroundColor Cyan
Remove-Item "src" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "index.js" -Force -ErrorAction SilentlyContinue
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Old files removed" -ForegroundColor Green

# Step 2: Verify main.py exists
Write-Host ""
Write-Host "[STEP 2] Verifying main.py..." -ForegroundColor Cyan
if (Test-Path "main.py") {
    $lines = (Get-Content "main.py").Count
    Write-Host "[OK] main.py exists ($lines lines)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] main.py missing!" -ForegroundColor Red
    exit 1
}

# Step 3: Verify requirements.txt
Write-Host ""
Write-Host "[STEP 3] Verifying requirements.txt..." -ForegroundColor Cyan
if (Test-Path "requirements.txt") {
    Write-Host "[OK] requirements.txt exists" -ForegroundColor Green
} else {
    Write-Host "[ERROR] requirements.txt missing!" -ForegroundColor Red
    exit 1
}

# Step 4: Create nixpacks.toml
Write-Host ""
Write-Host "[STEP 4] Creating nixpacks.toml..." -ForegroundColor Cyan
$nixpacks = '[phases.setup]
nixPkgs = ["python311"]

[phases.install]
cmds = ["python -m venv /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt"]

[phases.build]
cmds = []

[start]
cmd = "/opt/venv/bin/python main.py"'
$nixpacks | Set-Content "nixpacks.toml" -Encoding UTF8
Write-Host "[OK] nixpacks.toml created" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 5] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_050: Remove old Node.js, force Python" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 6: Redeploy
Write-Host ""
Write-Host "[STEP 6] Redeploy in Railway..." -ForegroundColor Cyan
Write-Host "  1. Go to Railway Dashboard" -ForegroundColor White
Write-Host "  2. Open 'adequate-perception' project" -ForegroundColor White
Write-Host "  3. Click 'Deploy' or wait for auto-deploy" -ForegroundColor White
Write-Host "  4. Add Variables if needed:" -ForegroundColor Yellow
Write-Host "     BOT_TOKEN = your_telegram_token" -ForegroundColor Cyan
Write-Host "     PORT = 8080" -ForegroundColor Cyan

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_050_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
