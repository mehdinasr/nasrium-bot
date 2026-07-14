# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_144
# File ID   : CMD_144_001
# Module    : Integration | Telegram
# Component : Bot Activation & Menu Setup
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_144_ActivateBot {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM TELEGRAM BOT ACTIVATOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_144" -ForegroundColor Yellow
    Write-Host "Task      : Set WebApp Menu & Send Welcome Message" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- بارگذاری ماژول تلگرام ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $ConfDir   = Join-Path $RootPath "Core\Config"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    $tgModPath = Join-Path $ModuleDir "NSM_TelegramBot.psm1"
    $confPath  = Join-Path $ConfDir "NSM_BotConfig.json"

    if (!(Test-Path $tgModPath)) { throw "FATAL: Telegram Module not found. Run CMD_139 first." }
    if (!(Test-Path $confPath)) { throw "FATAL: Bot Config not found." }

    # تزریق ماژول تلگرام در حافظه
    $code = [System.IO.File]::ReadAllText($tgModPath)
    $code = $code -replace 'Import-Module.*', ''
    $code = $code -replace 'Export-ModuleMember.*', ''
    Invoke-Expression $code

    # --- خواندن تنظیمات ---
    Write-Host "[CMD_144] Reading Bot Configuration..." -ForegroundColor Cyan
    $configData = Get-Content $confPath -Raw | ConvertFrom-Json
    
    $BotToken = $configData.bot_token
    $AdminId  = $configData.admin_chat_id
    $WebUrl   = $configData.webapp_url

    if ($BotToken -eq "YOUR_TELEGRAM_BOT_TOKEN_HERE" -or [string]::IsNullOrWhiteSpace($BotToken)) {
        throw "ERROR: Bot Token is not set in NSM_BotConfig.json. Please add your token first!"
    }

    # --- فاز ۱: تنظیم دکمه منوی وب‌اپ ---
    Write-Host "[CMD_144] Setting Telegram WebApp Menu Button..." -ForegroundColor Cyan
    try {
        $menuResult = Set-NSMBotMenu -BotToken $BotToken -WebAppUrl $WebUrl
        if ($menuResult) {
            Write-Host "  [OK] WebApp Menu Button Activated!" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] Failed to set menu button. Check Token/URL." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [ERROR] Telegram API Exception: $_" -ForegroundColor Red
    }

    # --- فاز ۲: ارسال پیام خوش‌آمدگویی به ادمین ---
    if (![string]::IsNullOrWhiteSpace($AdminId) -and $AdminId -ne "YOUR_CHAT_ID") {
        Write-Host "[CMD_144] Sending Welcome Message to Admin..." -ForegroundColor Cyan
        $welcomeText = "🚀 *NASRIUM System Online*\n\nCyberpunk Ecosystem is ready.\nServer API is functional.\n\nClick the menu button to launch the game!"
        try {
            Send-NSMMessage -BotToken $BotToken -ChatId $AdminId -Text $welcomeText
            Write-Host "  [OK] Message sent to Admin." -ForegroundColor Green
        } catch {
            Write-Host "  [WARN] Could not send message. Check Chat ID." -ForegroundColor Yellow
        }
    }

    # --- ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_144_001"",`n`t""task"": ""Bot Activation"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_144_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_144 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_144_COMPLETE" -ForegroundColor Green
}

Invoke-CMD_144_ActivateBot
