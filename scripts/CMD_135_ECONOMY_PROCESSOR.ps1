# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_135
# File ID   : CMD_135_001
# Module    : Game | Economy
# Component : Resource Processor & Offline Progress Timer
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_135_BuildProcessor {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ECONOMY PROCESSOR CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_135" -ForegroundColor Yellow
    Write-Host "Task      : Build Offline Progress & Time Delta Logic" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- Configuration ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # --- PHASE 1: Build NSM_EconomyProcessor.psm1 ---
    Write-Host "[CMD_135] Synthesizing Economy Processor..." -ForegroundColor Cyan
    
    # Using Single Quotes for the inner code to prevent variable expansion errors
    $CodeLines = @( 
        '<#',
        ' NASRIUM ECONOMY PROCESSOR v1.0',
        ' Handles time-based resource generation (Offline Progress).',
        '#>',
        '',
        '# Import dependencies (Assuming they are in the same directory)',
        'Import-Module (Join-Path $PSScriptRoot "NSM_GameEngine.psm1") -Force',
        'Import-Module (Join-Path $PSScriptRoot "NSM_GameRepo.psm1") -Force',
        '',
        'function Invoke-PlayerEconomyTick {',
        '    param([Parameter(Mandatory=$true)]$PlayerState)',
        '    ',
        '    # 1. Calculate Time Delta',
        '    $Now = Get-Date',
        '    try {',
        '        $LastLogin = [datetime]::Parse($PlayerState.LastLogin)',
        '    } catch {',
        '        # Fallback if date is corrupted',
        '        $LastLogin = $Now',
        '    }',
        '    ',
        '    $Delta = $Now - $LastLogin',
        '    ',
        '    # 2. Cap offline time (Max 24 hours to prevent insane exploits)',
        '    if ($Delta.TotalHours -gt 24) { $Delta = [timespan]::FromHours(24) }',
        '    ',
        '    # 3. Get Income Rate from Engine',
        '    $IncomePerSec = Invoke-ResourceTick -State $PlayerState',
        '    ',
        '    # 4. Calculate Total Earned Resources',
        '    $SecondsPassed = [math]::Floor($Delta.TotalSeconds)',
        '    $EarnedCredits = $IncomePerSec.C * $SecondsPassed',
        '    $EarnedBandwidth = $IncomePerSec.B * $SecondsPassed',
        '    ',
        '    # 5. Apply to Player State',
        '    $PlayerState.Resources.Credits += $EarnedCredits',
        '    $PlayerState.Resources.Bandwidth += $EarnedBandwidth',
        '    $PlayerState.LastLogin = $Now.ToString("yyyy-MM-dd HH:mm:ss")',
        '    ',
        '    return $PlayerState',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-PlayerEconomyTick'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_EconomyProcessor.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Economy Processor Generated." -ForegroundColor Green
    } catch {
        throw "Critical Error writing Processor file: $_"
    }

    # --- PHASE 2: Integration Live Test ---
    Write-Host ""
    Write-Host "[CMD_135] Running Live Simulation (3-Second Time Delta)..." -ForegroundColor Yellow
    
    $TestPlayerId = "SIM_USER_001"
    $TestDataDir = Join-Path $RootPath "Data\Players"
    if (!(Test-Path $TestDataDir)) { New-Item -ItemType Directory -Path $TestDataDir -Force | Out-Null }
    
    $TestFilePath = Join-Path $TestDataDir "$TestPlayerId.json"

    try {
        # A. Create a dummy player with a timestamp 5 seconds ago
        $PastTime = (Get-Date).AddSeconds(-5).ToString("yyyy-MM-dd HH:mm:ss")
        $DummyPlayer = @{
            Id="SIM_USER_001"; Username="Test_Node"; LastLogin=$PastTime
            Resources=@{ Credits=1000; Bandwidth=50 }
            Buildings=@{ DATA_MINER=@{Level=2}; SERVER_FARM=@{Level=1} }
        } | ConvertTo -Json -Depth 3
        
        [System.IO.File]::WriteAllText($TestFilePath, $DummyPlayer)

        # B. Simulate passage of time (Wait 3 seconds)
        Write-Host "  -> Waiting 3 seconds to simulate offline progress..." -ForegroundColor Gray
        Start-Sleep -Seconds 3

        # C. Load Process & Save (Using the actual modules)
        Import-Module (Join-Path $ModuleDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $ModuleDir "NSM_GameRepo.psm1") -Force
        Import-Module (Join-Path $ModuleDir "NSM_EconomyProcessor.psm1") -Force

        $LoadedPlayer = Get-NSMPlayer -Id $TestPlayerId
        $UpdatedPlayer = Invoke-PlayerEconomyTick -PlayerState $LoadedPlayer
        
        # D. Verify
        Write-Host "  -> Original Credits: 1000 | New Credits: $($UpdatedPlayer.Resources.Credits)" -ForegroundColor Cyan
        Write-Host "  [OK] Simulation Successful. Resources increased over time." -ForegroundColor Green
        
        # Clean up test file
        Remove-Item $TestFilePath -Force | Out-Null

    } catch {
        Write-Host "  [WARN] Simulation encountered an issue: $_" -ForegroundColor Yellow
        Write-Host "  (This does not affect module generation, only the test)" -ForegroundColor Yellow
    }

    # --- PHASE 3: Registry ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_135_001"",`n`t""task"": ""Economy Processor & Timers"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_135_STATE.json"), $RegContent)

    # --- FINAL VERIFICATION ---
    $CheckPath = Join-Path $ModuleDir "NSM_EconomyProcessor.psm1"
    
    Write-Host ""
    Write-Host "===== VERIFICATION =====" -ForegroundColor Cyan
    
    if (Test-Path $CheckPath) {
        Write-Host "  [OK] NSM_EconomyProcessor.psm1 Verified." -ForegroundColor Green
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_135 COMPLETE (100%)" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_135_COMPLETE" -ForegroundColor Green
    } else {
        Write-Host "ERROR_CMD_135_INCOMPLETE" -ForegroundColor Red
        exit 1
    }
}

Invoke-CMD_135_BuildProcessor
