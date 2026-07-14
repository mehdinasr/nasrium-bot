# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_172
# File ID   : CMD_172_001
# Module    : Infrastructure | Railway Logs
# Component : Check Railway Build Logs
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_172 - RAILWAY LOGS" -ForegroundColor Cyan
Write-Host "Command   : CMD_172" -ForegroundColor Yellow
Write-Host "File ID   : CMD_172_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Logs" -ForegroundColor Yellow
Write-Host "Component : Check Railway Build Logs" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "MANUAL STEPS (Railway Dashboard):" -ForegroundColor Yellow
Write-Host ""
Write-Host "Step 1: Click 'View' button" -ForegroundColor Cyan
Write-Host "  Next to 'CMD_171: Update description for Railway deploy'" -ForegroundColor White
Write-Host ""
Write-Host "Step 2: Click 'Build Logs' tab" -ForegroundColor Cyan
Write-Host "  Find the red error text" -ForegroundColor White
Write-Host ""
Write-Host "Step 3: Copy the error message" -ForegroundColor Cyan
Write-Host "  Send it here so I can fix it!" -ForegroundColor White
Write-Host ""
Write-Host "COMMON ERRORS:" -ForegroundColor Red
Write-Host "  - 'Cannot find package.json' → File path issue" -ForegroundColor White
Write-Host "  - 'npm install failed' → Network or dependency issue" -ForegroundColor White
Write-Host "  - 'port already in use' → EXPOSE issue" -ForegroundColor White
Write-Host "  - 'module not found' → Missing dependency" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_172_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
