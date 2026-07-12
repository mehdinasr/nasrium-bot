# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_122
# File ID   : CMD_122_001
# Module    : Game
# Component : In-App Shop Engine (Shields & NFTs)
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ShopEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM IN-APP SHOP ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_122" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"

    # 1. Patch Game Domain (Add Shields & NFTs properties)
    Write-Host "[CMD_122] Patching NSM_GameDomain.psm1 for Shop Items..." -ForegroundColor Cyan
    $DomainFile = Join-Path $GameDir "NSM_GameDomain.psm1"
    $DomainLines = @(
        'function New-NSMPlayer {',
        '    param([string]$Username)',
        '    return [PSCustomObject]@{',
        '        Id = [guid]::NewGuid().ToString()',
        '        Username = $Username',
        '        Level = 1',
        '        Resources = New-NSMResource',
        '        Buildings = @()',
        '        WalletAddress = ""',
        '        Shields = 0',
        '        Nfts = @()',
        '        CreatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
        '    }',
        '}',
        '',
        'function New-NSMResource {',
        '    return [PSCustomObject]@{',
        '        Gold = 500',
        '        NSM_Soft = 0',
        '        NSM_Withdraw = 0',
        '        Energy = 100',
        '    }',
        '}',
        '',
        'function New-NSMBuilding {',
        '    param([string]$Type, [int]$Level = 1)',
        '    return [PSCustomObject]@{',
        '        Type = $Type',
        '        Level = $Level',
        '        Upgrading = $false',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding'
    )
    try {
        $ModuleContent = $DomainLines -join "`r`n"
        [System.IO.File]::WriteAllText($DomainFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Domain Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch Domain: $_"
    }

    # 2. Patch Game Config (Add Shop Items)
    Write-Host "[CMD_122] Updating NSM_GameConfig.json with Shop Items..." -ForegroundColor Cyan
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
        '  },',
        '  "shop": {',
        '    "shield_1h": { "cost_nsm_soft": 50, "duration_hours": 1 },',
        '    "shield_24h": { "cost_nsm_soft": 500, "duration_hours": 24 },',
        '    "nft_common": { "cost_nsm_withdraw": 100 },',
        '    "nft_rare": { "cost_nsm_withdraw": 500 }',
        '  }',
        '}'
    ) -join "`r`n"
    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Build Shop Engine Module
    Write-Host "[CMD_122] Building NSM_ShopEngine.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $GameDir "NSM_ShopEngine.psm1"
    $ModuleLines = @(
        'function New-NSMShield {',
        '    param($Player, [string]$Sku)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    if (-not $Config.shop.$Sku) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopItem" }',
        '    }',
        '    ',
        '    $Item = $Config.shop.$Sku',
        '    $Cost = $Item.cost_nsm_soft',
        '    ',
        '    if ($Player.Resources.NSM_Soft -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }',
        '    }',
        '    ',
        '    # Deduct Cost & Apply Shield',
        '    $Player.Resources.NSM_Soft -= $Cost',
        '    $Player.Shields += 1',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Item = $Sku; DurationHours = $Item.duration_hours; TotalShields = $Player.Shields }',
        '}',
        '',
        'function New-NSMNft {',
        '    param($Player, [string]$Sku)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    if (-not $Config.shop.$Sku) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopItem" }',
        '    }',
        '    ',
        '    $Item = $Config.shop.$Sku',
        '    $Cost = $Item.cost_nsm_withdraw',
        '    ',
        '    if ($Player.Resources.NSM_Withdraw -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }',
        '    }',
        '    ',
        '    if ($Player.WalletAddress -eq "") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotLinked" }',
        '    }',
        '    ',
        '    # Deduct Cost & Mint NFT record',
        '    $Player.Resources.NSM_Withdraw -= $Cost',
        '    ',
        '    $NftId = [guid]::NewGuid().ToString()',
        '    $Player.Nfts += [PSCustomObject]@{ Id = $NftId; Type = $Sku; Status = "PendingTransfer" }',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Item = $Sku; NftId = $NftId; DestinationWallet = $Player.WalletAddress }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMShield, New-NSMNft'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Shop Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Shop Module: $_"
    }

    # 4. Integration Test
    Write-Host "[CMD_122] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        $WalletPath = "$Root\Core\Modules\Web3\NSM_WalletManager.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_WalletManager, NSM_ShopEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $WalletPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "ShopTest"
        
        # Test 1: Buy Shield without Soft Token (Should fail)
        $Result1 = New-NSMShield -Player $TestPlayer -Sku "shield_1h"
        if ($Result1.Reason -ne "InsufficientSoftToken") { throw "Test 1 Failed: Should require soft token." }
        
        # Grant Soft Token and Buy Shield
        Grant-NSMToken -Player $TestPlayer -Amount 1000 -TokenType NSM_Soft | Out-Null
        $Result2 = New-NSMShield -Player $TestPlayer -Sku "shield_1h"
        if ($Result2.Status -ne "SUCCESS" -or $TestPlayer.Shields -ne 1) { throw "Test 2 Failed: Shield not applied." }
        if ($TestPlayer.Resources.NSM_Soft -ne 950) { throw "Test 2 Failed: Soft token not deducted." }
        
        # Test 3: Buy NFT without linked wallet (Should fail)
        Grant-NSMToken -Player $TestPlayer -Amount 1000 -TokenType NSM_Withdraw | Out-Null
        $Result3 = New-NSMNft -Player $TestPlayer -Sku "nft_common"
        if ($Result3.Reason -ne "WalletNotLinked") { throw "Test 3 Failed: Should require wallet." }
        
        # Test 4: Buy NFT successfully
        Register-NSMWallet -Player $TestPlayer -WalletAddress "EQNftWallet" | Out-Null
        $Result4 = New-NSMNft -Player $TestPlayer -Sku "nft_common"
        if ($Result4.Status -ne "SUCCESS") { throw "Test 4 Failed: NFT purchase should succeed." }
        if ($TestPlayer.Nfts.Count -ne 1) { throw "Test 4 Failed: NFT not added to inventory." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 5. Registry
    Write-Host "[CMD_122] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_122_001"
            task = "In-App Shop Engine (Shields & NFTs)"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_123"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_122_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_122 SHOP ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_122_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_122" -Action { Build-ShopEngine }
} else {
    Build-ShopEngine
}
