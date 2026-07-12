# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_055
# File ID   : CMD_055_001
# Module    : Infrastructure | Find BOT_TOKEN
# Component : Search and display BOT_TOKEN from all sources
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_055 - FIND BOT_TOKEN" -ForegroundColor Cyan
Write-Host "Command   : CMD_055" -ForegroundColor Yellow
Write-Host "File ID   : CMD_055_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Find BOT_TOKEN" -ForegroundColor Yellow
Write-Host "Component : Search all sources for token" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Search for .env files
Write-Host "[STEP 1] Searching for .env files..." -ForegroundColor Cyan
$envFiles = Get-ChildItem -Filter "*.env*" -Recurse -ErrorAction SilentlyContinue
if ($envFiles) {
    Write-Host "[OK] Found .env files:" -ForegroundColor Green
    $envFiles | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor White }
} else {
    Write-Host "[INFO] No .env files found" -ForegroundColor Yellow
}

# Step 2: Search for BOT_TOKEN in all files
Write-Host ""
Write-Host "[STEP 2] Searching for BOT_TOKEN in files..." -ForegroundColor Cyan
$tokenFiles = Select-String -Path "*.py", "*.txt", "*.json", "*.env*" -Pattern "BOT_TOKEN" -ErrorAction SilentlyContinue
if ($tokenFiles) {
    Write-Host "[OK] Found BOT_TOKEN references:" -ForegroundColor Green
    $tokenFiles | ForEach-Object { 
        Write-Host "  File: $($_.Path)" -ForegroundColor Cyan
        Write-Host "  Line: $($_.LineNumber) - $($_.Line)" -ForegroundColor White
    }
} else {
    Write-Host "[INFO] No BOT_TOKEN found in files" -ForegroundColor Yellow
}

# Step 3: Check common locations
Write-Host ""
Write-Host "[STEP 3] Checking common token locations..." -ForegroundColor Cyan
$locations = @(
    "D:\NASRIUM\.env",
    "D:\NASRIUM\bot.env",
    "D:\NASRIUM\token.txt",
    "D:\NASRIUM\config.json",
    "D:\NASRIUM\data\config.json"
)
foreach ($loc in $locations) {
    if (Test-Path $loc) {
        Write-Host "[FOUND] $loc" -ForegroundColor Green
        $content = Get-Content $loc -Raw
        if ($content -match "BOT_TOKEN") {
            Write-Host "  Contains BOT_TOKEN!" -ForegroundColor Yellow
        }
    }
}

# Step 4: Show manual token entry
Write-Host ""
Write-Host "[STEP 4] Manual Token Entry:" -ForegroundColor Green
Write-Host "  If you have the token, you can:" -ForegroundColor White
Write-Host "  1. Create file: D:\NASRIUM\.env" -ForegroundColor Cyan
Write-Host "  2. Add: BOT_TOKEN=your_token_here" -ForegroundColor Cyan
Write-Host "  3. Or add directly to Railway Variables" -ForegroundColor Cyan

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_055_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Get token from @BotFather" -ForegroundColor Magenta
