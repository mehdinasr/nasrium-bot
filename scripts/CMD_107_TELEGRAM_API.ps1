# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_107
# File ID   : CMD_107_001
# Module    : Infrastructure
# Component : Telegram API Integration Foundation
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-TelegramAPI {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TELEGRAM API FOUNDATION BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_107" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ConfigDir = "$Root\Core\Config"
    $ModuleDir = "$Root\Core\Modules\Infrastructure"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # Step 1: Generate Telegram Configuration
    Write-Host "[CMD_107] Generating NSM_TelegramConfig.json..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_TelegramConfig.json"
    
    $ConfigLines = @(
        '{',
        '  "bot_token": "YOUR_TELEGRAM_BOT_TOKEN_HERE",',
        '  "api_base_url": "https://api.telegram.org/bot"',
        '}'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Telegram Config Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Telegram Config: $_"
    }

    # Step 2: Build Telegram API Module
    Write-Host "[CMD_107] Building NSM_TelegramAPI.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $ModuleDir "NSM_TelegramAPI.psm1"
    
    $ModuleLines = @(
        'function Send-NSMTelegramMessage {',
        '    param([string]$ChatId, [string]$Text)',
        '    ',
        '    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TelegramConfig.json"',
        '    if (!(Test-Path $ConfigPath)) { throw "Telegram config missing." }',
        '    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json',
        '    ',
        '    if ($Config.bot_token -eq "YOUR_TELEGRAM_BOT_TOKEN_HERE") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BotTokenNotConfigured" }',
        '    }',
        '    ',
        '    $Url = "$($Config.api_base_url)$($Config.bot_token)/sendMessage"',
        '    $Body = @{ chat_id = $ChatId; text = $Text }',
        '    ',
        '    try {',
        '        $Response = Invoke-RestMethod -Uri $Url -Method Post -Body $Body -ErrorAction Stop',
        '        return [PSCustomObject]@{ Status = "SUCCESS"; Response = $Response }',
        '    } catch {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Send-NSMTelegramMessage'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Telegram API Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Telegram API Module: $_"
    }

    # Step 3: Validation Test (Safe Mode - No real token)
    Write-Host "[CMD_107] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_TelegramAPI -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        # Test 1: Reject unconfigured token
        $Result = Send-NSMTelegramMessage -ChatId "123456" -Text "Test"
        if ($Result.Reason -ne "BotTokenNotConfigured") { throw "Test 1 Failed: Should reject default token." }
        
        Write-Host "  [OK] Validation Tests Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # Step 4: Registry
    Write-Host "[CMD_107] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_107_001"
            task = "Telegram API Integration Foundation"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_108"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_107_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_107 TELEGRAM API COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_107_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_107" -Action { Build-TelegramAPI }
} else {
    Build-TelegramAPI
}
