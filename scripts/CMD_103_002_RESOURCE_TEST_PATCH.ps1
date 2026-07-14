# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_103
# File ID   : CMD_103_002
# Module    : Game
# Component : Resource Engine Test Logic Patch
# Version   : 1.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Patch-ResourceEngineTest {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM RESOURCE ENGINE TEST PATCH" -ForegroundColor Cyan
    Write-Host "Command   : CMD_103_002" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ResourceModule = "$ModuleDir\NSM_ResourceEngine.psm1"

    Write-Host "[CMD_103_002] Running Patched Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $EnginePath = "$ModuleDir\NSM_GameEngine.psm1"
        
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnginePath -Force
        Import-Module $ResourceModule -Force
        
        $TestPlayer = New-NSMPlayer -Username "Miner"
        
        # Build a GoldMine
        $BuildResult = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($BuildResult.Status -ne "SUCCESS") { throw "Setup Failed: Could not build GoldMine." }
        
        # Simulate Upgrade Completion (Set Upgrading to false)
        $GoldMine = $TestPlayer.Buildings | Where-Object { $_.Type -eq "GoldMine" } | Select-Object -First 1
        if ($GoldMine) { $GoldMine.Upgrading = $false }
        
        # Claim Resources (GoldMine Level 1 yields 50)
        $ClaimResult = Claim-NSMResources -Player $TestPlayer -BuildingType "GoldMine"
        if ($ClaimResult.Status -ne "SUCCESS" -or $ClaimResult.YieldAmount -ne 50) { throw "Test 1 Failed: Resource claim unsuccessful. Status: $($ClaimResult.Status) Reason: $($ClaimResult.Reason)" }
        if ($TestPlayer.Resources.Gold -ne 250) { throw "Test 1 Failed: Gold not added correctly (200 + 50 = 250)." }
        
        # Try to claim from TownHall (Yield is 0)
        $TownHallResult = Claim-NSMResources -Player $TestPlayer -BuildingType "TownHall"
        if ($TownHallResult.Reason -ne "NoYieldDefined") { throw "Test 2 Failed: Should reject TownHall yield." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_103_002] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_103_002"
            task = "Resource Engine Test Logic Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_104"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_103_002_state.json"), $state, [System.Text.Encoding]::UTF8)
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
    Invoke-NasriumCommand -CmdId "CMD_103_002" -Action { Patch-ResourceEngineTest }
} else {
    Patch-ResourceEngineTest
}
