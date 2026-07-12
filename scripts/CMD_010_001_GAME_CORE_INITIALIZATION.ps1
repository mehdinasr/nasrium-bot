# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_010
# File ID   : CMD_010_001
# Module    : Game
# Component : Core Structure Initialization
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM GAME CORE INITIALIZATION" -ForegroundColor Cyan
Write-Host "Command : CMD_010_001" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

# Load Orchestrator (Integrity Enforced)
. "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

Invoke-NasriumCommand -CmdId "CMD_010_001" -Action {

    $Root = "D:\NASRIUM"
    $GameRoot = Join-Path $Root "Core\Game"

    $dirs = @(
        "Engine",
        "Domain",
        "Services",
        "Infrastructure",
        "Contracts",
        "Config"
    )

    foreach ($dir in $dirs) {
        $path = Join-Path $GameRoot $dir
        if (!(Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "Created: $path" -ForegroundColor Green
        }
    }

    # Create Game Manifest
    $manifest = @{
        module = "Game"
        version = "1.0.0"
        created_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        architecture = "Layered Modular"
        dependencies = @()
    } | ConvertTo-Json -Depth 3

    $manifestPath = Join-Path $GameRoot "GAME_MODULE_MANIFEST.json"
    $manifest | Set-Content $manifestPath -Encoding UTF8

    Write-Host "Game Module Manifest Created." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✅ CMD_010_001 COMPLETE - GAME LAYER INITIALIZED" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_010
# File ID   : CMD_010_001
# Module    : Game
# Component : Core Structure Initialization
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM GAME CORE INITIALIZATION" -ForegroundColor Cyan
Write-Host "Command : CMD_010_001" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

# Load Orchestrator (Integrity Enforced)
. "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

Invoke-NasriumCommand -CmdId "CMD_010_001" -Action {

    $Root = "D:\NASRIUM"
    $GameRoot = Join-Path $Root "Core\Game"

    $dirs = @(
        "Engine",
        "Domain",
        "Services",
        "Infrastructure",
        "Contracts",
        "Config"
    )

    foreach ($dir in $dirs) {
        $path = Join-Path $GameRoot $dir
        if (!(Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "Created: $path" -ForegroundColor Green
        }
    }

    # Create Game Manifest
    $manifest = @{
        module = "Game"
        version = "1.0.0"
        created_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        architecture = "Layered Modular"
        dependencies = @()
    } | ConvertTo-Json -Depth 3

    $manifestPath = Join-Path $GameRoot "GAME_MODULE_MANIFEST.json"
    $manifest | Set-Content $manifestPath -Encoding UTF8

    Write-Host "Game Module Manifest Created." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✅ CMD_010_001 COMPLETE - GAME LAYER INITIALIZED" -ForegroundColor Green
