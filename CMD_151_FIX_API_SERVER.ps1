# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_151
# File ID   : CMD_151_001
# Module    : Infrastructure | API Server Fix
# Component : HttpListener Binding Fix for Tunnel
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_151 - API SERVER TUNNEL FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_151" -ForegroundColor Yellow
Write-Host "File ID   : CMD_151_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | API Server Fix" -ForegroundColor Yellow
Write-Host "Component : HttpListener Binding Fix for Tunnel" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RootPath = "D:\NASRIUM"
$ApiFile = Join-Path $RootPath "Core\Modules\Game\NSM_ApiServer.psm1"
$BackupFile = Join-Path $RootPath "Core\Modules\Game\NSM_ApiServer.psm1.bak.CMD_151"

# Backup original
if (Test-Path $ApiFile) {
    Copy-Item $ApiFile $BackupFile -Force
    Write-Host "[OK] Backup created: NSM_ApiServer.psm1.bak.CMD_151" -ForegroundColor Green
}

# Read current content
$Content = Get-Content $ApiFile -Raw -Encoding UTF8

# FIX 1: Change localhost to + for external access
$Content = $Content -replace 'http://localhost:\$Port/', 'http://+:$Port/'

# Write fixed file
$Content | Set-Content $ApiFile -Encoding UTF8

Write-Host "[OK] NSM_ApiServer.psm1 fixed for tunnel access" -ForegroundColor Green
Write-Host ""
Write-Host "CHANGES MADE:" -ForegroundColor Yellow
Write-Host "  1. localhost -> + (0.0.0.0)" -ForegroundColor White
Write-Host "  2. Server now accepts external connections" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT:" -ForegroundColor Red
Write-Host "  Run this ONCE as Administrator:" -ForegroundColor Red
Write-Host "  netsh http add urlacl url=http://+:8080/ user=Everyone" -ForegroundColor Yellow
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_151 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "OK_CMD_151_COMPLETE" -ForegroundColor Green
