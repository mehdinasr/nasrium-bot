# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_106
# File ID   : CMD_106_001
# Module    : Game
# Component : NSM Token Economy Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-TokenEconomy {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM NSM TOKEN ECONOMY ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_106" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ModuleFile = Join-Path $ModuleDir "NSM_TokenEngine.psm1"

    Write-Host "[CMD_106] Building NSM_TokenEngine.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Spend-NSMToken {',
        '    param($Player, [decimal]$Amount)',
        '    if ($Player.Resources.NSM -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientNSM" }',
        '    }',
        '    $Player.Resources.NSM -= $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Spent = $Amount; RemainingNSM = $Player.Resources.NSM }',
        '}',
        '',
        'function Reward-NSMToken {',
        '    param($Player, [decimal]$Amount)',
        '    $Player.Resources.NSM += $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Rewarded = $Amount; TotalNSM = $Player.Resources.NSM }',
        '}',
        '',
        'Export-ModuleMember -Function Spend-NSMToken, Reward-NSMToken'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Token Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Token Module: $_"
    }

    Write-Host "[CMD_106] Running Unit Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $PersistencePath = "$ModuleDir\NSM_PlayerPersistence.psm1"
        
        Remove-Module NSM_GameDomain, NSM_PlayerPersistence, NSM_TokenEngine -ErrorAction SilentlyContinue
        Import-Module $DomainPath -Force
        Import-Module $PersistencePath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "TokenUser"
        
        # Test 1: Reward NSM
        $RewardResult = Reward-NSMToken -Player $TestPlayer -Amount 10.5
        if ($RewardResult.Status -ne "SUCCESS" -or $TestPlayer.Resources.NSM -ne 10.5) { throw "Test 1 Failed: Reward unsuccessful." }
        
        # Test 2: Spend NSM
        $SpendResult = Spend-NSMToken -Player $TestPlayer -Amount 5.5
        if ($SpendResult.Status -ne "SUCCESS" -or $TestPlayer.Resources.NSM -ne 5.0) { throw "Test 2 Failed: Spend unsuccessful." }
        
        # Test 3: Insufficient NSM
        $FailResult = Spend-NSMToken -Player $TestPlayer -Amount 100
        if ($FailResult.Reason -ne "InsufficientNSM") { throw "Test 3 Failed: Should reject insufficient funds." }
        
        Write-Host "  [OK] Unit Tests Passed." -ForegroundColor Green
    } catch {
        throw "Unit Test Failed: $_"
    }

    Write-Host "[CMD_106] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_106_001"
            task = "NSM Token Economy Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_107"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_106_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_106 TOKEN ECONOMY COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_106_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_106" -Action { Build-TokenEconomy }
} else {
    Build-TokenEconomy
}
