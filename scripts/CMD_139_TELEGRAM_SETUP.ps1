# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_139
# File ID   : CMD_139_001
# Module    : Integration | Telegram
# Component : Telegram Bot Setup & Webhook Config
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_139_TelegramSetup {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TELEGRAM INTEGRATION CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_139" -ForegroundColor Yellow
    Write-Host "Task      : Build Bot Configurator Module" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $ConfDir   = Join-Path $RootPath "Core\Config"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $ConfDir)) { New-Item -ItemType Directory -Path $ConfDir -Force | Out-Null }

    # --- فاز ۱: ساخت ماژول NSM_TelegramBot.psm1 ---
    Write-Host "[CMD_139] Synthesizing Telegram Module..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' ماژول یکپارچگی تلگرام ناسریوم v1.0',
        ' وظیفه: تنظیمات ربات، منوی وب‌اپ و ارسال پیام',
        '#>',
        '',
        'function Set-NSMBotMenu {',
        '    param([string]$BotToken, [string]$WebAppUrl)',
        '    $apiUrl = "https://api.telegram.org/bot$BotToken/setMenuButton"',
        '    $body = @{',
        '        menu_button = @{',
        '            type = "web_app";',
        '            text = "Open NASRIUM";',
        '            web_app = @{ url = $WebAppUrl }',
        '        }',
        '    } | ConvertTo-Json -Depth 3',
        '    ',
        '    try {',
        '        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $body -ContentType "application/json"',
        '        if ($response.ok) { return $true } else { return $false }',
        '    } catch {',
        '        throw "Telegram API Error: $_"',
        '    }',
        '}',
        '',
        'function Send-NSMMessage {',
        '    param([string]$BotToken, [string]$ChatId, [string]$Text)',
        '    $apiUrl = "https://api.telegram.org/bot$BotToken/sendMessage"',
        '    $body = @{ chat_id=$ChatId; text=$Text; parse_mode="Markdown" } | ConvertTo-Json',
        '    try {',
        '        Invoke-RestMethod -Uri $apiUrl -Method Post -Body $body -ContentType "application/json" | Out-Null',
        '    } catch {',
        '        Write-Host "Failed to send message: $_" -ForegroundColor Red',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Set-NSMBotMenu, Send-NSMMessage'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_TelegramBot.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Telegram Module Generated." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت ماژول تلگرام: $_"
    }

    # --- فاز ۲: ساخت فایل تنظیمات ربات ---
    Write-Host "[CMD_139] Creating Bot Configuration File..." -ForegroundColor Cyan
    
    $BotConfig = @{
        bot_token = "YOUR_TELEGRAM_BOT_TOKEN_HERE"
        webapp_url = "https://yourdomain.com/index.html"
        admin_chat_id = "YOUR_CHAT_ID"
    } | ConvertTo-Json

    $BotConfPath = Join-Path $ConfDir "NSM_BotConfig.json"
    [System.IO.File]::WriteAllText($BotConfPath, $BotConfig, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  [OK] Bot Config Template Generated." -ForegroundColor Yellow

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_139_001"",`n`t""task"": ""Telegram Integration"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_139_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_139 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_139_COMPLETE" -ForegroundColor Green
}

Invoke-CMD_139_TelegramSetup
