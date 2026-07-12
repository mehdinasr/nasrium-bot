# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_110
# File ID   : CMD_110_001
# Module    : Web3
# Component : TON Blockchain Integration Foundation
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-TonIntegration {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TON BLOCKCHAIN INTEGRATION BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_110" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ConfigDir = "$Root\Core\Config"
    $ModuleDir = "$Root\Core\Modules\Web3"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # Step 1: Generate TON Configuration
    Write-Host "[CMD_110] Generating NSM_TonConfig.json..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_TonConfig.json"
    
    $ConfigLines = @(
        '{',
        '  "network": "testnet",',
        '  "api_key": "YOUR_TONCENTER_API_KEY_HERE",',
        '  "api_base_url": "https://testnet.toncenter.com/api/v2/"',
        '}'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] TON Config Created." -ForegroundColor Green
    } catch {
        throw "Failed to create TON Config: $_"
    }

    # Step 2: Build TON API Module
    Write-Host "[CMD_110] Building NSM_TonApi.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $ModuleDir "NSM_TonApi.psm1"
    
    $ModuleLines = @(
        'function Get-NSMTonWalletBalance {',
        '    param([string]$WalletAddress)',
        '    ',
        '    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TonConfig.json"',
        '    if (!(Test-Path $ConfigPath)) { throw "TON config missing." }',
        '    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json',
        '    ',
        '    if ($Config.api_key -eq "YOUR_TONCENTER_API_KEY_HERE") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TonApiKeyNotConfigured" }',
        '    }',
        '    ',
        '    $Url = "$($Config.api_base_url)getAddressBalance"',
        '    $Query = @{ address = $WalletAddress; api_key = $Config.api_key }',
        '    ',
        '    try {',
        '        $Response = Invoke-RestMethod -Uri $Url -Method Get -Body $Query -ErrorAction Stop',
        '        if ($Response.ok) {',
        '            $BalanceNanoTon = $Response.result',
        '            $BalanceTon = [math]::Round($BalanceNanoTon / 1000000000, 9)',
        '            return [PSCustomObject]@{ Status = "SUCCESS"; Balance = $BalanceTon; Address = $WalletAddress }',
        '        } else {',
        '            return [PSCustomObject]@{ Status = "FAILED"; Reason = "API returned error" }',
        '        }',
        '    } catch {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Get-NSMTonWalletBalance'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] TON API Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create TON API Module: $_"
    }

    # Step 3: Validation Test (Safe Mode)
    Write-Host "[CMD_110] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_TonApi -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $Result = Get-NSMTonWalletBalance -WalletAddress "EQATestAddress"
        if ($Result.Reason -ne "TonApiKeyNotConfigured") { throw "Test 1 Failed: Should reject default API key." }
        
        Write-Host "  [OK] Validation Tests Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # Step 4: Registry
    Write-Host "[CMD_110] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_110_001"
            task = "TON Blockchain Integration Foundation"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_111"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_110_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_110 TON INTEGRATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_110_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_110" -Action { Build-TonIntegration }
} else {
    Build-TonIntegration
}
