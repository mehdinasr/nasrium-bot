# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_115
# File ID   : CMD_115_002
# Module    : Game
# Component : Game Engine Energy Integration Test Patch
# Version   : 1.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Patch-EnergyTest {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ENERGY INTEGRATION TEST PATCH" -ForegroundColor Cyan
    Write-Host "Command   : CMD_115_002" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"

    Write-Host "[CMD_115_002] Running Patched Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $EnergyPath = "$ModuleDir\NSM_EnergyEngine.psm1"
        $EngineFile = "$ModuleDir\NSM_GameEngine.psm1"
        
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
        
        # Test 2: Fail due to insufficient Energy
        # Give enough Gold, but not enough Energy
        $TestPlayer.Resources.Gold = 1000
        $TestPlayer.Resources.Energy = 5
        
        # GoldMine Level 2 costs 800 Gold, 20 Energy
        $Result2 = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($Result2.Status -ne "FAILED") { throw "Test 2 Failed: Should fail status." }
        if ($Result2.Reason -ne "InsufficientEnergy") { throw "Test 2 Failed: Should reject due to energy. Got: $($Result2.Reason)" }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_115_002] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_115_002"
            task = "Game Engine Energy Integration Test Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_116"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_115_002_state.json"), $state, [System.Text.Encoding]::UTF8)
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
    Invoke-NasriumCommand -CmdId "CMD_115_002" -Action { Patch-EnergyTest }
} else {
    Patch-EnergyTest
}
