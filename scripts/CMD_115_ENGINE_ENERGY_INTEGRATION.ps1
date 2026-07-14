# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_115
# File ID   : CMD_115_001
# Module    : Game
# Component : Game Engine Energy Integration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Integrate-EnergyIntoEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ENGINE ENERGY INTEGRATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_115" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $EngineFile = Join-Path $ModuleDir "NSM_GameEngine.psm1"

    Write-Host "[CMD_115] Upgrading NSM_GameEngine.psm1 with Energy Logic..." -ForegroundColor Cyan
    
    $EngineLines = @(
        'function Start-NSMBuildingUpgrade {',
        '    param($Player, [string]$BuildingType)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $CurrentLevel = 0',
        '    $TargetBuilding = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType } | Select-Object -First 1',
        '    ',
        '    if ($TargetBuilding) {',
        '        $CurrentLevel = $TargetBuilding.Level',
        '    }',
        '    ',
        '    $NextLevel = $CurrentLevel + 1',
        '    $LevelConfig = $Config.buildings.$BuildingType.levels."$NextLevel"',
        '    ',
        '    if (-not $LevelConfig) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "MaxLevelReached" }',
        '    }',
        '    ',
        '    $CostGold = $LevelConfig.cost_gold',
        '    $CostEnergy = $LevelConfig.energy_cost_to_build',
        '    ',
        '    if ($Player.Resources.Gold -lt $CostGold) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }',
        '    }',
        '    ',
        '    if ($Player.Resources.Energy -lt $CostEnergy) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientEnergy" }',
        '    }',
        '    ',
        '    # Deduct Resources',
        '    $Player.Resources.Gold -= $CostGold',
        '    $Player.Resources.Energy -= $CostEnergy',
        '    ',
        '    # Update or Add Building',
        '    if ($TargetBuilding) {',
        '        $TargetBuilding.Level = $NextLevel',
        '        $TargetBuilding.Upgrading = $true',
        '    } else {',
        '        $NewBuilding = New-NSMBuilding -Type $BuildingType -Level $NextLevel',
        '        $NewBuilding.Upgrading = $true',
        '        $Player.Buildings += $NewBuilding',
        '    }',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; NewLevel = $NextLevel; RemainingGold = $Player.Resources.Gold; RemainingEnergy = $Player.Resources.Energy }',
        '}',
        '',
        'Export-ModuleMember -Function Start-NSMBuildingUpgrade'
    )

    try {
        $ModuleContent = $EngineLines -join "`r`n"
        [System.IO.File]::WriteAllText($EngineFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Engine Upgraded." -ForegroundColor Green
    } catch {
        throw "Failed to upgrade Engine: $_"
    }

    Write-Host "[CMD_115] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $EnergyPath = "$ModuleDir\NSM_EnergyEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_EnergyEngine, NSM_GameEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnergyPath -Force
        Import-Module $EngineFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "EnergyTester"
        
        # Test 1: Succeed with enough Gold & Energy (Cost: 300 Gold, 10 Energy)
        $Result1 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($Result1.Status -ne "SUCCESS") { throw "Test 1 Failed: Should succeed." }
        if ($TestPlayer.Resources.Gold -ne 200) { throw "Test 1 Failed: Gold not deducted." }
        if ($TestPlayer.Resources.Energy -ne 90) { throw "Test 1 Failed: Energy not deducted." }
        
        # Test 2: Fail due to insufficient Energy (Player has 90, needs 20 for next level)
        # Let's drain energy manually to test
        $TestPlayer.Resources.Energy = 5
        $Result2 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall"
        if ($Result2.Reason -ne "InsufficientEnergy") { throw "Test 2 Failed: Should reject due to energy. Got: $($Result2.Reason)" }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_115] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_115_001"
            task = "Game Engine Energy Integration"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_116"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_115_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_115 ENERGY INTEGRATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_115_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_115" -Action { Integrate-EnergyIntoEngine }
} else {
    Integrate-EnergyIntoEngine
}
