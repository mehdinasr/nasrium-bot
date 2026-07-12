# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000
# File ID   : CMD_000_003
# Module    : AI Governance Package
# Component : Governance Manifest Re-Seal
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM GOVERNANCE MANIFEST RE-SEAL" -ForegroundColor Cyan
Write-Host "Command   : CMD_000_003" -ForegroundColor Yellow
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

try {
    foreach ($name in $required) {
        $p = Join-Path $GovPath $name
        if (!(Test-Path $p)) { throw "Missing required governance file: $name" }

        $bytes = [System.IO.File]::ReadAllBytes($p)
        $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        $hashStr = ([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()

        $filesMeta += [ordered]@{
            name = $name
            version = "3.0.0"
            sha256 = $hashStr
            bytes = (Get-Item $p).Length
            required = $true
        }
    }

    $manifest = [ordered]@{
        file_id = "08_PROJECT_MANIFEST"
        version = "3.0.0"
        package_name = "NASRIUM AI Governance Package"
        package_version = "3.0.0"
        generated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        package_path = $GovPath
        required_files = $required + @("08_PROJECT_MANIFEST.json")
        files = $filesMeta
    }

    # نوشتن مانیفست بدون هش خودش
    $manifest | ConvertTo-Json -Depth 5 | Set-Content $ManifestPath -Encoding UTF8

    # محاسبه هش مانیفست روی خودش
    $selfRaw = [System.IO.File]::ReadAllBytes($ManifestPath)
    $selfHash = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($selfRaw)) -replace "-", "").ToLower()

    $manifest.files += [ordered]@{
        name = "08_PROJECT_MANIFEST.json"
        version = "3.0.0"
        sha256 = $selfHash
        bytes = $selfRaw.Length
        required = $true
    }

    # بازنویسی نهایی مانیفست
    $manifest | ConvertTo-Json -Depth 5 | Set-Content $ManifestPath -Encoding UTF8

    Write-Host "  [OK] Governance Manifest Re-Sealed Successfully." -ForegroundColor Green
} catch {
    throw "Failed to Re-Seal Manifest: $_"
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "   CMD_000_003 MANIFEST RE-SEAL COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
