############################################################
# NASRIUM SDPA v2.0
# Command      : CMD_000
# File ID      : CMD_000_002
# Module       : AI Governance Package
# Component    : Reusable Governance Builder
# Version      : 2.0.0
# Author       : NASRIUM Architecture
# Status       : Production
############################################################
$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"
$PackagePath = Join-Path $Root "Core\Knowledge\AI Governance Package"
$ManifestPath = Join-Path $PackagePath "08_PROJECT_MANIFEST.json"
$DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "Rebuilding Checksums & Manifest..." -ForegroundColor Cyan

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
    $p = Join-Path $PackagePath $name
    $bytes = [System.IO.File]::ReadAllBytes($p)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    $hashStr = ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    
    $filesMeta += [ordered]@{
        name = $name
        version = "2.0.0"
        sha256 = $hashStr
        bytes = (Get-Item $p).Length
        required = $true
    }
}

$manifest = [ordered]@{
    file_id = "08_PROJECT_MANIFEST"
    version = "2.0.0"
    package_name = "NASRIUM AI Governance Package"
    package_version = "2.0.0"
    generated_at = $DateTime
    package_path = $PackagePath
    required_files = $required + @("08_PROJECT_MANIFEST.json")
    files = $filesMeta
}

[System.IO.File]::WriteAllText($ManifestPath, ($manifest | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)

# اضافه کردن چکسام خود مانیفست
$selfRaw = [System.IO.File]::ReadAllBytes($ManifestPath)
$selfHash = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($selfRaw)) -replace '-', '').ToLower()

$manifest.files += [ordered]@{
    name = "08_PROJECT_MANIFEST.json"
    version = "2.0.0"
    sha256 = $selfHash
    bytes = $selfRaw.Length
    required = $true
}

[System.IO.File]::WriteAllText($ManifestPath, ($manifest | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)
Write-Host "SUCCESS: AI Governance Package Rebuilt and Integrity Verified." -ForegroundColor Green