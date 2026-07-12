# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_168
# File ID   : CMD_168_001
# Module    : Infrastructure | Railway Debug
# Component : Debug Railway Build Failure
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_168 - RAILWAY DEBUG" -ForegroundColor Cyan
Write-Host "Command   : CMD_168" -ForegroundColor Yellow
Write-Host "File ID   : CMD_168_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Debug" -ForegroundColor Yellow
Write-Host "Component : Debug Railway Build Failure" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Check root files
Write-Host "[STEP 1] Checking root files..." -ForegroundColor Cyan
Get-ChildItem | Select-Object Name, Length
Write-Host ""

# Step 2: Check package.json
Write-Host "[STEP 2] Checking package.json..." -ForegroundColor Cyan
if (Test-Path "package.json") {
    Get-Content "package.json"
    Write-Host "[OK] package.json found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] package.json NOT FOUND!" -ForegroundColor Red
}
Write-Host ""

# Step 3: Check src folder
Write-Host "[STEP 3] Checking src folder..." -ForegroundColor Cyan
if (Test-Path "src") {
    Get-ChildItem "src" -Recurse | Select-Object FullName, Length
    Write-Host "[OK] src folder found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] src folder NOT FOUND!" -ForegroundColor Red
}
Write-Host ""

# Step 4: Check .env
Write-Host "[STEP 4] Checking .env..." -ForegroundColor Cyan
if (Test-Path ".env") {
    Write-Host "[OK] .env found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] .env NOT FOUND!" -ForegroundColor Red
}
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_168_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
