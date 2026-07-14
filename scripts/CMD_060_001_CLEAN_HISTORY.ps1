# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_060
# File ID   : CMD_060_001
# Module    : Infrastructure | Clean Git History
# Component : Remove old commits, fresh start
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_060 - CLEAN GIT HISTORY" -ForegroundColor Cyan
Write-Host "Command   : CMD_060" -ForegroundColor Yellow
Write-Host "File ID   : CMD_060_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Clean Git History" -ForegroundColor Yellow
Write-Host "Component : Remove old commits" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Backup current files
Write-Host "[STEP 1] Backing up current files..." -ForegroundColor Cyan
$backupDir = "D:\NASRIUM_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item "main.py" "$backupDir\" -Force
Copy-Item "requirements.txt" "$backupDir\" -Force
Copy-Item "Dockerfile" "$backupDir\" -Force
Copy-Item ".dockerignore" "$backupDir\" -Force
Copy-Item "Config" "$backupDir\" -Recurse -Force
Copy-Item "Modules" "$backupDir\" -Recurse -Force
Write-Host "[OK] Backup created at: $backupDir" -ForegroundColor Green

# Step 2: Remove old .git folder
Write-Host ""
Write-Host "[STEP 2] Removing old .git history..." -ForegroundColor Cyan
Remove-Item ".git" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Old .git removed" -ForegroundColor Green

# Step 3: Initialize fresh git
Write-Host ""
Write-Host "[STEP 3] Initializing fresh git..." -ForegroundColor Cyan
git init
git branch -m master
Write-Host "[OK] Fresh git initialized" -ForegroundColor Green

# Step 4: Add all current files
Write-Host ""
Write-Host "[STEP 4] Adding all files..." -ForegroundColor Cyan
git add .
Write-Host "[OK] Files added" -ForegroundColor Green

# Step 5: Commit with new message
Write-Host ""
Write-Host "[STEP 5] Creating fresh commit..." -ForegroundColor Cyan
git commit -m "NASRIUM v1.0.0 - Python API + Telegram Bot"
Write-Host "[OK] Fresh commit created" -ForegroundColor Green

# Step 6: Add remote and push force
Write-Host ""
Write-Host "[STEP 6] Pushing to GitHub (force)..." -ForegroundColor Cyan
git remote add origin https://github.com/mehdinasr/nasrium-bot.git
git push -f origin master
Write-Host "[OK] Pushed to GitHub with force" -ForegroundColor Green

# Step 7: Verify
Write-Host ""
Write-Host "[STEP 7] Verifying..." -ForegroundColor Cyan
$log = git log --oneline
Write-Host "Git log:" -ForegroundColor White
$log | ForEach-Object { Write-Host "  $_" -ForegroundColor Cyan }

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_060_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "HISTORY CLEANED!" -ForegroundColor Green
Write-Host "CMD_174 and all old commits removed!" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT: Railway will see ONLY fresh commit" -ForegroundColor Magenta
Write-Host "Go to Railway and Deploy!" -ForegroundColor Yellow
