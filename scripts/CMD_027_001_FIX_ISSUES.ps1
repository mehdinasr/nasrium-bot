# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_027
# File ID   : CMD_027_001
# Module    : Infrastructure | Fix Issues
# Component : Fix Git remote, Railway sync, and imports
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_027 - FIX ISSUES" -ForegroundColor Cyan
Write-Host "Command   : CMD_027" -ForegroundColor Yellow
Write-Host "File ID   : CMD_027_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Fix Issues" -ForegroundColor Yellow
Write-Host "Component : Git remote, Railway sync, imports" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\NASRIUM"

# Step 1: Check and fix Git remote
Write-Host "[STEP 1] Checking Git remote..." -ForegroundColor Cyan
$remotes = git remote -v 2>$null
if ($LASTEXITCODE -ne 0 -or -not $remotes) {
    Write-Host "[FIX] No remote found. Adding origin..." -ForegroundColor Yellow
    git remote add origin https://github.com/mehdinasr/nasrium-bot.git
    Write-Host "[OK] Remote added: https://github.com/mehdinasr/nasrium-bot.git" -ForegroundColor Green
} else {
    Write-Host "[OK] Remote exists:" -ForegroundColor Green
    Write-Host "  $remotes" -ForegroundColor White
}

# Step 2: Check branch name
Write-Host ""
Write-Host "[STEP 2] Checking branch..." -ForegroundColor Cyan
$branch = git branch --show-current 2>$null
Write-Host "Current branch: $branch" -ForegroundColor White
if ($branch -eq "master") {
    Write-Host "[INFO] Branch is 'master', will push to master" -ForegroundColor Cyan
}

# Step 3: Push all changes
Write-Host ""
Write-Host "[STEP 3] Pushing to GitHub..." -ForegroundColor Cyan
git add .
git commit -m "CMD_027: Fix infrastructure - sync all modules" --allow-empty
git push origin $branch
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Pushed to GitHub successfully!" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Push failed. Check credentials or remote URL." -ForegroundColor Red
    Write-Host "Try: git push https://USERNAME:TOKEN@github.com/mehdinasr/nasrium-bot.git $branch" -ForegroundColor Yellow
}

# Step 4: Verify files exist
Write-Host ""
Write-Host "[STEP 4] Verifying project files..." -ForegroundColor Cyan
$requiredFiles = @(
    "Config\balance.json",
    "Config\balance_loader.py",
    "Modules\Troops\troop_types.json",
    "Modules\Troops\troop_manager.py",
    "Modules\Heroes\hero_types.json",
    "Modules\Heroes\hero_manager.py"
)

$allOk = $true
foreach ($file in $requiredFiles) {
    $path = Join-Path "D:\NASRIUM" $file
    if (Test-Path $path) {
        Write-Host "  [OK] $file" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $file" -ForegroundColor Red
        $allOk = $false
    }
}

# Step 5: Update main.py with imports
Write-Host ""
Write-Host "[STEP 5] Updating main.py imports..." -ForegroundColor Cyan
$mainPath = "D:\NASRIUM\main.py"
if (Test-Path $mainPath) {
    $mainContent = Get-Content $mainPath -Raw
    
    $importsToAdd = @"
# NASRIUM Modules
import sys
sys.path.insert(0, 'D:/NASRIUM')

from Config.balance_loader import balance
from Modules.Troops.troop_manager import troop_manager, Troop
from Modules.Heroes.hero_manager import hero_manager, Hero
"@
    
    if ($mainContent -notmatch "from Config.balance_loader import balance") {
        $mainContent = $importsToAdd + "`n`n" + $mainContent
        $mainContent | Set-Content $mainPath -Encoding UTF8
        Write-Host "[OK] main.py imports updated" -ForegroundColor Green
    } else {
        Write-Host "[OK] Imports already exist" -ForegroundColor Green
    }
} else {
    Write-Host "[WARNING] main.py not found at $mainPath" -ForegroundColor Yellow
}

# Step 6: Create requirements.txt if missing
Write-Host ""
Write-Host "[STEP 6] Checking requirements.txt..." -ForegroundColor Cyan
$reqPath = "D:\NASRIUM\requirements.txt"
if (-not (Test-Path $reqPath)) {
    @"
python-telegram-bot>=20.0
flask>=2.0
requests>=2.28
"@ | Set-Content $reqPath -Encoding UTF8
    Write-Host "[OK] requirements.txt created" -ForegroundColor Green
} else {
    Write-Host "[OK] requirements.txt exists" -ForegroundColor Green
}

# Step 7: Final commit
Write-Host ""
Write-Host "[STEP 7] Final commit..." -ForegroundColor Cyan
git add .
git commit -m "CMD_027: Complete - All modules synced and imports fixed" --allow-empty
git push origin $branch 2>$null

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_027_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
if ($allOk) {
    Write-Host "ALL FILES VERIFIED ✅" -ForegroundColor Green
} else {
    Write-Host "SOME FILES MISSING ❌" -ForegroundColor Red
}
Write-Host ""
Write-Host "NEXT: Railway Deploy or Phase 3" -ForegroundColor Magenta
