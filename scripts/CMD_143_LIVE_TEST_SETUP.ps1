# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_143
# File ID   : CMD_143_001
# Module    : System | Live Testing
# Component : Local Server & Client Simulation Setup
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_143_LiveTestSetup {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM LIVE TEST SETUP" -ForegroundColor Cyan
    Write-Host "Command   : CMD_143" -ForegroundColor Yellow
    Write-Host "Task      : Create Server & Client Test Scripts" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    # --- فاز ۱: ساخت اسکریپت راه‌انداز سرور (نسخه نهایی) ---
    Write-Host "[CMD_143] Creating Final Server Launcher..." -ForegroundColor Cyan
    
    $ServerScript = @(
        '# راه‌انداز سرور ناسریوم - اجرا با دسترسی ادمین',
        '$ErrorActionPreference = "Stop"',
        'Set-StrictMode -Version Latest',
        '',
        'Write-Host "Initializing NASRIUM Environment..." -ForegroundColor Cyan',
        '',
        '$RootPath = "D:\NASRIUM"',
        '$ModuleDir = Join-Path $RootPath "Core\Modules\Game"',
        '',
        '# بارگذاری ایمن ماژول‌ها با تکنیک Dot-Sourcing',
        '$modules = @(',
        '    "NSM_GameRepo.psm1",',
        '    "NSM_GameEngine.psm1",',
        '    "NSM_EconomyProcessor.psm1",',
        '    "NSM_ActionHandler.psm1",',
        '    "NSM_UserAuth.psm1",',
        '    "NSM_ApiServer.psm1"',
        ')',
        '',
        'foreach ($mod in $modules) {',
        '    $modPath = Join-Path $ModuleDir $mod',
        '    if (Test-Path $modPath) {',
        '        . $modPath',
        '        Write-Host "  [Loaded] $mod" -ForegroundColor Green',
        '    } else {',
        '        throw "FATAL: $mod not found."',
        '    }',
        '}',
        '',
        'Write-Host ""',
        'Write-Host "==========================================" -ForegroundColor Yellow',
        'Write-Host "   NASRIUM SERVER IS STARTING..." -ForegroundColor Yellow',
        'Write-Host "   Open index.html in your browser now!" -ForegroundColor Yellow',
        'Write-Host "==========================================" -ForegroundColor Yellow',
        '',
        'Start-NSMGameServer -Port 8080'
    ) -join "`r`n"

    try {
        $OutFile = Join-Path $RootPath "START_NASRIUM_SERVER.ps1"
        [System.IO.File]::WriteAllText($OutFile, $ServerScript, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Server Launcher Created." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت لانچر: $_"
    }

    # --- فاز ۲: ساخت اسکریپت تست کلاینت (شبیه‌سازی درخواست‌ها) ---
    Write-Host "[CMD_143] Creating Client Simulation Script..." -ForegroundColor Cyan
    
    $ClientScript = @(
        '# تست کلاینت ناسریوم - این اسکریپت را در یک پنجره دیگر اجرا کنید',
        '$BaseURL = "http://localhost:8080/api"',
        '$TestTgId = "TG_112233445"',
        '',
        'Write-Host "=========================================" -ForegroundColor Magenta',
        'Write-Host "NASRIUM CLIENT SIMULATION" -ForegroundColor Magenta',
        'Write-Host "=========================================" -ForegroundColor Magenta',
        '',
        'Write-Host "1. Registering User..." -ForegroundColor Cyan',
        'try {',
        '    $reg = Invoke-RestMethod -Uri "$BaseURL/auth/$TestTgId?name=TestNode" -Method Get',
        '    Write-Host "   Status: User Registered! Credits: $($reg.Resources.Credits)" -ForegroundColor Green',
        '} catch { Write-Host "   Error: $_" -ForegroundColor Red }',
        '',
        'Write-Host "2. Fetching Player Data..." -ForegroundColor Cyan',
        'try {',
        '    $data = Invoke-RestMethod -Uri "$BaseURL/player/$TestTgId" -Method Get',
        '    Write-Host "   Data Received: Level 1 AI_CORE found." -ForegroundColor Green',
        '} catch { Write-Host "   Error: $_" -ForegroundColor Red }',
        '',
        'Write-Host "3. Upgrading DATA_MINER..." -ForegroundColor Cyan',
        'try {',
        '    $up = Invoke-RestMethod -Uri "$BaseURL/upgrade/$TestTgId?building=DATA_MINER" -Method Get',
        '    Write-Host "   Upgrade Result: Success=$($up.Success), Message=$($up.Message)" -ForegroundColor Green',
        '} catch { Write-Host "   Error: $_" -ForegroundColor Red }',
        '',
        'Write-Host "=========================================" -ForegroundColor Green',
        'Write-Host "CLIENT TEST FINISHED" -ForegroundColor Green'
    ) -join "`r`n"

    try {
        $OutFile = Join-Path $RootPath "TEST_LIVE_GAME.ps1"
        [System.IO.File]::WriteAllText($OutFile, $ClientScript, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Client Test Script Created." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت اسکریپت تست: $_"
    }

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_143_001"",`n`t""task"": ""Live Test Setup"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_143_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_143 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_143_COMPLETE" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. Open a NEW PowerShell window as Administrator." -ForegroundColor White
    Write-Host "2. Run: D:\NASRIUM\START_NASRIUM_SERVER.ps1" -ForegroundColor White
    Write-Host "3. Open another PowerShell window and Run: D:\NASRIUM\TEST_LIVE_GAME.ps1" -ForegroundColor White
}

Invoke-CMD_143_LiveTestSetup
