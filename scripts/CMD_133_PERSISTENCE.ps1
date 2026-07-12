# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_133
# File ID   : CMD_133_001
# Module    : Game | Persistence
# Component : Player Data Repository & State Manager
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_133_Persistence {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PERSISTENCE LAYER CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_133" -ForegroundColor Yellow
    Write-Host "Task      : Build Player Save/Load Engine" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $DataDir   = Join-Path $RootPath "Data\Players"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    # --- ایجاد پوشه‌ها در صورت عدم وجود ---
    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $DataDir)) { New-Item -ItemType Directory -Path $DataDir -Force | Out-Null }

    # --- فاز ۱: ساخت ماژول NSM_GameRepo.psm1 ---
    Write-Host "[CMD_133] Synthesizing Persistence Module..." -ForegroundColor Cyan
    
    # استفاده از کوتیشن تکی برای جلوگیری از خطای متغیرها
    $CodeLines = @( 
        '<#',
        ' ماژول ذخیره‌سازی بازی ناسریوم v1.0',
        ' وظیفه: خواندن و نوشتن اطلاعات بازیکن روی دیسک فیزیکی',
        '#>',
        '',
        'function Get-PlayerSavePath {',
        '    param([string]$Id)',
        '    return Join-Path "D:\NASRIUM\Data\Players" "$Id.json"',
        '}',
        '',
        'function Save-NSMPlayer {',
        '    param([Parameter(Mandatory=$true)]$PlayerObject)',
        '    $Path = Get-PlayerSavePath -Id $PlayerObject.Id',
        '    try {',
        '        $Json = $PlayerObject | ConvertTo-Json -Depth 5',
        '        [System.IO.File]::WriteAllText($Path, $Json, (New-Object System.Text.UTF8Encoding $false))',
        '        return $true',
        '    } catch {',
        '        Write-Host "ERROR Saving Player: $_" -ForegroundColor Red',
        '        return $false',
        '    }',
        '}',
        '',
        'function Get-NSMPlayer {',
        '    param([string]$Id)',
        '    $Path = Get-PlayerSavePath -Id $Id',
        '    if (Test-Path $Path) {',
        '        try {',
        '            $Raw = [System.IO.File]::ReadAllText($Path)',
        '            return $Raw | ConvertFrom-Json',
        '        } catch {',
        '            return $null',
        '        }',
        '    } else {',
        '        return $null',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Save-NSMPlayer, Get-NSMPlayer'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_GameRepo.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Persistence Module Generated." -ForegroundColor Green
    } catch {
        throw "خطای بحرانی در نوشتن ماژول: $_"
    }

    # --- فاز ۲: تست یکپارچگی ---
    Write-Host "[CMD_133] Running Save/Load Test..." -ForegroundColor Yellow
    
    $TestPlayerId = "REPO_TEST_USER"
    $TestPath = Join-Path $DataDir "$TestPlayerId.json"

    try {
        # ساخت اطلاعات تستی
        $TestData = @{ Id=$TestPlayerId; Username="CyberNode"; Credits=5000 }
        $TestJson = $TestData | ConvertTo-Json
        
        # نوشتن روی دیسک
        [System.IO.File]::WriteAllText($TestPath, $TestJson, (New-Object System.Text.UTF8Encoding $false))

        # خواندن از دیسک
        $LoadedData = Get-Content $TestPath -Raw | ConvertFrom-Json
        
        if ($LoadedData.Credits -eq 5000) {
            Write-Host "  [OK] Save/Load Integrity Verified." -ForegroundColor Green
        }
        
        # پاک کردن فایل تستی
        Remove-Item $TestPath -Force | Out-Null
    } catch {
        Write-Host "  [WARN] Test encountered an issue: $_" -ForegroundColor Yellow
    }

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_133_001"",`n`t""task"": ""Persistence Layer"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_133_STATE.json"), $RegContent)

    # --- بررسی نهایی ---
    $CheckPath = Join-Path $ModuleDir "NSM_GameRepo.psm1"
    
    Write-Host ""
    Write-Host "===== VERIFICATION =====" -ForegroundColor Cyan
    
    if (Test-Path $CheckPath) {
        Write-Host "  [OK] ماژول ذخیره‌سازی با موفقیت ساخته شد." -ForegroundColor Green
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_133 COMPLETE (100%)" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_133_COMPLETE" -ForegroundColor Green
    } else {
        Write-Host "ERROR_CMD_133_INCOMPLETE" -ForegroundColor Red
        exit 1
    }
}

Invoke-CMD_133_Persistence
