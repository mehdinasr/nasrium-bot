# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_101
# File ID   : CMD_101_001
# Module    : Game
# Component : Game Configuration Schema Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-GameConfigEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME CONFIG SCHEMA BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_101" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"
    $MetadataDir = "$Root\Data\Metadata"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    if (!(Test-Path $MetadataDir)) { New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null }

    # Step 1: Generate Default Game Configuration JSON
    Write-Host "[CMD_101] Generating NSM_GameConfig.json..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    
    $ConfigLines = @(
        '{',
        '  "buildings": {',
        '    "TownHall": {',
        '      "levels": {',
        '        "1": { "cost_gold": 0, "build_time_seconds": 0 },',
        '        "2": { "cost_gold": 1000, "build_time_seconds": 60 }',
        '      }',
        '    },',
        '    "GoldMine": {',
        '      "levels": {',
        '        "1": { "cost_gold": 300, "build_time_seconds": 10 }',
        '        "2": { "cost_gold": 800, "build_time_seconds": 30 }',
        '      }',
        '    }',
        '  },',
        '  "economy": {',
        '    "initial_gold": 500,',
        '    "initial_nsm": 0,',
        '    "initial_energy": 100',
        '  }',
        '}'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] GameConfig.json Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Config JSON: $_"
    }

    # Step 2: Build Config Reader Module
    Write-Host "[CMD_101] Building NSM_GameConfig.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $ModuleDir "NSM_GameConfig.psm1"

    $ModuleLines = @(
        'function Get-NSMGameConfig {',
        '    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_GameConfig.json"',
        '    if (!(Test-Path $ConfigPath)) { throw "Game configuration file missing." }',
        '    return Get-Content $ConfigPath -Raw | ConvertFrom-Json',
        '}',
        '',
        'Export-ModuleMember -Function Get-NSMGameConfig'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] GameConfig Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to build GameConfig Module: $_"
    }

    # Step 3: Validation Test
    Write-Host "[CMD_101] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_GameConfig -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $Config = Get-NSMGameConfig
        
        if ($Config.economy.initial_gold -ne 500) { throw "Economy config read failed." }
        if ($Config.buildings.TownHall.levels."2".cost_gold -ne 1000) { throw "TownHall config read failed." }
        
        Write-Host "  [OK] Config Module Reads JSON Successfully." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # Step 4: Metadata & Registry
    Write-Host "[CMD_101] Sealing Metadata & Registry..." -ForegroundColor Cyan
    try {
        $Hash = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash
        $Validation = [ordered]@{
            Command = "CMD_101"
            SHA256  = $Hash
            Time    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $Validation | ConvertTo-Json | Set-Content "$MetadataDir\NSM_GAME_CONFIG_VALIDATION_V1.json" -Encoding UTF8

        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_101_001"
            task = "Build Game Configuration Schema Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_102"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_101_001_state.json"), $state, [System.Text.Encoding]::UTF8)

        Write-Host "  [OK] Metadata Sealed." -ForegroundColor Green
    } catch {
        throw "Failed to seal metadata: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_101 GAME CONFIG ENGINE DEPLOYED" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_101_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_101" -Action { Build-GameConfigEngine }
} else {
    Build-GameConfigEngine
}
