# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_129
# File ID   : CMD_129_001
# Module    : Game
# Component : TON Token Sale & Instant Build Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-InstantBuildAndTonSale {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM INSTANT BUILD & TON SALE ENGINE" -ForegroundColor Cyan
    Write-Host "Command   : CMD_129" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $InfraDir = "$Root\Core\Modules\Infrastructure"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Ratify Rules in Governance
    Write-Host "[CMD_129] Ratifying TON Sale & Instant Build Rules..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw
    $NewRules = @"

## 15. TON Token Sale & Instant Upgrades
- Players can purchase **NSM_Withdraw** tokens directly using **TON** cryptocurrency.
- NSM_Withdraw can be spent on **Instant Upgrades** to complete building times instantly.
- Cost of Instant Upgrade: 10 NSM_Withdraw per building.
- This creates a direct revenue stream for the project and a high-value sink for the token.
"@
    $DocContent += $NewRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch Game Config with Instant Build Cost
    Write-Host "[CMD_129] Updating NSM_GameConfig.json..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ConfigContent = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    $ConfigContent.economy | Add-Member -NotePropertyName "instant_build_cost_nsm_withdraw" -NotePropertyValue 10 -Force
    try {
        $ConfigContent | ConvertTo-Json -Depth 5 | Set-Content $ConfigFile -Encoding UTF8
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Build Instant Build Module
    Write-Host "[CMD_129] Building NSM_InstantBuildEngine.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $GameDir "NSM_InstantBuildEngine.psm1"
    $ModuleLines = @(
        'function Complete-NSMInstantUpgrade {',
        '    param($Player, [string]$BuildingType)',
        '    ',
        '    $Building = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType -and $_.Upgrading -eq $true } | Select-Object -First 1',
        '    if (-not $Building) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BuildingNotFoundOrNotUpgrading" }',
        '    }',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $Cost = $Config.economy.instant_build_cost_nsm_withdraw',
        '    ',
        '    if ($Player.Resources.NSM_Withdraw -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }',
        '    }',
        '    ',
        '    # Deduct Cost & Complete Upgrade',
        '    $Player.Resources.NSM_Withdraw -= $Cost',
        '    $Building.Upgrading = $false',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; CostPaid = $Cost }',
        '}',
        '',
        'Export-ModuleMember -Function Complete-NSMInstantUpgrade'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Instant Build Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Module: $_"
    }

    # 4. Update Game Router with /speedup and /buyton
    Write-Host "[CMD_129] Updating NSM_GameRouter.psm1..." -ForegroundColor Cyan
    $RouterFile = Join-Path $InfraDir "NSM_GameRouter.psm1"
    $RouterContent = Get-Content $RouterFile -Raw
    
    # Add /speedup and /buyton commands before 'default'
    $RouterContent = $RouterContent -replace "        `"/ask`" {", (
        "        `"/speedup`" {`r`n" +
        "            if (-not `$Arg1) { `$ResponseText = `"Usage: /speedup <BuildingType>`"; break }`r`n" +
        "            `$Result = Complete-NSMInstantUpgrade -Player `$Player -BuildingType `$Arg1`r`n" +
        "            if (`$Result.Status -eq `"SUCCESS`") {`r`n" +
        "                Export-NSMPlayer -Player `$Player | Out-Null`r`n" +
        "                `$ResponseText = `"SUCCESS: `$Arg1 completed instantly! (`$(`$Result.CostPaid) NSM_W spent)`"`r`n" +
        "            } else { `$ResponseText = `"FAILED: `$(`$Result.Reason)`" }`r`n" +
        "        }`r`n" +
        "        `"/buyton`" {`r`n" +
        "            # MOCK: Simulates buying NSM_Withdraw with TON`r`n" +
        "            # In production, this triggers TON Payment Gateway`r`n" +
        "            Grant-NSMToken -Player `$Player -Amount 100 -TokenType NSM_Withdraw | Out-Null`r`n" +
        "            Export-NSMPlayer -Player `$Player | Out-Null`r`n" +
        "            `$ResponseText = `"SUCCESS: +100 NSM_Withdraw added (Mock TON Payment).`"`r`n" +
        "        }`r`n" +
        "        `"/ask`" {"
    )

    try {
        [System.IO.File]::WriteAllText($RouterFile, $RouterContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Router Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Router: $_"
    }

    # 5. Integration Test
    Write-Host "[CMD_129] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $Web3Dir = "$Root\Core\Modules\Web3"
        $AiDir = "$Root\Core\Modules\AI"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_GameEngine, NSM_ResourceEngine, NSM_EnergyEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_TokenEngine, NSM_WithdrawalEngine, NSM_ShopEngine, NSM_VipEngine, NSM_ClanEngine, NSM_PvpEngine, NSM_SupportAI, NSM_WalletManager, NSM_InstantBuildEngine, NSM_GameRouter -ErrorAction SilentlyContinue
        
        Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_ResourceEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_EnergyEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_PlayerPersistence.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameSession.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_TokenEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_WithdrawalEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_ShopEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_VipEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_ClanEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_PvpEngine.psm1") -Force
        Import-Module (Join-Path $AiDir "NSM_SupportAI.psm1") -Force
        Import-Module (Join-Path $Web3Dir "NSM_WalletManager.psm1") -Force
        Import-Module $ModuleFile -Force
        Import-Module $RouterFile -Force
        
        $TestChatId = "TG_INSTANT_TEST_001"
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start" | Out-Null
        
        # Test 1: Buy TON (Mock) to get Withdraw tokens
        $Result1 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/buyton"
        if ($Result1 -notmatch "SUCCESS") { throw "Test 1 Failed: TON purchase mock failed." }
        
        # Setup: Build something that takes time
        $Player = Import-NSMPlayer -PlayerId $TestChatId
        $Player.Resources.Gold = 100000
        $Player.Resources.Energy = 1000
        Export-NSMPlayer -Player $Player | Out-Null
        
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/build GoldMine" | Out-Null
        
        # Test 2: Speedup without enough tokens (Should fail if they spent them, but we just bought 100, so it should pass)
        $Result2 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/speedup GoldMine"
        if ($Result2 -notmatch "SUCCESS") { throw "Test 2 Failed: Instant upgrade failed. Result: $Result2" }
        
        # Verify building is no longer upgrading
        $Player = Import-NSMPlayer -PlayerId $TestChatId
        $Building = $Player.Buildings | Where-Object { $_.Type -eq "GoldMine" } | Select-Object -First 1
        if ($Building.Upgrading -ne $false) { throw "Test 2 Failed: Building still marked as upgrading." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 6. Registry
    Write-Host "[CMD_129] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_129_001"
            task = "TON Token Sale & Instant Build Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_130"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_129_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_129 INSTANT BUILD & TON SALE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_129_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_129" -Action { Build-InstantBuildAndTonSale }
} else {
    Build-InstantBuildAndTonSale
}
