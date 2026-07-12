# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_006
# File ID   : CMD_006_003
# Module    : Governance
# Component : Rebuild Governance Manifest
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "REBUILDING GOVERNANCE MANIFEST" -ForegroundColor Cyan
Write-Host "Command : CMD_006_003" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$GovPath = Join-Path $Root "Core\Knowledge\AI Governance Package"
$ManifestPath = Join-Path $GovPath "08_PROJECT_MANIFEST.json"

$required = @(
    "00_README_FIRST.md",
    "01_NASRIUM_CONSTITUTION.md",
    "02_PROJECT_STATE.json",
    "03_ROADMAP.json",
    "04_PROJECT_HISTORY.json",
    "05_DEVELOPMENT_STANDARD.md",
    "06_AI_BOOTSTRAP_PROMPT.md",
    "07_SESSION_TEMPLATE.json"
)

$filesMeta = @()

foreach ($name in $required) {

    $p = Join-Path $GovPath $name

    if (!(Test-Path $p)) {
        throw "Missing required governance file: $name"
    }

    $bytes = [System.IO.File]::ReadAllBytes($p)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    $hashStr = ([System.BitConverter]::ToString($hash)).Replace("-", "").ToLower()

    $filesMeta += @{
        name = $name
        version = "3.0.0"
        sha256 = $hashStr
        bytes = (Get-Item $p).Length
        required = $true
    }
}

$manifest = @{
    file_id = "08_PROJECT_MANIFEST"
    version = "3.0.0"
    package_name = "NASRIUM AI Governance Package"
    package_version = "3.0.0"
    generated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    package_path = $GovPath
    required_files = $required + @("08_PROJECT_MANIFEST.json")
    files = $filesMeta
}

$manifest | ConvertTo-Json -Depth 5 | Set-Content $ManifestPath -Encoding UTF8

Write-Host ""
Write-Host "✅ GOVERNANCE MANIFEST REBUILT & RE-SEALED (v3.0)" -ForegroundColor Green
