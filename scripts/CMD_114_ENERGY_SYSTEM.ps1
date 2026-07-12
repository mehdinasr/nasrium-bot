# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_114
# File ID   : CMD_114_001
# Module    : Game
# Component : Energy System Engine & Config Patch
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-EnergySystem {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ENERGY SYSTEM ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_114" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ModuleFile = Join-Path $ModuleDir "NSM_EnergyEngine.psm1"

    # Step 1: Patch Game Config to add Energy Costs
    Write-Host "[CMD_114] Patching NSM_GameConfig.json with Energy Costs..." -ForegroundColor Cyan
    try {
        $ConfigLines = @(
            '{',
            '  "buildings": {',
            '    "TownHall": {',
            '      "levels": {',
            '        "1": { "cost_gold": 0, "build_time_seconds": 0, "yield_gold_per_cycle": 0, "energy_cost_to_build": 0 },',
            '        "2": { "cost_gold": 1000, "build_time_seconds": 60, "yield_gold_per_cycle": 0, "energy_cost_to_build": 20 }',
            '      }',
            '    },',
            '    "GoldMine": {',
            '      "levels": {',
            '        "1": { "cost_gold": 300, "build_time_seconds": 10, "yield_gold_per_cycle": 50, "energy_cost_to_build": 10 },',
            '        "2": { "cost_gold": 800, "build_time_seconds": 30, "yield_gold_per_cycle": 150, "energy_cost_to_build": 20 }',
            '      }',
            '    }',
            '  },',
            '  "economy": {',
            '    "initial_gold": 500,',
            '    "initial_nsm": 0,',
            '    "initial_energy": 100,',
            '    "energy_regenerate_rate": 1',
            '  }',
            '}'
        ) -join "`r`n"
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch config: $_"
    }

    # Step 2: Build Energy Engine Module
    Write-Host "[CMD_114] Building NSM_EnergyEngine.psm1..." -ForegroundColor Cyan
    $ModuleLines = @(
        'function Use-NSMEnergy {',
        '    param($Player, [int]$Amount)',
        '    if ($Player.Resources.Energy -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientEnergy" }',
        '    }',
        '    $Player.Resources.Energy -= $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; SpentEnergy = $Amount; RemainingEnergy = $Player.Resources.Energy }',
        '}',
        '',
        'function Repair-NSMEnergy {',
        '    param($Player, [int]$Amount)',
        '    $Config = Get-NSMGameConfig',
        '    $MaxEnergy = $Config.economy.initial_energy',
        '    $Player.Resources.Energy = [math]::Min(($Player.Resources.Energy + $Amount), $MaxEnergy)',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; RepairedEnergy = $Amount; TotalEnergy = $Player.Resources.Energy }',
        '}',
        '',
        'Export-ModuleMember -Function Use-NSMEnergy, Repair-NSMEnergy'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Energy Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Energy Module: $_"
    }

    # Step 3: Unit Test
    Write-Host "[CMD_114] Running Unit Tests..." -ForegroundColor Cyan
    try {
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_EnergyEngine -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "EnergyUser"
        
        # Test 1: Use Energy
        $UseResult = Use-NSMEnergy -Player $TestPlayer -Amount 30
        if ($UseResult.Status -ne "SUCCESS" -or $TestPlayer.Resources.Energy -ne 70) { throw "Test 1 Failed: Use energy failed." }
        
        # Test 2: Insufficient Energy
        $FailResult = Use-NSMEnergy -Player $TestPlayer -Amount 100
        if ($FailResult.Reason -ne "InsufficientEnergy") { throw "Test 2 Failed: Should reject insufficient energy." }
        
        # Test 3: Repair Energy (Over max)
        $RepairResult = Repair-NSMEnergy -Player $TestPlayer -Amount 50
        if ($TestPlayer.Resources.Energy -ne 100) { throw "Test 3 Failed: Energy should cap at 100." }

        Write-Host "  [OK] Unit Tests Passed." -ForegroundColor Green
    } catch {
        throw "Unit Test Failed: $_"
    }

    # Step 4: Registry
    Write-Host "[CMD_114] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_114_001"
            task = "Energy System Engine & Config Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_115"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_114_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_114 ENERGY ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_114_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_114" -Action { Build-EnergySystem }
} else {
    Build-EnergySystem
}
