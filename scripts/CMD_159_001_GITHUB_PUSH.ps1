# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_159
# File ID   : CMD_159_001
# Module    : Infrastructure | GitHub Push
# Component : Push NASRIUM to GitHub Repository
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_159 - GITHUB PUSH" -ForegroundColor Cyan
Write-Host "Command   : CMD_159" -ForegroundColor Yellow
Write-Host "File ID   : CMD_159_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | GitHub Push" -ForegroundColor Yellow
Write-Host "Component : Push NASRIUM to GitHub Repository" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Rename branch to main
Write-Host "[STEP 1] Renaming branch to main..." -ForegroundColor Cyan
git branch -M main
Write-Host "[OK] Branch renamed to main" -ForegroundColor Green

# Step 2: Add remote
Write-Host ""
Write-Host "[STEP 2] Adding GitHub remote..." -ForegroundColor Cyan
Write-Host "[INFO] Please enter your GitHub username:" -ForegroundColor Yellow
$GitHubUser = Read-Host "GitHub Username"
$RemoteUrl = "https://github.com/$GitHubUser/nasrium-bot.git"
git remote add origin $RemoteUrl
Write-Host "[OK] Remote added: $RemoteUrl" -ForegroundColor Green

# Step 3: Push
Write-Host ""
Write-Host "[STEP 3] Pushing to GitHub..." -ForegroundColor Cyan
git push -u origin main
Write-Host "[OK] Push complete" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_159_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
