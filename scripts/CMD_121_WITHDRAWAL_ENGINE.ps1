# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_121
# File ID   : CMD_121_001
# Module    : Game
# Component : Token Withdrawal Engine & Withdrawal Rate Patch
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-WithdrawalEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TOKEN WITHDRAWAL ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_121" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Patch Governance Document (Rule 35)
    Write-Host "[CMD_121] Updating Governance Document with new Withdrawal Rates..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocLines = @(
        '# NASRIUM GAME ECONOMICS & MECHANICS CONSTITUTION',
        '# Version: 1.1.0',
        '# Status: Ratified Source of Truth',
        '',
        '## 1. Token Supply',
        '- **Total Supply**: 100,000,000,000 NSM (100 Billion)',
        '- Distribution happens across seasons and phases.',
        '',
        '## 2. Dual Token Economy',
        '1. **NSM_Withdraw (Liquid)**: Real token, withdrawable to TON wallet.',
        '2. **NSM_Soft (In-App)**: Non-withdrawable, used for upgrades and in-app shop.',
        '',
        '## 3. Wallet Activation',
        '- Wallet linking and withdrawal features unlock at **Town Hall Level 3**.',
        '',
        '## 4. Town Hall Upgrade Rule',
        '- A Town Hall can only be upgraded if at least **80%** of other buildings are at the maximum available level.',
        '',
        '## 5. Withdrawal Percentages (By Town Hall Level)',
        '- TH3: 5.0%',
        '- TH4: 10.0%',
        '- TH5: 15.0%',
        '- TH6: 20.0%',
        '- TH7: 25.0%',
        '- TH8: 30.0%',
        '- TH9: 35.0%',
        '',
        '## 6. Soft Token Usage',
        '- Can be converted to Shields in the shop.',
        '- Used for daily upgrade expenses.',
        '',
        '## 7. NFT Shop & Withdrawable Tokens',
        '- NFTs are sold for **NSM_Withdraw** tokens.',
        '- Purchased NFTs can be transferred to the player linked TON wallet.',
        '',
        '## 8. PvP & Attack Mechanics',
        '- Players/Clans can attack other tribes.',
        '- Attacked tribe loses up to **20%** of unshielded Soft Tokens and Gold.',
        '',
        '## 9. Daily Missions',
        '- Daily missions yield **NSM_Soft** tokens only (Non-withdrawable).',
        '',
        '## 10. Social & Clan Features',
        '- Clan creation, donations, and in-network chat features are core mechanics.'
    )
    try {
        $DocContent = $DocLines -join "`r`n"
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch Game Config
    Write-Host "[CMD_121] Updating NSM_GameConfig.json with new Withdrawal Rates..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ConfigLines = @(
        '{',
        '  "buildings": {',
        '    "TownHall": {',
        '      "levels": {',
        '        "1": { "cost_gold": 0, "build_time_seconds": 0, "yield_gold_per_cycle": 0, "energy_cost_to_build": 0 },',
        '        "2": { "cost_gold": 1000, "build_time_seconds": 60, "yield_gold_per_cycle": 0, "energy_cost_to_build": 20 },',
        '        "3": { "cost_gold": 5000, "build_time_seconds": 300, "yield_gold_per_cycle": 0, "energy_cost_to_build": 50 }',
        '      }',
        '    },',
        '    "GoldMine": {',
        '      "levels": {',
        '        "1": { "cost_gold": 300, "build_time_seconds": 10, "yield_gold_per_cycle": 50, "energy_cost_to_build": 10 },',
        '        "2": { "cost_gold": 800, "build_time_seconds": 30, "yield_gold_per_cycle": 150, "energy_cost_to_build": 20 }',
        '      }',
        '    }',
        '  },',
        '  "economy": {',
        '    "initial_gold": 500,',
        '    "initial_nsm_soft": 0,',
        '    "initial_nsm_withdraw": 0,',
        '    "initial_energy": 100,',
        '    "energy_regenerate_rate": 1,',
        '    "withdraw_rates": {',
        '      "3": 5.0,',
        '      "4": 10.0,',
        '      "5": 15.0,',
        '      "6": 20.0,',
        '      "7": 25.0,',
        '      "8": 30.0,',
        '      "9": 35.0',
        '    }',
        '  }',
        '}'
    ) -join "`r`n"
    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Build Withdrawal Engine
    Write-Host "[CMD_121] Building NSM_WithdrawalEngine.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $GameDir "NSM_WithdrawalEngine.psm1"
    $ModuleLines = @(
        'function Request-NSMWithdrawal {',
        '    param($Player)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    ',
        '    # 1. Check Town Hall Level >= 3',
        '    $TownHall = $Player.Buildings | Where-Object { $_.Type -eq "TownHall" } | Select-Object -First 1',
        '    if (-not $TownHall -or $TownHall.Level -lt 3) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotUnlockedRequiresTH3" }',
        '    }',
        '    ',
        '    # 2. Check Wallet Linked',
        '    if ($Player.WalletAddress -eq "") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotLinked" }',
        '    }',
        '    ',
        '    # 3. Check Balance',
        '    if ($Player.Resources.NSM_Withdraw -le 0) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawBalance" }',
        '    }',
        '    ',
        '    # 4. Calculate Rate based on TH Level',
        '    $ThLevelStr = $TownHall.Level.ToString()',
        '    if (-not $Config.economy.withdraw_rates.$ThLevelStr) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WithdrawRateNotDefined" }',
        '    }',
        '    $Rate = $Config.economy.withdraw_rates.$ThLevelStr',
        '    ',
        '    # 5. Calculate Amounts',
        '    $MaxWithdrawable = $Player.Resources.NSM_Withdraw * ($Rate / 100)',
        '    $ActualWithdraw = [math]::Floor($MaxWithdrawable)',
        '    ',
        '    if ($ActualWithdraw -le 0) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WithdrawAmountTooLow" }',
        '    }',
        '    ',
        '    # 6. Deduct Balance',
        '    $Player.Resources.NSM_Withdraw -= $ActualWithdraw',
        '    ',
        '    return [PSCustomObject]@{',
        '        Status = "SUCCESS"',
        '        WithdrawAmount = $ActualWithdraw',
        '        FeePercentage = $Rate',
        '        DestinationWallet = $Player.WalletAddress',
        '        RemainingBalance = $Player.Resources.NSM_Withdraw',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Request-NSMWithdrawal'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Withdrawal Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Withdrawal Module: $_"
    }

    # 4. Integration Tests
    Write-Host "[CMD_121] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        $EnginePath = "$GameDir\NSM_GameEngine.psm1"
        $EnergyPath = "$GameDir\NSM_EnergyEngine.psm1"
        $WalletPath = "$Root\Core\Modules\Web3\NSM_WalletManager.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_GameEngine, NSM_EnergyEngine, NSM_WalletManager, NSM_WithdrawalEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $EnergyPath -Force
        Import-Module $EnginePath -Force
        Import-Module $WalletPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "WithdrawTester"
        $TestPlayer.Resources.Gold = 100000
        $TestPlayer.Resources.Energy = 1000
        
        # Test 1: Attempt withdraw with TH 1 (Should fail)
        $Result1 = Request-NSMWithdrawal -Player $TestPlayer
        if ($Result1.Reason -ne "WalletNotUnlockedRequiresTH3") { throw "Test 1 Failed: Should require TH3." }
        
        # Setup: Upgrade to TH2
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall" | Out-Null
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine" | Out-Null
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall" | Out-Null
        
        # Test 2: Attempt withdraw with TH2 (Should fail)
        $Result2 = Request-NSMWithdrawal -Player $TestPlayer
        if ($Result2.Reason -ne "WalletNotUnlockedRequiresTH3") { throw "Test 2 Failed: Should require TH3." }
        
        # Setup: Upgrade to TH3
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine" | Out-Null
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "TownHall" | Out-Null
        
        # Test 3: Attempt withdraw without linked wallet
        $Result3 = Request-NSMWithdrawal -Player $TestPlayer
        if ($Result3.Reason -ne "WalletNotLinked") { throw "Test 3 Failed: Should require linked wallet." }
        
        # Setup: Link Wallet & Grant Tokens
        Register-NSMWallet -Player $TestPlayer -WalletAddress "EQTestWallet123" | Out-Null
        Grant-NSMToken -Player $TestPlayer -Amount 1000 -TokenType NSM_Withdraw | Out-Null
        
        # Test 4: Successful Withdrawal at 5% (TH3)
        $Result4 = Request-NSMWithdrawal -Player $TestPlayer
        if ($Result4.Status -ne "SUCCESS") { throw "Test 4 Failed: Withdrawal should succeed." }
        if ($Result4.WithdrawAmount -ne 50) { throw "Test 4 Failed: 5% of 1000 should be 50. Got: $($Result4.WithdrawAmount)" }
        if ($Result4.FeePercentage -ne 5.0) { throw "Test 4 Failed: Fee percentage mismatch." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 5. Registry
    Write-Host "[CMD_121] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_121_001"
            task = "Token Withdrawal Engine & Withdrawal Rate Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_122"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_121_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_121 WITHDRAWAL ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_121_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_121" -Action { Build-WithdrawalEngine }
} else {
    Build-WithdrawalEngine
}
