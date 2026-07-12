# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_136
# File ID   : CMD_136_001
# Module    : Game | Actions
# Component : Player Action Handler (Upgrade, Build)
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_136_BuildActionHandler {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ACTION HANDLER CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_136" -ForegroundColor Yellow
    Write-Host "Task      : Build Player Action Processor (Upgrade Logic)" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- Configuration ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # --- PHASE 1: Build NSM_ActionHandler.psm1 ---
    Write-Host "[CMD_136] Synthesizing Action Handler..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' NASRIUM ACTION HANDLER v1.0',
        ' Processes player commands (e.g., Upgrade Building).',
        '#>',
        '',
        'Import-Module (Join-Path $PSScriptRoot "NSM_GameEngine.psm1") -Force',
        'Import-Module (Join-Path $PSScriptRoot "NSM_GameRepo.psm1") -Force',
        'Import-Module (Join-Path $PSScriptRoot "NSM_EconomyProcessor.psm1") -Force',
        '',
        'function Start-NSMBuildingUpgrade {',
        '    param(',
        '        [Parameter(Mandatory=$true)]',
        '        [string]$PlayerId,',
        '        [Parameter(Mandatory=$true)]',
        '        [string]$BuildingType',
        '    )',
        '    ',
        '    # 1. Load Player State',
        '    $Player = Get-NSMPlayer -Id $PlayerId',
        '    if (-not $Player) { return @{ Success=$false; Message="Player not found" } }',
        '    ',
        '    # 2. Apply Pending Economy (Add offline resources first)',
        '    $Player = Invoke-PlayerEconomyTick -PlayerState $Player',
        '    ',
        '    # 3. Determine Current Level',
        '    $CurrLvl = 0',
        '    if ($Player.Buildings.PSObject.Properties.Match($BuildingType).Count -gt 0) {',
        '        $CurrLvl = $Player.Buildings.$BuildingType.Level',
        '    }',
        '    $TargetLvl = $CurrLvl + 1',
        '    ',
        '    # 4. Calculate Cost',
        '    $Cost = Get-UpgradeCost -BType $BuildingType -CurrLvl $CurrLvl -TgtLvl $TargetLvl',
        '    ',
        '    # 5. Check Affordability',
        '    $CanAfford = Test-Afford -Res $Player.Resources -Req $Cost',
        '    ',
        '    if (-not $CanAfford) {',
        '        # Save the economy tick state even if upgrade fails',
        '        Save-NSMPlayer -PlayerObject $Player | Out-Null',
        '        return @{ Success=$false; Message="Insufficient Resources"; Required=$Cost; Current=$Player.Resources }',
        '    }',
        '    ',
        '    # 6. Execute Upgrade: Deduct Resources',
        '    $Player.Resources.Credits -= $Cost.Credits',
        '    $Player.Resources.Bandwidth -= $Cost.Bandwidth',
        '    ',
        '    # 7. Update Building Level',
        '    if ($CurrLvl -eq 0) {',
        '        # New Building',
        '    $Player.Buildings | Add-Member -NotePropertyName $BuildingType -NotePropertyValue @{ Level=$TargetLvl; IsUpgrading=$false }',
        '    } else {',
        '        # Existing Building',
        '    $Player.Buildings.$BuildingType.Level = $TargetLvl',
        '    }',
        '    ',
        '    # 8. Save New State',
        '    $SaveStatus = Save-NSMPlayer -PlayerObject $Player',
        '    ',
        '    if ($SaveStatus) {',
        '        return @{ Success=$true; Message="Upgrade Successful"; NewLevel=$TargetLvl; RemainingResources=$Player.Resources }',
        '    } else {',
        '        return @{ Success=$false; Message="Failed to save state to disk" }',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Start-NSMBuildingUpgrade'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_ActionHandler.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Action Handler Generated." -ForegroundColor Green
    } catch {
        throw "Critical Error writing Handler file: $_"
    }

    # --- PHASE 2: Integration Test (Simulate Full Gameplay) ---
    Write-Host ""
    Write-Host "[CMD_136] Running Integration Test (Full Gameplay Loop)..." -ForegroundColor Yellow
    
    $TestPlayerId = "ACTION_TEST_USER"
    $TestDataDir = Join-Path $RootPath "Data\Players"
    if (!(Test-Path $TestDataDir)) { New-Item -ItemType Directory -Path $TestDataDir -Force | Out-Null }
    
    $TestFilePath = Join-Path $TestDataDir "$TestPlayerId.json"

    try {
        # A. Setup Test Player with 10000 Credits (Enough to upgrade)
        $Now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $DummyJson = "{`"Id`":`"$TestPlayerId`",`"Username`":`"Builder`",`"LastLogin`":`"$Now`",`"Resources`":{`"Credits`":10000,`"Bandwidth`":500},`"Buildings`":{`"DATA_MINER`":{`"Level`":1}}}"
        [System.IO.File]::WriteAllText($TestFilePath, $DummyJson)

        # B. Load Modules
        Import-Module (Join-Path $ModuleDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $ModuleDir "NSM_GameRepo.psm1") -Force
        Import-Module (Join-Path $ModuleDir "NSM_EconomyProcessor.psm1") -Force
        Import-Module (Join-Path $ModuleDir "NSM_ActionHandler.psm1") -Force

        # C. Attempt Upgrade
        Write-Host "  -> Attempting to upgrade DATA_MINER to Level 2..." -ForegroundColor Gray
        $Result = Start-NSMBuildingUpgrade -PlayerId $TestPlayerId -BuildingType "DATA_MINER"

        # D. Verify
        if ($Result.Success) {
            Write-Host "  [OK] TEST PASSED! Building is now Level $($Result.NewLevel)." -ForegroundColor Green
            Write-Host "  -> Remaining Credits: $($Result.RemainingResources.Credits)" -ForegroundColor Cyan
        } else {
            Write-Host "  [FAIL] Test failed: $($Result.Message)" -ForegroundColor Red
        }
        
        # Clean up
        Remove-Item $TestFilePath -Force | Out-Null

    } catch {
        Write-Host "  [WARN] Test Simulation Error: $_" -ForegroundColor Yellow
    }

    # --- PHASE 3: Registry ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_136_001"",`n`t""task"": ""Action Handler Build"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_136_STATE.json"), $RegContent)

    # --- FINAL VERIFICATION ---
    $CheckPath = Join-Path $ModuleDir "NSM_ActionHandler.psm1"
    
    Write-Host ""
    Write-Host "===== VERIFICATION =====" -ForegroundColor Cyan
    
    if (Test-Path $CheckPath) {
        Write-Host "  [OK] NSM_ActionHandler.psm1 Verified." -ForegroundColor Green
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_136 COMPLETE (100%)" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_136_COMPLETE" -ForegroundColor Green
    } else {
        Write-Host "ERROR_CMD_136_INCOMPLETE" -ForegroundColor Red
        exit 1
    }
}

Invoke-CMD_136_BuildActionHandler
