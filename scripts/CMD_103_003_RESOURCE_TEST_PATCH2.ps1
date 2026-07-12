# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_103
# File ID   : CMD_103_003
# Module    : Game
# Component : Resource Engine Test Logic Patch 2
# Version   : 1.2.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Patch-ResourceEngineTest2 {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM RESOURCE ENGINE TEST PATCH 2" -ForegroundColor Cyan
    Write-Host "Command   : CMD_103_003" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"

    Write-Host "[CMD_103_003] Running Corrected Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $EnginePath = "$ModuleDir\NSM_GameEngine.psm1"
        $ResourceModule = "$ModuleDir\NSM_ResourceEngine.psm1"
        
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnginePath -Force
        Import-Module $ResourceModule -Force
        
        $TestPlayer = New-NSMPlayer -Username "Miner"
        
        # Test 1: Build GoldMine, Complete Upgrade, Claim Resources
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine" | Out-Null
        ($TestPlayer.Buildings | Where-Object { $_.Type -eq "GoldMine" }).Upgrading = $false
        
        $ClaimResult = Claim-NSMResources -Player $TestPlayer -BuildingType "GoldMine"
        if ($ClaimResult.Status -ne "SUCCESS" -or $ClaimResult.YieldAmount -ne 50) { throw "Test 1 Failed." }
        if ($TestPlayer.Resources.Gold -ne 250) { throw "Test 1 Failed: Gold calculation error." }
        
        # Test 2: Build TownHall (Free), Complete Upgrade, Try to Claim (Yield is 0)
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall" | Out-Null
        ($TestPlayer.Buildings | Where-Object { $_.Type -eq "TownHall" }).Upgrading = $false
        
        $TownHallResult = Claim-NSMResources -Player $TestPlayer -BuildingType "TownHall"
        if ($TownHallResult.Reason -ne "NoYieldDefined") { throw "Test 2 Failed: Should reject TownHall yield." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_103_003] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_103_003"
            task = "Resource Engine Test Logic Patch 2"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_104"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_103_003_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_103 RESOURCE ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_103_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_103_003" -Action { Patch-ResourceEngineTest2 }
} else {
    Patch-ResourceEngineTest2
}
