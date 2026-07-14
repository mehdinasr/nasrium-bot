# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_201_2
# File ID   : CMD_201_2_005
# Module    : Frontend | Mini App Upgrade (Part 2)
# Component : Diagnostic - Real Backend Discovery
# Version   : 1.0.2
# Status    : Diagnostic
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_201_2 - REAL BACKEND DIAG" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

$filesToScan = @("main.py", "mini_api.py")
$keywords = "flask|fastapi|webapp_url|app.run|def run_|route|mini_app"
$resultText = ""

foreach ($file in $filesToScan) {
    Write-Host "[SCANNING] $file..." -ForegroundColor Cyan
    if (Test-Path $file) {
        $lines = Get-Content $file
        $foundLines = [System.Collections.ArrayList]::new()
        
        foreach ($line in $lines) {
            if ($line -match $keywords) {
                $foundLines.Add($line) | Out-Null
            }
        }
        
        if ($foundLines.Count -gt 0) {
            $resultText += "=== FOUND IN $file ===`r`n"
            $resultText += ($foundLines -join "`r`n")
            $resultText += "`r`n`r`n"
        } else {
            $resultText += "=== NO MATCH IN $file ===`r`n`r`n"
        }
    } else {
        $resultText += "=== $file NOT FOUND ===`r`n`r`n"
    }
}

Write-Host "[RESULT]" -ForegroundColor Yellow
Write-Host $resultText

Write-Host "[CLIPBOARD] Copying results..." -ForegroundColor Green
Set-Clipboard -Value $resultText
Write-Host "[OK] Results copied! Just press Ctrl+V here." -ForegroundColor Green
