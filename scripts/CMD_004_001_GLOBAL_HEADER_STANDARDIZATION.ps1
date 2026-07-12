# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_004
# File ID   : CMD_004_001
# Module    : Refactor
# Component : Global Script Header Standardization
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM HEADER STANDARDIZATION" -ForegroundColor Cyan
Write-Host "Command : CMD_004_001" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$ScriptsPath = "D:\NASRIUM\Scripts"
$files = Get-ChildItem $ScriptsPath -Filter "*.ps1"

foreach ($file in $files) {

    $content = Get-Content $file.FullName -Raw

    $modified = $false

    if ($content -notmatch "Set-StrictMode") {
        $content = "Set-StrictMode -Version Latest`r`n" + $content
        $modified = $true
    }

    if ($content -notmatch "ErrorActionPreference") {
        $content = "`$ErrorActionPreference = `"Stop`"`r`n" + $content
        $modified = $true
    }

    if ($modified) {
        $content | Set-Content $file.FullName -Encoding UTF8
        Write-Host "Updated Header: $($file.Name)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "CMD_004_001 REFACTOR COMPLETE" -ForegroundColor Green
