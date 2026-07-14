# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_041
# File ID   : CMD_041_001
# Module    : Infrastructure | Railway Node Fix
# Component : Remove Node.js detection completely
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_041 - RAILWAY NODE FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_041" -ForegroundColor Yellow
Write-Host "File ID   : CMD_041_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Node Fix" -ForegroundColor Yellow
Write-Host "Component : Remove Node.js detection" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Create .nixpacks to force Python
Write-Host "[STEP 1] Creating .nixpacks..." -ForegroundColor Cyan
$nixpacks = @"
providers = ["python"]
"@
$nixpacks | Set-Content ".nixpacks" -Encoding UTF8
Write-Host "[OK] .nixpacks created" -ForegroundColor Green

# Step 2: Remove ALL Node.js traces
Write-Host ""
Write-Host "[STEP 2] Removing ALL Node.js traces..." -ForegroundColor Cyan
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Remove-Item "nixpacks.toml" -Force -ErrorAction SilentlyContinue
Remove-Item "railway.toml" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] All Node.js traces removed" -ForegroundColor Green

# Step 3: Create app.py as main entry (Railway prefers this)
Write-Host ""
Write-Host "[STEP 3] Creating app.py..." -ForegroundColor Cyan
$appPy = 'import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import json
from datetime import datetime

app = Flask(__name__)
CORS(app)

PORT = int(os.environ.get("PORT", 8080))

@app.route("/")
def home():
    return jsonify({"status": "ok", "service": "nasrium"})

@app.route("/api/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)'
$appPy | Set-Content "app.py" -Encoding UTF8
Write-Host "[OK] app.py created" -ForegroundColor Green

# Step 4: Update Procfile
Write-Host ""
Write-Host "[STEP 4] Updating Procfile..." -ForegroundColor Cyan
"web: python app.py" | Set-Content "Procfile" -Encoding UTF8
Write-Host "[OK] Procfile updated" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 5] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_041: Remove Node.js, force Python" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 6: Manual Railway steps
Write-Host ""
Write-Host "[STEP 6] MANUAL RAILWAY STEPS:" -ForegroundColor Red
Write-Host ""
Write-Host "1. Variables tab:" -ForegroundColor Yellow
Write-Host "   - DELETE: NODE_ENV" -ForegroundColor Red
Write-Host "   - DELETE: START_COMMAND" -ForegroundColor Red
Write-Host "   - KEEP: PORT, BOT_TOKEN, NIXPACKS_PYTHON_VERSION" -ForegroundColor Green
Write-Host ""
Write-Host "2. Settings tab:" -ForegroundColor Yellow
Write-Host "   - Builder: Auto-Detect" -ForegroundColor White
Write-Host ""
Write-Host "3. Deploy" -ForegroundColor Yellow

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_041_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_041
# File ID   : CMD_041_001
# Module    : Infrastructure | Railway Node Fix
# Component : Remove Node.js detection completely
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_041 - RAILWAY NODE FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_041" -ForegroundColor Yellow
Write-Host "File ID   : CMD_041_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Node Fix" -ForegroundColor Yellow
Write-Host "Component : Remove Node.js detection" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Create .nixpacks to force Python
Write-Host "[STEP 1] Creating .nixpacks..." -ForegroundColor Cyan
$nixpacks = @"
providers = ["python"]
"@
$nixpacks | Set-Content ".nixpacks" -Encoding UTF8
Write-Host "[OK] .nixpacks created" -ForegroundColor Green

# Step 2: Remove ALL Node.js traces
Write-Host ""
Write-Host "[STEP 2] Removing ALL Node.js traces..." -ForegroundColor Cyan
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Remove-Item "nixpacks.toml" -Force -ErrorAction SilentlyContinue
Remove-Item "railway.toml" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] All Node.js traces removed" -ForegroundColor Green

# Step 3: Create app.py as main entry (Railway prefers this)
Write-Host ""
Write-Host "[STEP 3] Creating app.py..." -ForegroundColor Cyan
$appPy = 'import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import json
from datetime import datetime

app = Flask(__name__)
CORS(app)

PORT = int(os.environ.get("PORT", 8080))

@app.route("/")
def home():
    return jsonify({"status": "ok", "service": "nasrium"})

@app.route("/api/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)'
$appPy | Set-Content "app.py" -Encoding UTF8
Write-Host "[OK] app.py created" -ForegroundColor Green

# Step 4: Update Procfile
Write-Host ""
Write-Host "[STEP 4] Updating Procfile..." -ForegroundColor Cyan
"web: python app.py" | Set-Content "Procfile" -Encoding UTF8
Write-Host "[OK] Procfile updated" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 5] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_041: Remove Node.js, force Python" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 6: Manual Railway steps
Write-Host ""
Write-Host "[STEP 6] MANUAL RAILWAY STEPS:" -ForegroundColor Red
Write-Host ""
Write-Host "1. Variables tab:" -ForegroundColor Yellow
Write-Host "   - DELETE: NODE_ENV" -ForegroundColor Red
Write-Host "   - DELETE: START_COMMAND" -ForegroundColor Red
Write-Host "   - KEEP: PORT, BOT_TOKEN, NIXPACKS_PYTHON_VERSION" -ForegroundColor Green
Write-Host ""
Write-Host "2. Settings tab:" -ForegroundColor Yellow
Write-Host "   - Builder: Auto-Detect" -ForegroundColor White
Write-Host ""
Write-Host "3. Deploy" -ForegroundColor Yellow

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_041_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
