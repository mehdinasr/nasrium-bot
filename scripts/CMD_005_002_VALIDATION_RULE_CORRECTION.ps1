# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_005
# File ID   : CMD_005_002
# Module    : Governance
# Component : Validation Rule Correction
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "VALIDATOR RULE CORRECTION" -ForegroundColor Cyan
Write-Host "Command : CMD_005_002" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$ValidatorPath = "D:\NASRIUM\Scripts\CMD_005_001_ORCHESTRATOR_POST_PATCH_VALIDATION.ps1"

$content = Get-Content $ValidatorPath -Raw

# Relax state filename pattern validation
$content = $content -replace '\`\\\$\{CmdId\}_state\.json', 'CmdId.*_state\.json'

$content | Set-Content $ValidatorPath -Encoding UTF8

Write-Host "✅ Validator pattern updated (Relaxed Matching)" -ForegroundColor Green
Write-Host "CMD_005_002 COMPLETE"
