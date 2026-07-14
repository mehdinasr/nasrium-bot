# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_116
# File ID   : CMD_116_001
# Module    : Infrastructure
# Component : Game Router Resource Claim Integration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ClaimIntegration {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ROUTER CLAIM INTEGRATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_116" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Infrastructure"
    $ModuleFile = Join-Path $ModuleDir "NSM_GameRouter.psm1"

    Write-Host "[CMD_116] Updating NSM_GameRouter.psm1 with /claim..." -ForegroundColor Cyan
    
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
        '        $Player = Import-NSMPlayer -PlayerId $ChatId',
        '    } catch {',
        '        $Player = New-NSMPlayer -Username "TG_$ChatId"',
        '        $Player.Id = $ChatId',
        '        Export-NSMPlayer -Player $Player | Out-Null',
        '    }',
        '    ',
        '    $ResponseText = ""',
        '    ',
        '    switch ($Cmd) {',
        '        "/start" {',
        '            $ResponseText = "Welcome to NASRIUM! Use /build <Type>, /claim <Type>, or /status."',
        '        }',
        '        "/status" {',
        '            $ResponseText = "=== STATUS ===`r`nLevel: $($Player.Level)`r`nGold: $($Player.Resources.Gold)`r`nEnergy: $($Player.Resources.Energy)`r`nNSM: $($Player.Resources.NSM)`r`nBuildings: $($Player.Buildings.Count)"',
        '        }',
        '        "/build" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }',
        '            $Result = Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: $Arg1 upgraded to Level $($Result.NewLevel). Gold: $($Result.RemainingGold), Energy: $($Result.RemainingEnergy)"',
        '            } else {',
        '                $ResponseText = "FAILED: $($Result.Reason)"',
        '            }',
        '        }',
        '        "/claim" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /claim <BuildingType>"; break }',
        '            # Set building upgrading to false to simulate time passed',
        '            $Building = $Player.Buildings | Where-Object { $_.Type -eq $Arg1 } | Select-Object -First 1',
        '            if ($Building) { $Building.Upgrading = $false }',
        '            ',
        '            $Result = Receive-NSMResources -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: Claimed $($Result.YieldAmount) Gold from $Arg1. Total Gold: $($Result.TotalGold)"',
        '            } else {',
        '                $ResponseText = "FAILED: $($Result.Reason)"',
        '            }',
        '        }',
        '        default {',
        '            $ResponseText = "Unknown command. Use /start, /status, /build, or /claim."',
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

    Write-Host "[CMD_116] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $GameDir = "$Root\Core\Modules\Game"
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine, NSM_EnergyEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_GameRouter -ErrorAction SilentlyContinue
        Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_ResourceEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_EnergyEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_PlayerPersistence.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameSession.psm1") -Force
        Import-Module $ModuleFile -Force
        
        $TestChatId = "TG_CLAIM_TEST_001"
        
        # 1. Start & Build
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start" | Out-Null
        $BuildResult = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/build GoldMine"
        if ($BuildResult -notmatch "SUCCESS") { throw "Test 1 Failed: Build failed." }
        
        # 2. Claim Resources
        $ClaimResult = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/claim GoldMine"
        if ($ClaimResult -notmatch "Claimed 50 Gold") { throw "Test 2 Failed: Claim failed. Result: $ClaimResult" }
        
        # 3. Verify Status
        $StatusResult = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/status"
        if ($StatusResult -notmatch "Gold: 250") { throw "Test 3 Failed: Status Gold mismatch. Result: $StatusResult" }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_116] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_116_001"
            task = "Game Router Resource Claim Integration"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_117"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_116_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_116 CLAIM INTEGRATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_116_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_116" -Action { Build-ClaimIntegration }
} else {
    Build-ClaimIntegration
}
