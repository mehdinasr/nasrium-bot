# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_201_2
# File ID   : CMD_201_2_003
# Module    : Frontend | Mini App Upgrade (Part 2)
# Component : Diagnostic - Extract main.py Flask Config
# Version   : 1.0.0
# Status    : Diagnostic
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_201_2 - MAIN.PY DIAGNOSTIC" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

Write-Host "[STEP 1] Extracting Flask and WebApp configuration from main.py..." -ForegroundColor Cyan

$filePath = "main.py"
if (-not (Test-Path $filePath)) {
    Write-Host "[FATAL] main.py not found!" -ForegroundColor Red
    exit 1
}

$lines = Get-Content $filePath
$reportLines = [System.Collections.ArrayList]::new()

foreach ($line in $lines) {
    # پیدا کردن خطوطی که به Flask API و دکمه وباپ مربوط هستند
    if ($line -match "flask" -or $line -match "webapp_url" -or $line -match "run_flask" -or $line -match "app_flask" -or $line -match "def run_") {
        $reportLines.Add($line) | Out-Null
    }
}

Write-Host "[RESULT] Found the following relevant lines:" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
foreach ($rl in $reportLines) {
    Write-Host $rl
}
Write-Host "-------------------------------------------"

$reportPath = "Builder\Reports\CMD_201_2_MAIN_PY_DIAGNOSTIC.txt"
$reportLines | Set-Content $reportPath -Encoding UTF8
Write-Host "[OK] Diagnostic report saved to $reportPath" -ForegroundColor Green
