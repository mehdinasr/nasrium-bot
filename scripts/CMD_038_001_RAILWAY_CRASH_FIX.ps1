# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_038
# File ID   : CMD_038_001
# Module    : Infrastructure | Railway Crash Fix
# Component : Fix Dockerfile and builder for Python API
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_038 - RAILWAY CRASH FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_038" -ForegroundColor Yellow
Write-Host "File ID   : CMD_038_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Crash Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Dockerfile for Python API" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Remove conflicting Node.js files
Write-Host "[STEP 1] Removing conflicting Node.js files..." -ForegroundColor Cyan
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Node.js files removed" -ForegroundColor Green

# Step 2: Create proper Python Dockerfile
Write-Host ""
Write-Host "[STEP 2] Creating proper Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM python:3.11-slim
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source
COPY . .

# Port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8080/api/health')\" || exit 1

# Run
CMD [\"python\", \"mini_api.py\"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile created" -ForegroundColor Green

# Step 3: Update Procfile
Write-Host ""
Write-Host "[STEP 3] Updating Procfile..." -ForegroundColor Cyan
"web: python mini_api.py" | Set-Content "Procfile" -Encoding UTF8
Write-Host "[OK] Procfile updated" -ForegroundColor Green

# Step 4: Create railway.toml for config
Write-Host ""
Write-Host "[STEP 4] Creating railway.toml..." -ForegroundColor Cyan
$railwayToml = @"
[build]
builder = "DOCKERFILE"

[deploy]
startCommand = "python mini_api.py"
healthcheckPath = "/api/health"
healthcheckTimeout = 30
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 3
"@
$railwayToml | Set-Content "railway.toml" -Encoding UTF8
Write-Host "[OK] railway.toml created" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 5] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_038: Fix Railway crash - Python API config" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 6: Instructions
Write-Host ""
Write-Host "[STEP 6] Manual Railway Steps..." -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT - DO THIS IN RAILWAY:" -ForegroundColor Red
Write-Host "  1. Go to Railway Dashboard" -ForegroundColor White
Write-Host "  2. Click Settings tab" -ForegroundColor White
Write-Host "  3. Change Builder to: DOCKERFILE" -ForegroundColor Yellow
Write-Host "  4. Click Deploy" -ForegroundColor White
Write-Host "  5. Wait for green checkmark" -ForegroundColor White
Write-Host ""
Write-Host "If still crashing:" -ForegroundColor Red
Write-Host "  - Click Variables tab" -ForegroundColor White
Write-Host "  - Add: PORT = 8080" -ForegroundColor Yellow
Write-Host "  - Click Deploy again" -ForegroundColor White

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_038_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
