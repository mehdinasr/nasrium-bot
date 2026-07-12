# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_127
# File ID   : CMD_127_002
# Module    : Web3
# Component : TON Real-Payment Gateway Engine (Syntax Patch)
# Version   : 1.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-TonPaymentGateway {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TON PAYMENT GATEWAY BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_127_002" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $Web3Dir = "$Root\Core\Modules\Web3"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Ratify Payment Rules in Governance (Rule 35)
    Write-Host "[CMD_127] Ratifying TON Payment Rules in Governance..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw
    $PaymentRules = @"

## 14. TON Real-Payment Integration
- Players can purchase VIP and items using real **TON** cryptocurrency.
- Payments are sent to the **Project Treasury Wallet** with a unique Memo (Player ID).
- A backend watcher (NSM_TonPaymentGateway) verifies transactions via TON API.
- Upon successful verification, digital goods (VIP, Shields) are automatically delivered.
- This creates real revenue for ecosystem development and token buyback mechanisms.
"@
    $DocContent += $PaymentRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch TON Config with Treasury Address & Pricing
    Write-Host "[CMD_127] Updating NSM_TonConfig.json with Payment Settings..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_TonConfig.json"
    $ConfigLines = @(
        '{',
        '  "network": "testnet",',
        '  "api_key": "YOUR_TONCENTER_API_KEY_HERE",',
        '  "api_base_url": "https://testnet.toncenter.com/api/v2/",',
        '  "project_treasury_wallet": "UQD...YOUR_PROJECT_WALLET_ADDRESS",',
        '  "pricing_ton": {',
        '    "silver_vip": 0.5,',
        '    "gold_vip": 1.0,',
        '    "premium_vip": 2.5',
        '  }',
        '}'
    ) -join "`r`n"
    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] TON Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Build Payment Gateway Module
    Write-Host "[CMD_127] Building NSM_TonPaymentGateway.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $Web3Dir "NSM_TonPaymentGateway.psm1"
    $ModuleLines = @(
        'function Find-NSMTonDeposit {',
        '    param([string]$PlayerId)',
        '    ',
        '    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TonConfig.json"',
        '    if (!(Test-Path $ConfigPath)) { throw "TON config missing." }',
        '    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json',
        '    ',
        '    if ($Config.api_key -eq "YOUR_TONCENTER_API_KEY_HERE") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TonApiKeyNotConfigured" }',
        '    }',
        '    ',
        '    $Wallet = $Config.project_treasury_wallet',
        '    $Url = "$($Config.api_base_url)getTransactions"',
        '    $Query = @{ address = $Wallet; api_key = $Config.api_key; limit = 10 }',
        '    ',
        '    try {',
        '        $Response = Invoke-RestMethod -Uri $Url -Method Get -Body $Query -ErrorAction Stop',
        '        if ($Response.ok) {',
        '            foreach ($tx in $Response.result) {',
        '                # Check if memo matches PlayerId and amount is valid',
        '                if ($tx.in_msg.message -eq $PlayerId -and $tx.in_msg.value -gt 0) {',
        '                    $TonAmount = $tx.in_msg.value / 1000000000',
        '                    return [PSCustomObject]@{ Status = "SUCCESS"; AmountTON = $TonAmount; TxHash = $tx.transaction_id.hash }',
        '                }',
        '            }',
        '            return [PSCustomObject]@{ Status = "PENDING"; Reason = "TransactionNotFoundYet" }',
        '        } else {',
        '            return [PSCustomObject]@{ Status = "FAILED"; Reason = "API Error" }',
        '        }',
        '    } catch {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Find-NSMTonDeposit'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Payment Gateway Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Payment Gateway: $_"
    }

    # 4. Validation Test (Safe Mode)
    Write-Host "[CMD_127] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_TonPaymentGateway -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        # Test 1: Reject unconfigured API key
        $Result1 = Find-NSMTonDeposit -PlayerId "TEST_PLAYER_001"
        if ($Result1.Reason -ne "TonApiKeyNotConfigured") { throw "Test 1 Failed: Should reject default API key." }
        
        Write-Host "  [OK] Validation Tests Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # 5. Registry
    Write-Host "[CMD_127] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_127_002"
            task = "TON Real-Payment Gateway Engine (Syntax Patch)"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_128"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_127_002_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_127 TON PAYMENT GATEWAY COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_127_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_127_002" -Action { Build-TonPaymentGateway }
} else {
    Build-TonPaymentGateway
}
