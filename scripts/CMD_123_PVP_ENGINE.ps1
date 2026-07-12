# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_123
# File ID   : CMD_123_001
# Module    : Game
# Component : PvP Attack Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-PvpEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PVP ATTACK ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_123" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $ModuleFile = Join-Path $GameDir "NSM_PvpEngine.psm1"

    Write-Host "[CMD_123] Building NSM_PvpEngine.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Invoke-NSMPvpAttack {',
        '    param($Attacker, $Defender)',
        '    ',
        '    # 1. Check if Defender has Shields',
        '    if ($Defender.Shields -gt 0) {',
        '        $Defender.Shields -= 1',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "DefenderWasShielded"; ShieldConsumed = $true }',
        '    }',
        '    ',
        '    # 2. Calculate Loot (20% of unshielded Gold & Soft Token)',
        '    $LootGold = [math]::Floor($Defender.Resources.Gold * 0.20)',
        '    $LootSoft = [math]::Floor($Defender.Resources.NSM_Soft * 0.20)',
        '    ',
        '    if ($LootGold -eq 0 -and $LootSoft -eq 0) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "DefenderHasNoLoot" }',
        '    }',
        '    ',
        '    # 3. Transfer Resources',
        '    $Defender.Resources.Gold -= $LootGold',
        '    $Defender.Resources.NSM_Soft -= $LootSoft',
        '    ',
        '    $Attacker.Resources.Gold += $LootGold',
        '    $Attacker.Resources.NSM_Soft += $LootSoft',
        '    ',
        '    return [PSCustomObject]@{',
        '        Status = "SUCCESS"',
        '        LootGold = $LootGold',
        '        LootSoftToken = $LootSoft',
        '        AttackerTotalGold = $Attacker.Resources.Gold',
        '        DefenderTotalGold = $Defender.Resources.Gold',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-NSMPvpAttack'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] PvP Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create PvP Module: $_"
    }

    Write-Host "[CMD_123] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_PvpEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $ModuleFile -Force
        
        $Attacker = New-NSMPlayer -Username "Attacker"
        $Defender = New-NSMPlayer -Username "Defender"
        
        # Setup Defender Resources
        $Defender.Resources.Gold = 1000
        Grant-NSMToken -Player $Defender -Amount 500 -TokenType NSM_Soft | Out-Null
        
        # Test 1: Attack shielded defender
        $Defender.Shields = 1
        $Result1 = Invoke-NSMPvpAttack -Attacker $Attacker -Defender $Defender
        if ($Result1.Reason -ne "DefenderWasShielded") { throw "Test 1 Failed: Attack should be blocked by shield." }
        if ($Defender.Shields -ne 0) { throw "Test 1 Failed: Shield should be consumed." }
        
        # Test 2: Successful Attack (20% Loot)
        $Result2 = Invoke-NSMPvpAttack -Attacker $Attacker -Defender $Defender
        if ($Result2.Status -ne "SUCCESS") { throw "Test 2 Failed: Attack should succeed." }
        if ($Result2.LootGold -ne 200) { throw "Test 2 Failed: Loot gold should be 200 (20% of 1000)." }
        if ($Result2.LootSoftToken -ne 100) { throw "Test 2 Failed: Loot soft token should be 100 (20% of 500)." }
        
        # Verify balances
        if ($Defender.Resources.Gold -ne 800) { throw "Test 2 Failed: Defender gold mismatch." }
        if ($Attacker.Resources.Gold -ne 700) { throw "Test 2 Failed: Attacker gold mismatch (500 start + 200 loot)." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_123] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_123_001"
            task = "PvP Attack Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_124"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_123_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_123 PVP ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_123_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_123" -Action { Build-PvpEngine }
} else {
    Build-PvpEngine
}
