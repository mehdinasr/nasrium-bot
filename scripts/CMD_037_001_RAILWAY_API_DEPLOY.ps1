# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_037
# File ID   : CMD_037_001
# Module    : Infrastructure | Railway API Deploy
# Component : Deploy Flask API to Railway
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_037 - RAILWAY API DEPLOY" -ForegroundColor Cyan
Write-Host "Command   : CMD_037" -ForegroundColor Yellow
Write-Host "File ID   : CMD_037_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway API Deploy" -ForegroundColor Yellow
Write-Host "Component : Deploy Flask API to Railway" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Update Dockerfile for API
Write-Host "[STEP 1] Updating Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM python:3.11-slim
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY . .

# Expose port
EXPOSE 8080

# Run API
CMD ["python", "mini_api.py"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile updated" -ForegroundColor Green

# Step 2: Update Procfile for Railway
Write-Host ""
Write-Host "[STEP 2] Creating Procfile..." -ForegroundColor Cyan
"web: python mini_api.py" | Set-Content "Procfile" -Encoding UTF8
Write-Host "[OK] Procfile created" -ForegroundColor Green

# Step 3: Commit
Write-Host ""
Write-Host "[STEP 3] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_037: Update Dockerfile and Procfile for API deploy" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 4: Manual Railway Deploy
Write-Host ""
Write-Host "[STEP 4] Railway Deploy Instructions..." -ForegroundColor Cyan
Write-Host ""
Write-Host "MANUAL STEPS:" -ForegroundColor Yellow
Write-Host "  1. Go to https://railway.app/dashboard" -ForegroundColor White
Write-Host "  2. Select nasrium-bot project" -ForegroundColor White
Write-Host "  3. Click 'Deploy' button" -ForegroundColor White
Write-Host "  4. Wait for build to complete" -ForegroundColor White
Write-Host "  5. Copy the new domain URL" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: Update Mini App API URL to new Railway domain!" -ForegroundColor Red

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_037_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "FILES UPDATED:" -ForegroundColor Yellow
Write-Host "  Dockerfile (Python API)" -ForegroundColor White
Write-Host "  Procfile (Railway config)" -ForegroundColor White
Write-Host ""
Write-Host "NEXT: Update Mini App with Railway URL" -ForegroundColor Magenta
