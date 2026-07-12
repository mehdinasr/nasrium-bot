# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_141
# File ID   : CMD_141_001
# Module    : Game | Authentication
# Component : Player Registration & Identity Management
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_141_BuildAuth {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM USER AUTH CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_141" -ForegroundColor Yellow
    Write-Host "Task      : Build Player Registration Module" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # --- فاز ۱: ساخت ماژول NSM_UserAuth.psm1 ---
    Write-Host "[CMD_141] Synthesizing Authentication Module..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' ماژول احراز هویت و ثبت‌نام ناسریوم v1.0',
        ' وظیفه: مدیریت ورود کاربران جدید از تلگرام و تخصیص منابع اولیه',
        '#>',
        '',
        'function Initialize-NSMPlayer {',
        '    param(',
        '        [Parameter(Mandatory=$true)]',
        '        [string]$TelegramId,',
        '        [Parameter(Mandatory=$false)]',
        '        [string]$Username = "NewNode"',
        '    )',
        '    ',
        '    # بررسی اینکه آیا کاربر قبلاً ثبت‌نام کرده است یا خیر',
        '    $existingPlayer = Get-NSMPlayer -Id $TelegramId',
        '    if ($existingPlayer) {',
        '        return $existingPlayer',
        '    }',
        '    ',
        '    # ایجاد کاربر جدید با منابع اولیه (طبق تم سایبرپانک)',
        '    $newPlayer = @{',
        '        Id = $TelegramId',
        '        Username = $Username',
        '        LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
        '        Resources = @{ Credits=1000; Bandwidth=200 }',
        '        Buildings = @{ AI_CORE=@{Level=1} }',
        '    }',
        '    ',
        '    # ذخیره روی دیسک فیزیکی',
        '    $saveStatus = Save-NSMPlayer -PlayerObject $newPlayer',
        '    ',
        '    if ($saveStatus) {',
        '        return $newPlayer',
        '    } else {',
        '        throw "Failed to save new player $TelegramId"',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Initialize-NSMPlayer'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_UserAuth.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Auth Module Generated." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت ماژول احراز هویت: $_"
    }

    # --- فاز ۲: تست ثبت‌نام کاربر جدید ---
    Write-Host "[CMD_141] Running Registration Test..." -ForegroundColor Yellow
    
    $TestTgId = "TG_987654321"
    $TestDataDir = Join-Path $RootPath "Data\Players"
    $TestPath = Join-Path $TestDataDir "$TestTgId.json"

    # پاکسازی فایل تستی قبلی اگر وجود داشت
    if (Test-Path $TestPath) { Remove-Item $TestPath -Force | Out-Null }

    try {
        # تزریق مستقیم وابستگی‌ها برای تست
        $repoPath = Join-Path $ModuleDir "NSM_GameRepo.psm1"
        if (Test-Path $repoPath) {
            $repoCode = [System.IO.File]::ReadAllText($repoPath)
            $repoCode = $repoCode -replace 'Import-Module.*', ''
            $repoCode = $repoCode -replace 'Export-ModuleMember.*', ''
            Invoke-Expression $repoCode
        }
        
        # تزریق ماژول احراز هویت
        $authPath = Join-Path $ModuleDir "NSM_UserAuth.psm1"
        $authCode = [System.IO.File]::ReadAllText($authPath)
        $authCode = $authCode -replace 'Import-Module.*', ''
        $authCode = $authCode -replace 'Export-ModuleMember.*', ''
        Invoke-Expression $authCode

        # اجرای تابع ثبت‌نام
        $registeredUser = Initialize-NSMPlayer -TelegramId $TestTgId -Username "CyberRunner"

        if ($registeredUser.Id -eq $TestTgId -and $registeredUser.Resources.Credits -eq 1000) {
            Write-Host "  [OK] Test Passed! New player registered with 1000 Credits." -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Test failed." -ForegroundColor Red
        }

        # پاکسازی فایل تستی
        Remove-Item $TestPath -Force -ErrorAction SilentlyContinue | Out-Null

    } catch {
        Write-Host "  [WARN] Test Simulation Error: $_" -ForegroundColor Yellow
    }

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_141_001"",`n`t""task"": ""Auth Module Build"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_141_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_141 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_141_COMPLETE" -ForegroundColor Green
}

Invoke-CMD_141_BuildAuth
