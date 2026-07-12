# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_103
# File ID   : CMD_103_001
# Module    : Game
# Component : Resource Production Engine & Config Patch
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ResourceEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM RESOURCE PRODUCTION ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_103" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ConfigDir = "$Root\Core\Config"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ModuleFile = Join-Path $ModuleDir "NSM_ResourceEngine.psm1"

    # Step 1: Patch Game Config to add Yields
    Write-Host "[CMD_103] Patching NSM_GameConfig.json with Resource Yields..." -ForegroundColor Cyan
    try {
        $ConfigLines = @(
            '{',
            '  "buildings": {',
            '    "TownHall": {',
            '      "levels": {',
            '        "1": { "cost_gold": 0, "build_time_seconds": 0, "yield_gold_per_cycle": 0 },',
            '        "2": { "cost_gold": 1000, "build_time_seconds": 60, "yield_gold_per_cycle": 0 }',
            '      }',
            '    },',
            '    "GoldMine": {',
            '      "levels": {',
            '        "1": { "cost_gold": 300, "build_time_seconds": 10, "yield_gold_per_cycle": 50 },',
            '        "2": { "cost_gold": 800, "build_time_seconds": 30, "yield_gold_per_cycle": 150 }',
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
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch config: $_"
    }

    # Step 2: Build Resource Engine Module
    Write-Host "[CMD_103] Building NSM_ResourceEngine.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Claim-NSMResources {',
        '    param($Player, [string]$BuildingType)',
        '    ',
        '    $Building = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType -and -not $_.Upgrading } | Select-Object -First 1',
        '    if (-not $Building) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BuildingNotFoundOrUpgrading" }',
        '    }',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $Yield = $Config.buildings.$BuildingType.levels."$($Building.Level)".yield_gold_per_cycle',
        '    ',
        '    if (-not $Yield -or $Yield -eq 0) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "NoYieldDefined" }',
        '    }',
        '    ',
        '    $Player.Resources.Gold += $Yield',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; YieldAmount = $Yield; TotalGold = $Player.Resources.Gold }',
        '}',
        '',
        'Export-ModuleMember -Function Claim-NSMResources'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Resource Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Resource Module: $_"
    }

    # Step 3: Integration Test
    Write-Host "[CMD_103] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $EnginePath = "$ModuleDir\NSM_GameEngine.psm1"
        
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnginePath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "Miner"
        
        # Build a GoldMine (Costs 300, Player has 500 -> 200 left)
        $BuildResult = Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        if ($BuildResult.Status -ne "SUCCESS") { throw "Setup Failed: Could not build GoldMine." }
        
        # Claim Resources (GoldMine Level 1 yields 50)
        $ClaimResult = Claim-NSMResources -Player $TestPlayer -BuildingType "GoldMine"
        if ($ClaimResult.Status -ne "SUCCESS" -or $ClaimResult.YieldAmount -ne 50) { throw "Test 1 Failed: Resource claim unsuccessful." }
        if ($TestPlayer.Resources.Gold -ne 250) { throw "Test 1 Failed: Gold not added correctly (200 + 50 = 250)." }
        
        # Try to claim from TownHall (Yield is 0)
        $TownHallResult = Claim-NSMResources -Player $TestPlayer -BuildingType "TownHall"
        if ($TownHallResult.Reason -ne "NoYieldDefined") { throw "Test 2 Failed: Should reject TownHall yield." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # Step 4: Registry
    Write-Host "[CMD_103] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_103_001"
            task = "Resource Production Engine & Config Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_104"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_103_001_state.json"), $state, [System.Text.Encoding]::UTF8)
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
    Invoke-NasriumCommand -CmdId "CMD_103" -Action { Build-ResourceEngine }
} else {
    Build-ResourceEngine
}
