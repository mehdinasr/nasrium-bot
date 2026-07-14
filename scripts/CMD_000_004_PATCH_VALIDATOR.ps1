# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000
# File ID   : CMD_000_004
# Module    : AI Governance Package
# Component : Validator Self-Hash Paradox Patch
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PATCHING GOVERNANCE VALIDATOR" -ForegroundColor Cyan
Write-Host "Command   : CMD_000_004" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$ValidatorPath = Join-Path $Root "Core\Modules\System\NSM_GovernanceValidator.ps1"

$newValidatorCode = @(
    'function Test-NSMGovernanceIntegrity {',
    '    $GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"',
    '    $ManifestPath = Join-Path $GovPath "08_PROJECT_MANIFEST.json"',
    '    if (!(Test-Path $ManifestPath)) { throw "Governance Manifest missing." }',
    '    $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json',
    '',
    '    foreach ($file in $manifest.files) {',
    '        $filePath = Join-Path $GovPath $file.name',
    '        if (!(Test-Path $filePath)) { throw "Required file missing: $($file.name)" }',
    '        ',
    '        # Self-Hash Paradox Exception',
    '        if ($file.name -eq "08_PROJECT_MANIFEST.json") {',
    '            continue',
    '        }',
    '',
    '        $bytes = [System.IO.File]::ReadAllBytes($filePath)',
    '        $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)',
    '        $hashStr = ([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()',
    '        if ($hashStr -ne $file.sha256) { throw "Integrity violation in: $($file.name)" }',
    '    }',
    '    return $true',
    '}'
) -join "`r`n"

try {
    [System.IO.File]::WriteAllText($ValidatorPath, $newValidatorCode, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] Validator Patched Successfully." -ForegroundColor Green
} catch {
    throw "Failed to patch Validator: $_"
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   CMD_000_004 VALIDATOR PATCH COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
