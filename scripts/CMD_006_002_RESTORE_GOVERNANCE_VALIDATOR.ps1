# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_006
# File ID   : CMD_006_002
# Module    : Governance
# Component : Restore Governance Validator Module
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "RESTORING GOVERNANCE VALIDATOR MODULE" -ForegroundColor Cyan
Write-Host "Command : CMD_006_002" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$SystemPath = Join-Path $Root "Core\Modules\System"

if (!(Test-Path $SystemPath)) {
    New-Item -ItemType Directory -Path $SystemPath -Force | Out-Null
}

$validatorCode = @"
# ================================================================================
# NASRIUM GOVERNANCE VALIDATOR
# Version : 1.0.0
# ================================================================================

`$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Test-NSMGovernanceIntegrity {

    `$GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"
    `$ManifestPath = Join-Path `$GovPath "08_PROJECT_MANIFEST.json"

    if (!(Test-Path `$ManifestPath)) {
        throw "Governance Manifest missing."
    }

    `$manifest = Get-Content `$ManifestPath -Raw | ConvertFrom-Json

    foreach (`$file in `$manifest.files) {

        `$filePath = Join-Path `$GovPath `$file.name

        if (!(Test-Path `$filePath)) {
            throw "Required file missing: `$(`$file.name)"
        }

        `$bytes = [System.IO.File]::ReadAllBytes(`$filePath)
        `$hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash(`$bytes)
        `$hashStr = ([System.BitConverter]::ToString(`$hash)).Replace("-", "").ToLower()

        if (`$hashStr -ne `$file.sha256) {
            throw "Integrity violation detected in: `$(`$file.name)"
        }
    }

    return `$true
}
"@

$validatorPath = Join-Path $SystemPath "NSM_GovernanceValidator.ps1"
$validatorCode | Set-Content $validatorPath -Encoding UTF8

Write-Host ""
Write-Host "✅ GOVERNANCE VALIDATOR RESTORED" -ForegroundColor Green
