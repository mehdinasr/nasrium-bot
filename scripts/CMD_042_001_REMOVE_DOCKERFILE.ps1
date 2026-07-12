# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_042
# File ID   : CMD_042_001
# Module    : Infrastructure | Remove Dockerfile
# Component : Force Railway to use Nixpacks not Docker
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_042 - REMOVE DOCKERFILE" -ForegroundColor Cyan
Write-Host "Command   : CMD_042" -ForegroundColor Yellow
Write-Host "File ID   : CMD_042_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Remove Dockerfile" -ForegroundColor Yellow
Write-Host "Component : Force Nixpacks build" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Remove Dockerfile completely
Write-Host "[STEP 1] Removing Dockerfile..." -ForegroundColor Cyan
Remove-Item "Dockerfile" -Force -ErrorAction SilentlyContinue
Remove-Item ".dockerignore" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Dockerfile removed" -ForegroundColor Green

# Step 2: Verify no Docker files
Write-Host ""
Write-Host "[STEP 2] Verifying no Docker files..." -ForegroundColor Cyan
$dockerFiles = Get-ChildItem -Filter "*docker*" -ErrorAction SilentlyContinue
$dockerFiles += Get-ChildItem -Filter "Dockerfile*" -ErrorAction SilentlyContinue
if ($dockerFiles.Count -eq 0) {
    Write-Host "[OK] No Docker files found" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Found Docker files:" -ForegroundColor Yellow
    $dockerFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Red }
}

# Step 3: Verify Python files exist
Write-Host ""
Write-Host "[STEP 3] Verifying Python files..." -ForegroundColor Cyan
$pythonFiles = @("app.py", "requirements.txt", "Procfile", ".nixpacks")
foreach ($file in $pythonFiles) {
    if (Test-Path $file) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $file" -ForegroundColor Red
    }
}

# Step 4: Commit
Write-Host ""
Write-Host "[STEP 4] Committing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_042: Remove Dockerfile, force Nixpacks" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

# Step 5: Instructions
Write-Host ""
Write-Host "[STEP 5] RAILWAY MANUAL STEPS:" -ForegroundColor Red
Write-Host ""
Write-Host "1. Go to Railway Dashboard" -ForegroundColor Yellow
Write-Host "2. Click 'Deploy' (NO cache this time)" -ForegroundColor Yellow
Write-Host "3. If still Node.js:" -ForegroundColor Red
Write-Host "   - Settings tab" -ForegroundColor White
Write-Host "   - Find 'Reset Cache' or " -ForegroundColor White
Write-Host "   - Variables: Add RAILWAY_NO_CACHE = true" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. MUST DELETE in Variables:" -ForegroundColor Red
Write-Host "   - DOCKERFILE_PATH" -ForegroundColor Red
Write-Host "   - NODE_ENV" -ForegroundColor Red

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_042_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
