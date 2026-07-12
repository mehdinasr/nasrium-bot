# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_120
# File ID   : CMD_120_001
# Module    : Game
# Component : Town Hall Upgrade Constraint Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Implement-THConstraint {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TOWN HALL CONSTRAINT ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_120" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $EngineFile = Join-Path $GameDir "NSM_GameEngine.psm1"

    Write-Host "[CMD_120] Upgrading NSM_GameEngine.psm1 with TH 80% Rule..." -ForegroundColor Cyan
    
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
        '    # Town Hall 80% Rule Enforcement',
        '    if ($BuildingType -eq "TownHall" -and $CurrentLevel -ge 1) {',
        '        $OtherBuildings = $Player.Buildings | Where-Object { $_.Type -ne "TownHall" }',
        '        $TotalOther = $OtherBuildings.Count',
        '        if ($TotalOther -eq 0) {',
        '            return [PSCustomObject]@{ Status = "FAILED"; Reason = "TownHallRequires80PercentUpgrades" }',
        '        }',
        '        $UpgradedOther = ($OtherBuildings | Where-Object { $_.Level -ge $CurrentLevel }).Count',
        '        $UpgradeRatio = $UpgradedOther / $TotalOther',
        '        if ($UpgradeRatio -lt 0.8) {',
        '            return [PSCustomObject]@{ Status = "FAILED"; Reason = "TownHallRequires80PercentUpgrades" }',
        '        }',
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

    Write-Host "[CMD_120] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $EnergyPath = "$GameDir\NSM_EnergyEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_EnergyEngine, NSM_GameEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnergyPath -Force
        Import-Module $EngineFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "THConstraintTest"
        
        # Setup: Give player resources
        $TestPlayer.Resources.Gold = 100000
        $TestPlayer.Resources.Energy = 1000
        
        # Build TownHall Level 1
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall" | Out-Null
        
        # Test 1: Try to upgrade TH2 with 0 other buildings (Should fail)
        $Result1 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall"
        if ($Result1.Reason -ne "TownHallRequires80PercentUpgrades") { throw "Test 1 Failed: Should require 80% upgrades. Got: $($Result1.Reason)" }
        
        # Setup: Build 1 GoldMine (Level 1)
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine" | Out-Null
        
        # Test 2: Try to upgrade TH2 with 1 building at level 1 (1/1 = 100% >= 80% -> Should succeed)
        $Result2 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall"
        if ($Result2.Status -ne "SUCCESS") { throw "Test 2 Failed: Should allow TH2 with 100% upgraded. Got: $($Result2.Reason)" }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_120] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_120_001"
            task = "Town Hall Upgrade Constraint Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_121"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_120_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_120 TH CONSTRAINT COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_120_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_120" -Action { Implement-THConstraint }
} else {
    Implement-THConstraint
}
