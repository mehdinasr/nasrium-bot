# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_169
# File ID   : CMD_169_001
# Module    : Infrastructure | Railway Final Fix
# Component : Remove railway.json and fix for Railpack
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_169 - RAILWAY FINAL FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_169" -ForegroundColor Yellow
Write-Host "File ID   : CMD_169_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Final Fix" -ForegroundColor Yellow
Write-Host "Component : Remove railway.json and fix for Railpack" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Remove railway.json
Write-Host "[STEP 1] Removing railway.json..." -ForegroundColor Cyan
if (Test-Path "railway.json") {
    Remove-Item "railway.json" -Force
    Write-Host "[OK] railway.json removed" -ForegroundColor Green
} else {
    Write-Host "[OK] railway.json not found" -ForegroundColor Green
}

# Step 2: Remove .dockerignore
Write-Host ""
Write-Host "[STEP 2] Removing .dockerignore..." -ForegroundColor Cyan
if (Test-Path ".dockerignore") {
    Remove-Item ".dockerignore" -Force
    Write-Host "[OK] .dockerignore removed" -ForegroundColor Green
}

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_169: Remove railway.json for Railpack"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_169_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway and Deploy!" -ForegroundColor Yellow
Write-Host "Railpack will auto-detect Node.js!" -ForegroundColor Green
