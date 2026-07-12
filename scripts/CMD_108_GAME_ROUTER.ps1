# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_108
# File ID   : CMD_108_001
# Module    : Infrastructure
# Component : Telegram Game Command Router
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-GameRouter {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME COMMAND ROUTER BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_108" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Infrastructure"
    $ModuleFile = Join-Path $ModuleDir "NSM_GameRouter.psm1"

    Write-Host "[CMD_108] Building NSM_GameRouter.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Invoke-NSMGameCommand {',
        '    param([string]$ChatId, [string]$CommandText)',
        '    ',
        '    # Load Dependencies',
        '    $GameDir = "D:\NASRIUM\Core\Modules\Game"',
        '    Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force',
        '    Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force',
        '    Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force',
        '    Import-Module (Join-Path $GameDir "NSM_PlayerPersistence.psm1") -Force',
        '    Import-Module (Join-Path $GameDir "NSM_GameSession.psm1") -Force',
        '    ',
        '    # Load or Create Player using ChatId as PlayerId',
        '    $Player = $null',
        '    try {',
        '        $Player = Load-NSMPlayer -PlayerId $ChatId',
        '    } catch {',
        '        $Player = New-NSMPlayer -Username "TG_$ChatId"',
        '        $Player.Id = $ChatId',
        '        Save-NSMPlayer -Player $Player | Out-Null',
        '    }',
        '    ',
        '    $Parts = $CommandText -split " "', 
        '    $Cmd = $Parts[0].ToLower()',
        '    $Arg1 = if ($Parts.Length -gt 1) { $Parts[1] } else { "" }',
        '    ',
        '    $ResponseText = ""',
        '    ',
        '    switch ($Cmd) {',
        '        "/start" {',
        '            $ResponseText = "Welcome to NASRIUM! You have 500 Gold. Use /build GoldMine to start."',
        '        }',
        '        "/build" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }',
        '            $Result = Invoke-NSMGameTransaction -Player $Player -Action {',
        '                Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1',
        '            }',
        '            if ($Result.Status -eq "SUCCESS") { $ResponseText = "SUCCESS: $Arg1 upgraded to Level $($Result.NewLevel). Gold left: $($Result.RemainingGold)" }',
        '            else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        default {',
        '            $ResponseText = "Unknown command. Use /start or /build."',
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
        Write-Host "  [OK] Game Router Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Router Module: $_"
    }

    Write-Host "[CMD_108] Running Integration Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_GameRouter -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $TestChatId = "TG_TEST_001"
        
        # Test 1: Start Command
        $Result1 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start"
        if ($Result1 -notmatch "Welcome to NASRIUM") { throw "Test 1 Failed: /start command failed." }
        
        # Test 2: Build Command
        $Result2 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/build GoldMine"
        if ($Result2 -notmatch "SUCCESS: GoldMine upgraded") { throw "Test 2 Failed: /build command failed." }
        
        # Test 3: Insufficient Funds (Try building another one costing 800, player only has 200 left)
        $Result3 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/build GoldMine"
        if ($Result3 -notmatch "FAILED") { throw "Test 3 Failed: Should fail due to insufficient funds." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_108] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_108_001"
            task = "Telegram Game Command Router"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_109"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_108_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_108 GAME ROUTER COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_108_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_108" -Action { Build-GameRouter }
} else {
    Build-GameRouter
}
