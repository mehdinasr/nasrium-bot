# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_109
# File ID   : CMD_109_001
# Module    : Infrastructure
# Component : Player Status Query Integration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-StatusQuery {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PLAYER STATUS QUERY BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_109" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Infrastructure"
    $ModuleFile = Join-Path $ModuleDir "NSM_GameRouter.psm1"

    Write-Host "[CMD_109] Updating NSM_GameRouter.psm1 with /status..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Invoke-NSMGameCommand {',
        '    param([string]$ChatId, [string]$CommandText)',
        '    ',
        '    $Parts = $CommandText -split " "', 
        '    $Cmd = $Parts[0].ToLower()',
        '    $Arg1 = if ($Parts.Length -gt 1) { $Parts[1] } else { "" }',
        '    ',
        '    $Player = $null',
        '    try {',
        '        $Player = Load-NSMPlayer -PlayerId $ChatId',
        '    } catch {',
        '        $Player = New-NSMPlayer -Username "TG_$ChatId"',
        '        $Player.Id = $ChatId',
        '        Save-NSMPlayer -Player $Player | Out-Null',
        '    }',
        '    ',
        '    $ResponseText = ""',
        '    ',
        '    switch ($Cmd) {',
        '        "/start" {',
        '            $ResponseText = "Welcome to NASRIUM! You have 500 Gold. Use /build GoldMine to start."',
        '        }',
        '        "/status" {',
        '            $ResponseText = "=== NASRIUM STATUS ===`r`nUsername: $($Player.Username)`r`nLevel: $($Player.Level)`r`nGold: $($Player.Resources.Gold)`r`nNSM: $($Player.Resources.NSM)`r`nEnergy: $($Player.Resources.Energy)`r`nBuildings: $($Player.Buildings.Count)"',
        '        }',
        '        "/build" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }',
        '            $OriginalGold = $Player.Resources.Gold',
        '            $OriginalBuildings = $Player.Buildings | ConvertTo-Json -Depth 3 | ConvertFrom-Json',
        '            try {',
        '                $Result = Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1',
        '                if ($Result.Status -eq "FAILED") { throw "Action failed: $($Result.Reason)" }',
        '                Save-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: $Arg1 upgraded to Level $($Result.NewLevel). Gold left: $($Result.RemainingGold)"',
        '            } catch {',
        '                $Player.Resources.Gold = $OriginalGold',
        '                $Player.Buildings = $OriginalBuildings',
        '                $ResponseText = "FAILED: $($_.Exception.Message)"',
        '            }',
        '        }',
        '        default {',
        '            $ResponseText = "Unknown command. Use /start, /status, or /build."',
        '        }',
        '    }',
        '    ',
        '    return $ResponseText',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-NSMGameCommand'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Router Module Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Router Module: $_"
    }

    Write-Host "[CMD_109] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $GameDir = "$Root\Core\Modules\Game"
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_GameRouter -ErrorAction SilentlyContinue
        Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_PlayerPersistence.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameSession.psm1") -Force
        Import-Module $ModuleFile -Force
        
        $TestChatId = "TG_STATUS_TEST_001"
        
        # Test 1: Start & Build
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start" | Out-Null
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/build GoldMine" | Out-Null
        
        # Test 2: Status Query
        $Result2 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/status"
        if ($Result2 -notmatch "Gold: 200") { throw "Test 2 Failed: Status should show 200 Gold (500-300)." }
        if ($Result2 -notmatch "Buildings: 1") { throw "Test 2 Failed: Status should show 1 Building." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_109] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_109_001"
            task = "Player Status Query Integration"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_110"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_109_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_109 STATUS QUERY COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_109_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_109" -Action { Build-StatusQuery }
} else {
    Build-StatusQuery
}
