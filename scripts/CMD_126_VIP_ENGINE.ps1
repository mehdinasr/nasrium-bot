# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_126
# File ID   : CMD_126_001
# Module    : Game
# Component : VIP Subscription Engine & Monetization Layer
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-VipEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM VIP SUBSCRIPTION ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_126" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Ratify VIP Rules in Governance (Rule 35)
    Write-Host "[CMD_126] Ratifying VIP Subscription Rules in Governance..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw
    $VipRules = @"

## 13. VIP Subscription & Monetization
- Players can purchase VIP tiers using **NSM_Withdraw** or **TON**.
- VIP provides boosts to production, energy, and AI support (Pay-to-Progress, NOT Pay-to-Win).
- Tiers: Silver (5 NSM_W), Gold (20 NSM_W), Premium (50 NSM_W) per 30 days.
- This creates a massive Token Sink for NSM_Withdraw, sustaining token value.
- Revenue from TON subscriptions funds project development and ecosystem growth.
"@
    $DocContent += $VipRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch Game Config with VIP Tiers
    Write-Host "[CMD_126] Updating NSM_GameConfig.json with VIP Tiers..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ConfigContent = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    $ConfigContent | Add-Member -NotePropertyName "vip" -NotePropertyValue @{
        "silver" = @{ cost_nsm_withdraw = 5; duration_days = 30; boost_production = 1.20; energy_cap_boost = 10 };
        "gold" = @{ cost_nsm_withdraw = 20; duration_days = 30; boost_production = 1.50; energy_cap_boost = 20 };
        "premium" = @{ cost_nsm_withdraw = 50; duration_days = 30; boost_production = 2.00; energy_cap_boost = 50 }
    } -Force
    try {
        $ConfigContent | ConvertTo-Json -Depth 5 | Set-Content $ConfigFile -Encoding UTF8
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Patch Game Domain (Add VipTier & VipExpiry)
    Write-Host "[CMD_126] Patching NSM_GameDomain.psm1 for VIP..." -ForegroundColor Cyan
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
        '        ClanId = ""',
        '        VipTier = "Free"',
        '        VipExpiry = ""',
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
        'function New-NSMClan {',
        '    param([string]$Name, [string]$LeaderId)',
        '    return [PSCustomObject]@{',
        '        Id = [guid]::NewGuid().ToString()',
        '        Name = $Name',
        '        LeaderId = $LeaderId',
        '        Members = @($LeaderId)',
        '        BankGold = 0',
        '        BankSoft = 0',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding, New-NSMClan'
    )
    try {
        $ModuleContent = $DomainLines -join "`r`n"
        [System.IO.File]::WriteAllText($DomainFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Domain Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch Domain: $_"
    }

    # 4. Build VIP Engine Module
    Write-Host "[CMD_126] Building NSM_VipEngine.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $GameDir "NSM_VipEngine.psm1"
    $ModuleLines = @(
        'function New-NSMVipSubscription {',
        '    param($Player, [ValidateSet("silver", "gold", "premium")][string]$Tier)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $TierConfig = $Config.vip.$Tier',
        '    ',
        '    if (-not $TierConfig) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidVipTier" }',
        '    }',
        '    ',
        '    $Cost = $TierConfig.cost_nsm_withdraw',
        '    ',
        '    if ($Player.Resources.NSM_Withdraw -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }',
        '    }',
        '    ',
        '    # Deduct Cost',
        '    $Player.Resources.NSM_Withdraw -= $Cost',
        '    ',
        '    # Apply VIP Status',
        '    $Player.VipTier = $Tier',
        '    $Expiry = (Get-Date).AddDays($TierConfig.duration_days)',
        '    $Player.VipExpiry = $Expiry.ToString("yyyy-MM-dd HH:mm:ss")',
        '    ',
        '    return [PSCustomObject]@{',
        '        Status = "SUCCESS"',
        '        Tier = $Tier',
        '        Expiry = $Player.VipExpiry',
        '        ProductionBoost = $TierConfig.boost_production',
        '        EnergyBoost = $TierConfig.energy_cap_boost',
        '        CostPaid = $Cost',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMVipSubscription'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] VIP Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create VIP Module: $_"
    }

    # 5. Integration Test
    Write-Host "[CMD_126] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_VipEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "VipUser"
        
        # Test 1: Try to buy Premium without tokens
        $Result1 = New-NSMVipSubscription -Player $TestPlayer -Tier premium
        if ($Result1.Reason -ne "InsufficientWithdrawToken") { throw "Test 1 Failed: Should require tokens." }
        
        # Grant tokens and buy Gold VIP
        Grant-NSMToken -Player $TestPlayer -Amount 100 -TokenType NSM_Withdraw | Out-Null
        $Result2 = New-NSMVipSubscription -Player $TestPlayer -Tier gold
        if ($Result2.Status -ne "SUCCESS") { throw "Test 2 Failed: VIP purchase should succeed." }
        if ($TestPlayer.VipTier -ne "gold") { throw "Test 2 Failed: VIP tier not applied." }
        if ($TestPlayer.Resources.NSM_Withdraw -ne 80) { throw "Test 2 Failed: 20 NSM_Withdraw not deducted." }
        if ($Result2.ProductionBoost -ne 1.5) { throw "Test 2 Failed: Boost mismatch." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 6. Registry
    Write-Host "[CMD_126] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_126_001"
            task = "VIP Subscription Engine & Monetization Layer"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_127"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_126_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_126 VIP ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_126_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_126" -Action { Build-VipEngine }
} else {
    Build-VipEngine
}
