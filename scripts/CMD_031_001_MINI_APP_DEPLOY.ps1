# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_031
# File ID   : CMD_031_001
# Module    : Infrastructure | Mini App Deployment
# Component : Deploy React Mini App to Vercel
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_031 - MINI APP DEPLOY" -ForegroundColor Cyan
Write-Host "Command   : CMD_031" -ForegroundColor Yellow
Write-Host "File ID   : CMD_031_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Mini App Deployment" -ForegroundColor Yellow
Write-Host "Component : Deploy React Mini App to Vercel" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$MiniAppDir = "D:\NASRIUM\mini-app"
Set-Location $MiniAppDir

# Step 1: Check Node.js
Write-Host "[STEP 1] Checking Node.js..." -ForegroundColor Cyan
$nodeVersion = node --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Node.js not found! Install from https://nodejs.org" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Node.js $nodeVersion" -ForegroundColor Green

# Step 2: Install dependencies
Write-Host ""
Write-Host "[STEP 2] Installing dependencies..." -ForegroundColor Cyan
npm install
Write-Host "[OK] Dependencies installed" -ForegroundColor Green

# Step 3: Build production
Write-Host ""
Write-Host "[STEP 3] Building production..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Build successful" -ForegroundColor Green

# Step 4: Check Vercel CLI
Write-Host ""
Write-Host "[STEP 4] Checking Vercel CLI..." -ForegroundColor Cyan
$vercelVersion = npx vercel --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[INFO] Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}
Write-Host "[OK] Vercel CLI ready" -ForegroundColor Green

# Step 5: Deploy to Vercel
Write-Host ""
Write-Host "[STEP 5] Deploying to Vercel..." -ForegroundColor Cyan
Write-Host "MANUAL: Login to Vercel if prompted" -ForegroundColor Yellow
npx vercel --prod --yes
Write-Host "[OK] Deployed to Vercel" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_031_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Get Vercel URL and update manifest" -ForegroundColor Magenta
