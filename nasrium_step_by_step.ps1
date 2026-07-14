# ============================================
# NASRIUM BOT - STEP-BY-STEP DIAGNOSTIC
# Version: 1.0
# ============================================

function Show-Header {
    param($Step, $Total, $Title)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  STEP $Step / $Total : $Title" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}

function Show-OK {
    Write-Host "[OK] PASSED" -ForegroundColor Green
}

function Show-FAIL {
    param($Msg)
    Write-Host "[FAIL] $Msg" -ForegroundColor Red
}

function Wait-ForEnter {
    Write-Host ""
    Write-Host "Press ENTER to continue..." -ForegroundColor Yellow
    Read-Host | Out-Null
}

# ============================================
# STEP 1: Check Python
# ============================================
Show-Header -Step 1 -Total 5 -Title "Check Python Installation"
$py = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Show-FAIL -Msg "Python not installed! Download from python.org"
    exit 1
}
Write-Host "Python: $py" -ForegroundColor White
Show-OK
Wait-ForEnter

# ============================================
# STEP 2: Check Required Packages
# ============================================
Show-Header -Step 2 -Total 5 -Title "Check Required Packages"
$packages = @("python_telegram_bot", "aiohttp")
foreach ($pkg in $packages) {
    $check = python -c "import $pkg" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[INSTALL] Installing $pkg..." -ForegroundColor Yellow
        pip install $pkg.Replace("_", "-")
    } else {
        Write-Host "[OK] $pkg installed" -ForegroundColor Green
    }
}
Show-OK
Wait-ForEnter

# ============================================
# STEP 3: Check Project Files
# ============================================
Show-Header -Step 3 -Total 5 -Title "Check Project Files"
$requiredFiles = @("main.py", "languages.json")
$allFound = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "[OK] $file ($size bytes)" -ForegroundColor Green
    } else {
        Show-FAIL -Msg "$file NOT FOUND!"
        $allFound = $false
    }
}
if (-not $allFound) { exit 1 }
Show-OK
Wait-ForEnter

# ============================================
# STEP 4: Syntax Check
# ============================================
Show-Header -Step 4 -Total 5 -Title "Syntax Check main.py"
$check = python -m py_compile main.py 2>&1
if ($LASTEXITCODE -ne 0) {
    Show-FAIL -Msg "Syntax error in main.py!"
    Write-Host $check -ForegroundColor Red
    exit 1
}
Write-Host "[OK] No syntax errors" -ForegroundColor Green
Show-OK
Wait-ForEnter

# ============================================
# STEP 5: Launch Bot
# ============================================
Show-Header -Step 5 -Total 5 -Title "Launch Bot"
Write-Host "Starting bot... Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host "If error appears, COPY the red text and send here!" -ForegroundColor Magenta
Write-Host ""
python main.py 2>&1 | Tee-Object -FilePath "bot_error_log.txt"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LOG SAVED: bot_error_log.txt" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
