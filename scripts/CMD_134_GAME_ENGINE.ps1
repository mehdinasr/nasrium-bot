# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_134
# File ID   : CMD_134_001
# Module    : Game | Engine
# Component : Core Game Logic & Economy Calculator
# Version   : 1.0.5 (Ultimate Stable)
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_134_BuildEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ENGINE CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_134" -ForegroundColor Yellow
    Write-Host "Task      : Initialize Core Logic (Economy)" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- Configuration ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # --- PHASE 1: Build NSM_GameEngine.psm1 (Logic Layer) ---
    Write-Host "[CMD_134] Synthesizing Engine Core..." -ForegroundColor Cyan
    
    # Using Single Quotes for the inner code to prevent expansion errors
    $CodeLines = @( 
        '<#',
        ' NASRIUM CORE GAME ENGINE v1.0',
        '#>',
        '',
        'function Get-NSMGameConfig {',
        '    $cPath = "D:\NASRIUM\Core\Config\NSM_GameConfig.json"',
        '    if (Test-Path $cPath) { return Get-Content $cPath -Raw | ConvertFrom-Json }',
        '    else { throw "Missing Config" }',
        '}',
        '',
        'function Get-UpgradeCost {',
        '    param([string]$BType, [int]$CurrLvl, [int]$TgtLvl)',
        '    $Conf = Get-NSMGameConfig',
        '    $Cost = @{ Credits=0; Bandwidth=0 }',
        '    for ($L = ($CurrLvl+1); $L -le $TgtLvl; $L++) {',
        '        $k = "$L"',
        '        if ($Conf.buildings.$BType.levels.$k) {',
        '            $d = $Conf.buildings.$BType.levels.$k',
        '            $Cost.Credits += $d.cost_gold',
        '            $Cost.Bandwidth += $d.energy_cost_to_build',
        '        } else {',
        '            # Fallback Formula for dynamic balancing',
        '            $Cost.Credits += [math]::Floor(500 * [math]::Pow($L, 1.5))',
        '            $Cost.Bandwidth += [math]::Floor(10 * $L)',
        '        }',
        '    }',
        '    return $Cost',
        '}',
        '',
        'function Test-Afford {',
        '    param([object]$Res, [object]$Req)',
        '    return ($Res.Credits -ge $Req.Credits) -and ($Res.Bandwidth -ge $Req.Bandwidth)',
        '}',
        '',
        'function Invoke-ResourceTick {',
        '    param([object]$State)',
        '    $Inc = @{ C=0; B=0 }',
        '    foreach ($prop in $State.Buildings.PSObject.Properties) {',
        '        if ($prop.Name -eq "DATA_MINER") { $Inc.C += ($prop.Value.Level * 5) }',
        '        elseif ($prop.Name -eq "SERVER_FARM") { $Inc.B += ($prop.Value.Level * 2) }',
        '    }',
        '    return $Inc',
        '}',
        '',
        'Export-ModuleMember -Function Get-UpgradeCost, Test-Afford, Invoke-ResourceTick'
    )

    # Writing the Module File
    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_GameEngine.psm1"
        
        # Atomic Write Operation
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Engine Core Generated." -ForegroundColor Green
    } catch {
        throw "Critical Error writing Engine file: $_"
    }

    # --- PHASE 2: Safe Registry Update ---
    Write-Host "[CMD_134] Updating Registry..." -ForegroundColor Cyan
    
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    
    # Building a manual JSON string to avoid ConvertTo-Json command issues
    $JsonRegContent = "{`n`t""cmd_id"": ""CMD_134_001"",`n`t""task"": ""Engine Build"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"

    try {
        [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_134_STATE.json"), $JsonRegContent)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        # Even if registry fails, we shouldn't crash the whole command if engine is built.
        Write-Host "  [WARN] Could not write registry log, but Engine is built." -ForegroundColor Yellow
    }

    # --- FINAL VERIFICATION & EXIT ---
    $CheckPath = Join-Path $ModuleDir "NSM_GameEngine.psm1"
    
    Write-Host ""
    Write-Host "===== VERIFICATION =====" -ForegroundColor Cyan
    
    if (Test-Path $CheckPath) {
        Write-Host "  [OK] NSM_GameEngine.psm1 Verified on Disk." -ForegroundColor Green
        
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_134 COMPLETE (100%)" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_134_COMPLETE" -ForegroundColor Green
    } else {
        Write-Host "ERROR_CMD_134_INCOMPLETE" -ForegroundColor Red
        exit 1
    }
}

Invoke-CMD_134_BuildEngine
