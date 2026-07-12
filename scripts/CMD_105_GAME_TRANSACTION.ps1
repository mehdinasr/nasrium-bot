# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_105
# File ID   : CMD_105_001
# Module    : Game
# Component : Game Session Transaction Manager
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-GameTransactionManager {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME TRANSACTION MANAGER BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_105" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ModuleFile = Join-Path $ModuleDir "NSM_GameSession.psm1"

    Write-Host "[CMD_105] Building NSM_GameSession.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Invoke-NSMGameTransaction {',
        '    param($Player, [scriptblock]$Action)',
        '    ',
        '    $OriginalGold = $Player.Resources.Gold',
        '    $OriginalBuildings = $Player.Buildings | ConvertTo-Json -Depth 3 | ConvertFrom-Json',
        '    ',
        '    try {',
        '        $Result = & $Action',
        '        if ($Result.Status -eq "FAILED") {',
        '            throw "Action failed: $($Result.Reason)"',
        '        }',
        '        Save-NSMPlayer -Player $Player | Out-Null',
        '        return $Result',
        '    }',
        '    catch {',
        '        # Rollback State',
        '        $Player.Resources.Gold = $OriginalGold',
        '        $Player.Buildings = $OriginalBuildings',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TransactionRolledBack"; Error = $_.Exception.Message }',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-NSMGameTransaction'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Session Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Session Module: $_"
    }

    Write-Host "[CMD_105] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $EnginePath = "$ModuleDir\NSM_GameEngine.psm1"
        $ResourcePath = "$ModuleDir\NSM_ResourceEngine.psm1"
        $PersistencePath = "$ModuleDir\NSM_PlayerPersistence.psm1"
        $SessionPath = $ModuleFile
        
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine, NSM_PlayerPersistence, NSM_GameSession -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnginePath -Force
        Import-Module $ResourcePath -Force
        Import-Module $PersistencePath -Force
        Import-Module $SessionPath -Force
        
        # Setup Test Player
        $TestPlayer = New-NSMPlayer -Username "TransactionTester"
        Save-NSMPlayer -Player $TestPlayer | Out-Null
        
        # Test 1: Successful Transaction
        $Result1 = Invoke-NSMGameTransaction -Player $TestPlayer -Action {
            Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine"
        }
        if ($Result1.Status -ne "SUCCESS") { throw "Test 1 Failed: Upgrade should succeed." }
        
        # Verify it saved to disk
        $LoadedPlayer = Load-NSMPlayer -PlayerId $TestPlayer.Id
        if ($LoadedPlayer.Buildings.Count -ne 1) { throw "Test 1 Failed: State not saved on success." }

        # Test 2: Failed Transaction (Rollback)
        $LoadedPlayer.Resources.Gold = 0 # Set gold to 0 to force failure
        Save-NSMPlayer -Player $LoadedPlayer | Out-Null
        
        $Result2 = Invoke-NSMGameTransaction -Player $LoadedPlayer -Action {
            Start-NSMBuildingUpgrade -Player $LoadedPlayer -BuildingType "TownHall"
        }
        if ($Result2.Status -ne "FAILED" -or $Result2.Reason -ne "TransactionRolledBack") { throw "Test 2 Failed: Should rollback." }
        
        # Verify state was rolled back on disk
        $FinalPlayer = Load-NSMPlayer -PlayerId $LoadedPlayer.Id
        if ($FinalPlayer.Resources.Gold -ne 0) { throw "Test 2 Failed: Gold state was not rolled back correctly." }
        if ($FinalPlayer.Buildings.Count -ne 1) { throw "Test 2 Failed: Buildings state was altered despite rollback." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_105] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_105_001"
            task = "Game Session Transaction Manager"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_106"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_105_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_105 TRANSACTION MANAGER COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_105_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_105" -Action { Build-GameTransactionManager }
} else {
    Build-GameTransactionManager
}
