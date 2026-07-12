# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_102
# File ID   : CMD_102_001
# Module    : Game
# Component : Game Engine - Building Upgrade Logic
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-GameEngineUpgrade {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ENGINE: BUILDING UPGRADE" -ForegroundColor Cyan
    Write-Host "Command   : CMD_102" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ModuleFile = "$ModuleDir\NSM_GameEngine.psm1"
    $MetadataDir = "$Root\Data\Metadata"

    Write-Host "[CMD_102] Building NSM_GameEngine.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
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
        '    $Cost = $LevelConfig.cost_gold',
        '    if ($Player.Resources.Gold -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }',
        '    }',
        '    ',
        '    # Deduct Resources',
        '    $Player.Resources.Gold -= $Cost',
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
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; NewLevel = $NextLevel; RemainingGold = $Player.Resources.Gold }',
        '}',
        '',
        'Export-ModuleMember -Function Start-NSMBuildingUpgrade'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Engine Module: $_"
    }

    Write-Host "[CMD_102] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        
        Remove-Module NSM_GameEngine, NSM_GameDomain, NSM_GameConfig -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "TestPlayer"
        
        # Test 1: Build new TownHall (Should be free at level 1, but config starts check from level 1 to 2)
        # Wait, domain logic creates player with no buildings. Let's build a GoldMine (Cost: 300)
        $Result1 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($Result1.Status -ne "SUCCESS") { throw "Test 1 Failed: Upgrade should succeed." }
        if ($TestPlayer.Resources.Gold -ne 200) { throw "Test 1 Failed: Gold not deducted (500-300=200)." }
        if ($TestPlayer.Buildings.Count -ne 1) { throw "Test 1 Failed: Building not added." }
        
        # Test 2: Insufficient Funds (GoldMine Level 2 costs 800, player has 200)
        $Result2 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($Result2.Status -ne "FAILED" -or $Result2.Reason -ne "InsufficientGold") { throw "Test 2 Failed: Should reject due to funds." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_102] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_102_001"
            task = "Game Engine - Building Upgrade Logic"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_103"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_102_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_102 GAME ENGINE UPGRADE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_102_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_102" -Action { Build-GameEngineUpgrade }
} else {
    Build-GameEngineUpgrade
}
