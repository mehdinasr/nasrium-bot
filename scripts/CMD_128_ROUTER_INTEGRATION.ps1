# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_128
# File ID   : CMD_128_001
# Module    : Infrastructure
# Component : Game Router Full Integration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Integrate-FullRouter {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ROUTER FULL INTEGRATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_128" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $InfraDir = "$Root\Core\Modules\Infrastructure"
    $ModuleFile = Join-Path $InfraDir "NSM_GameRouter.psm1"

    Write-Host "[CMD_128] Updating NSM_GameRouter.psm1 with all Modules..." -ForegroundColor Cyan
    
    $RouterLines = @(
        'function Invoke-NSMGameCommand {',
        '    param([string]$ChatId, [string]$CommandText)',
        '    ',
        '    $Parts = $CommandText -split " "', 
        '    $Cmd = $Parts[0].ToLower()',
        '    $Arg1 = if ($Parts.Length -gt 1) { $Parts[1] } else { "" }',
        '    $Arg2 = if ($Parts.Length -gt 2) { $Parts[2] } else { "" }',
        '    $Arg3 = if ($Parts.Length -gt 3) { $Parts[3] } else { "" }',
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
        '            $ResponseText = "Welcome to NASRIUM! Use /build, /claim, /status, /shop, /vip, /clan, or /ask."',
        '        }',
        '        "/status" {',
        '            $ResponseText = "=== STATUS ===`r`nLevel: $($Player.Level)`r`nVIP: $($Player.VipTier)`r`nGold: $($Player.Resources.Gold)`r`nEnergy: $($Player.Resources.Energy)`r`nSoft: $($Player.Resources.NSM_Soft)`r`nWithdraw: $($Player.Resources.NSM_Withdraw)"',
        '        }',
        '        "/build" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }',
        '            $Result = Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: $Arg1 upgraded. Gold: $($Result.RemainingGold)"',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/claim" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /claim <BuildingType>"; break }',
        '            $Building = $Player.Buildings | Where-Object { $_.Type -eq $Arg1 } | Select-Object -First 1',
        '            if ($Building) { $Building.Upgrading = $false }',
        '            $Result = Receive-NSMResources -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: Claimed $($Result.YieldAmount) Gold."',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/vip" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /vip <silver|gold|premium>"; break }',
        '            $Result = New-NSMVipSubscription -Player $Player -Tier $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: VIP $($Result.Tier) activated until $($Result.Expiry)"',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/clan" {',
        '            if ($Arg1 -eq "create" -and $Arg2) {',
        '                $Result = New-NSMPlayerClan -Player $Player -ClanName $Arg2',
        '                if ($Result.Status -eq "SUCCESS") {',
        '                    Export-NSMPlayer -Player $Player | Out-Null',
        '                    $ResponseText = "SUCCESS: Clan $($Result.ClanName) created!"',
        '                } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '            }',
        '            elseif ($Arg1 -eq "donate" -and $Arg2 -and $Arg3) {',
        '                $Amount = [decimal]$Arg3',
        '                $Result = Submit-NSMClanDonation -Player $Player -Amount $Amount -Type $Arg2',
        '                if ($Result.Status -eq "SUCCESS") {',
        '                    Export-NSMPlayer -Player $Player | Out-Null',
        '                    $ResponseText = "SUCCESS: Donated $($Result.Amount) $($Result.Type)."',
        '                } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '            }',
        '            else { $ResponseText = "Usage: /clan create <name> | /clan donate <Gold|NSM_Soft> <amount>" }',
        '        }',
        '        "/shop" {',
        '            if (-not $Arg1 -or -not $Arg2) { $ResponseText = "Usage: /shop <shield|nft> <sku>"; break }',
        '            if ($Arg1 -eq "shield") {',
        '                $Result = New-NSMShield -Player $Player -Sku $Arg2',
        '            } elseif ($Arg1 -eq "nft") {',
        '                $Result = New-NSMNft -Player $Player -Sku $Arg2',
        '            } else { $Result = [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopCategory" } }',
        '            ',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: Purchased $Arg1 $Arg2."',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/ask" {',
        '            if (-not $Arg1 -or -not $Arg2) { $ResponseText = "Usage: /ask <faq|simple|advanced> <question>"; break }',
        '            $Tier = $Arg1',
        '            $Query = $CommandText.Substring($CommandText.IndexOf($Arg2))',
        '            $Result = Request-NSMAiSupport -Player $Player -Query $Query -Tier $Tier',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "$($Result.Response) (Cost: $($Result.TokensSpent) NSM_Soft)"',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        default { $ResponseText = "Unknown command. Use /start for help." }',
        '    }',
        '    return $ResponseText',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-NSMGameCommand'
    )

    try {
        $ModuleContent = $RouterLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Router Fully Integrated." -ForegroundColor Green
    } catch {
        throw "Failed to update Router: $_"
    }

    Write-Host "[CMD_128] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $GameDir = "$Root\Core\Modules\Game"
        $AiDir = "$Root\Core\Modules\AI"
        $Web3Dir = "$Root\Core\Modules\Web3"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_GameEngine, NSM_ResourceEngine, NSM_EnergyEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_TokenEngine, NSM_WithdrawalEngine, NSM_ShopEngine, NSM_VipEngine, NSM_ClanEngine, NSM_PvpEngine, NSM_SupportAI, NSM_WalletManager, NSM_GameRouter -ErrorAction SilentlyContinue
        
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
        
        $TestChatId = "TG_FULL_TEST_001"
        
        # Setup
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start" | Out-Null
        
        # Test 1: Buy Shield (Need Soft token first)
        $Player = Import-NSMPlayer -PlayerId $TestChatId
        Grant-NSMToken -Player $Player -Amount 500 -TokenType NSM_Soft | Out-Null
        Export-NSMPlayer -Player $Player | Out-Null
        
        $Result1 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/shop shield shield_1h"
        if ($Result1 -notmatch "SUCCESS") { throw "Test 1 Failed: Shield purchase failed. Result: $Result1" }
        
        # Test 2: Buy VIP (Need Withdraw token)
        $Player = Import-NSMPlayer -PlayerId $TestChatId
        Grant-NSMToken -Player $Player -Amount 100 -TokenType NSM_Withdraw | Out-Null
        Register-NSMWallet -Player $Player -WalletAddress "EQTestFull" | Out-Null
        Export-NSMPlayer -Player $Player | Out-Null
        
        $Result2 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/vip silver"
        if ($Result2 -notmatch "SUCCESS") { throw "Test 2 Failed: VIP purchase failed. Result: $Result2" }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_128] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_128_001"
            task = "Game Router Full Integration"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_129"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_128_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_128 ROUTER INTEGRATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_128_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_128" -Action { Integrate-FullRouter }
} else {
    Integrate-FullRouter
}
