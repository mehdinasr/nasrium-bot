# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_130
# File ID   : CMD_130_001
# Module    : Governance
# Component : Phase 4 Seal & Ecosystem Baseline Update
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Seal-PhaseFour {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PHASE 4 SEAL & BASELINE UPDATE" -ForegroundColor Cyan
    Write-Host "Command   : CMD_130" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GovPath = Join-Path $Root "Core\Knowledge\AI Governance Package"
    $ManifestPath = Join-Path $GovPath "08_PROJECT_MANIFEST.json"
    $StateFile = Join-Path $GovPath "02_PROJECT_STATE.json"

    # 1. Update Project State
    Write-Host "[CMD_130] Updating Project State to Phase 4 Complete..." -ForegroundColor Cyan
    try {
        $StateJson = Get-Content $StateFile -Raw | ConvertFrom-Json
        $StateJson.current_phase.id = "PHASE_4"
        $StateJson.current_phase.name = "Monetization & Web3 Integration"
        $StateJson.current_phase.status = "COMPLETED"
        $StateJson | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
        Write-Host "  [OK] Project State Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update project state: $_"
    }

    # 2. Re-Seal Governance Manifest
    Write-Host "[CMD_130] Re-Sealing Governance Manifest..." -ForegroundColor Cyan
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
        if (!(Test-Path $p)) { throw "Missing: $name" }
        $bytes = [System.IO.File]::ReadAllBytes($p)
        $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        $hashStr = ([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()
        $filesMeta += [ordered]@{ name = $name; version = "4.0.0"; sha256 = $hashStr; bytes = (Get-Item $p).Length; required = $true }
    }

    $manifest = [ordered]@{
        file_id = "08_PROJECT_MANIFEST"
        version = "4.0.0"
        package_name = "NASRIUM AI Governance Package"
        package_version = "4.0.0"
        generated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        package_path = $GovPath
        required_files = $required + @("08_PROJECT_MANIFEST.json")
        files = $filesMeta
    }
    $manifest | ConvertTo-Json -Depth 5 | Set-Content $ManifestPath -Encoding UTF8

    $selfRaw = [System.IO.File]::ReadAllBytes($ManifestPath)
    $selfHash = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($selfRaw)) -replace "-", "").ToLower()

    $manifest.files += [ordered]@{ name = "08_PROJECT_MANIFEST.json"; version = "4.0.0"; sha256 = $selfHash; bytes = $selfRaw.Length; required = $true }
    $manifest | ConvertTo-Json -Depth 5 | Set-Content $ManifestPath -Encoding UTF8
    Write-Host "  [OK] Manifest Re-Sealed." -ForegroundColor Green

    # 3. Registry
    Write-Host "[CMD_130] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_130_001"
            task = "Phase 4 Seal & Ecosystem Baseline Update"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_131"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_130_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_130 PHASE 4 SEAL COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_130_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_130" -Action { Seal-PhaseFour }
} else {
    Seal-PhaseFour
}
