# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_040
# File ID   : CMD_040_001
# Module    : Infrastructure | Nixpacks Fix
# Component : Force Railway to use Python with Nixpacks
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_040 - NIXPACKS FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_040" -ForegroundColor Yellow
Write-Host "File ID   : CMD_040_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Nixpacks Fix" -ForegroundColor Yellow
Write-Host "Component : Force Python build" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Create nixpacks.toml to force Python
Write-Host "[STEP 1] Creating nixpacks.toml..." -ForegroundColor Cyan
$nixpacks = @"
[phases.setup]
nixPkgs = ["python311", "gcc"]

[phases.install]
cmds = ["python -m venv /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt"]

[phases.build]
cmds = []

[start]
cmd = "/opt/venv/bin/python mini_api.py"
"@
$nixpacks | Set-Content "nixpacks.toml" -Encoding UTF8
Write-Host "[OK] nixpacks.toml created" -ForegroundColor Green

# Step 2: Ensure no Node.js files exist
Write-Host ""
Write-Host "[STEP 2] Cleaning Node.js files..." -ForegroundColor Cyan
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Cleaned" -ForegroundColor Green

# Step 3: Update Procfile for Nixpacks
Write-Host ""
Write-Host "[STEP 3] Updating Procfile..." -ForegroundColor Cyan
"web: python mini_api.py" | Set-Content "Procfile" -Encoding UTF8
Write-Host "[OK] Procfile updated" -ForegroundColor Green

# Step 4: Commit
Write-Host ""
Write-Host "[STEP 4] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_040: Add nixpacks.toml for Python build" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 5: Instructions
Write-Host ""
Write-Host "[STEP 5] Railway Deploy..." -ForegroundColor Cyan
Write-Host ""
Write-Host "NOW IN RAILWAY:" -ForegroundColor Yellow
Write-Host "  1. Click Deploy (Auto-Detect will use nixpacks.toml)" -ForegroundColor White
Write-Host "  2. Wait for build" -ForegroundColor White
Write-Host "  3. If still crashes, click 'View logs'" -ForegroundColor White
Write-Host ""
Write-Host "If nixpacks.toml not detected:" -ForegroundColor Red
Write-Host "  - Variables tab" -ForegroundColor White
Write-Host "  - Add: NIXPACKS_PYTHON_VERSION = 3.11" -ForegroundColor Yellow

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_040_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
