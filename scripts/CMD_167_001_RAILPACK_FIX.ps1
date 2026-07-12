# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_167
# File ID   : CMD_167_001
# Module    : Infrastructure | Railpack Fix
# Component : Fix structure for Railway default builder
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_167 - RAILPACK FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_167" -ForegroundColor Yellow
Write-Host "File ID   : CMD_167_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railpack Fix" -ForegroundColor Yellow
Write-Host "Component : Fix structure for Railway default builder" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Move files from bot/ to root
Write-Host "[STEP 1] Moving files from bot/ to root..." -ForegroundColor Cyan
Move-Item "bot\package.json" "package.json" -Force
Move-Item "bot\package-lock.json" "package-lock.json" -Force
Move-Item "bot\src" "src" -Force
Move-Item "bot\.env" ".env" -Force
Write-Host "[OK] Files moved" -ForegroundColor Green

# Step 2: Delete Dockerfile and railway.toml (not needed for Railpack)
Write-Host ""
Write-Host "[STEP 2] Removing Dockerfile files..." -ForegroundColor Cyan
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Remove-Item "railway.toml" -Force -ErrorAction SilentlyContinue
Remove-Item "bot" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Dockerfile files removed" -ForegroundColor Green

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_167: Fix structure for Railway Railpack"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_167_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway and Deploy!" -ForegroundColor Yellow
Write-Host "Railpack will auto-detect Node.js!" -ForegroundColor Green
