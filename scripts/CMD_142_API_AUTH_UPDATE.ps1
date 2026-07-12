# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_142
# File ID   : CMD_142_001
# Module    : Game | API & Orchestration
# Component : API Auth Update & Master Launcher
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_142_UpdateApiAndLauncher {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM API UPDATE & LAUNCHER CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_142" -ForegroundColor Yellow
    Write-Host "Task      : Add Auth Endpoint & Build Master Start Script" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    # --- فاز ۱: آپدیت ماژول سرور API ---
    Write-Host "[CMD_142] Updating API Server Module (Adding Auth)..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' دروازه ارتباطی بازی ناسریوم v2.0',
        ' وظیفه: دریافت درخواست‌های HTTP شامل احراز هویت، اطلاعات بازیکن و ارتقا',
        '#>',
        '',
        'function Start-NSMGameServer {',
        '    param([int]$Port = 8080)',
        '    ',
        '    $listener = [System.Net.HttpListener]::new()',
        '    $prefix = "http://localhost:$Port/"',
        '    $listener.Prefixes.Add($prefix)',
        '    ',
        '    try {',
        '        $listener.Start()',
        '        Write-Host "NASRIUM Server running on $prefix" -ForegroundColor Green',
        '        Write-Host "Waiting for requests..." -ForegroundColor DarkGray',
        '        ',
        '        while ($listener.IsListening) {',
        '            $context = $listener.GetContext()',
        '            $request = $context.Request',
        '            $response = $context.Response',
        '            ',
        '            $segments = $request.Url.Segments | Where-Object { $_ -ne "/" }',
        '            $result = @{ Status="Error"; Message="Unknown Endpoint" }',
        '            ',
        '            try {',
        '                # مسیر احراز هویت و ثبت‌نام (جدید)',
        '                if ($segments[0] -eq "api/" -and $segments[1] -eq "auth/") {',
        '                    $id = $segments[2].TrimEnd("/")',
        '                    $name = $request.QueryString["name"]',
        '                    if (-not $name) { $name = "NewNode" }',
        '                    $result = Initialize-NSMPlayer -TelegramId $id -Username $name',
        '                }',
        '                # مسیر دریافت اطلاعات بازیکن',
        '                elseif ($segments[0] -eq "api/" -and $segments[1] -eq "player/") {',
        '                    $id = $segments[2].TrimEnd("/")',
        '                    $player = Get-NSMPlayer -Id $id',
        '                    if ($player) { $result = $player } ',
        '                    else { $result = @{ Status="Fail"; Message="Player Not Found" } }',
        '                }',
        '                # مسیر ارتقای ساختمان',
        '                elseif ($segments[0] -eq "api/" -and $segments[1] -eq "upgrade/") {',
        '                    $id = $segments[2].TrimEnd("/")',
        '                    $building = $request.QueryString["building"]',
        '                    $result = Start-NSMBuildingUpgrade -PlayerId $id -BuildingType $building',
        '                }',
        '            } catch {',
        '                $result = @{ Status="Exception"; Message=$_.Exception.Message }',
        '            }',
        '            ',
        '            # ارسال پاسخ به صورت JSON',
        '            $json = $result | ConvertTo-Json -Depth 3',
        '            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)',
        '            $response.ContentLength64 = $buffer.Length',
        '            $response.OutputStream.Write($buffer, 0, $buffer.Length)',
        '            $response.Close()',
        '        }',
        '    } catch {',
        '        Write-Host "Server stopped or error occurred: $_" -ForegroundColor Red',
        '    } finally {',
        '        $listener.Stop()',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Start-NSMGameServer'
    )

    try {
        $FinalCode = $CodeLines -join "`r`n"
        $OutFile = Join-Path $ModuleDir "NSM_ApiServer.psm1"
        [System.IO.File]::WriteAllText($OutFile, $FinalCode, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] API Server Module Updated." -ForegroundColor Green
    } catch {
        throw "خطا در بروزرسانی ماژول سرور: $_"
    }

    # --- فاز ۲: ساخت اسکریپت راه‌انداز جامع (Master Launcher) ---
    Write-Host "[CMD_142] Creating Master Launcher Script..." -ForegroundColor Cyan
    
    $LauncherPath = Join-Path $RootPath "START_NASRIUM_SERVER.ps1"
    $LauncherCode = @(
        '# ================================================================================',
        '# اسکریپت راه‌انداز سریع و امن بازی ناسریوم',
        '# این اسکریپت تمام وابستگی‌ها را در سطح اصلی بارگذاری کرده و سرور را روشن می‌کند',
        '# ================================================================================',
        '',
        '$ErrorActionPreference = "Stop"',
        'Set-StrictMode -Version Latest',
        '',
        'Write-Host "Initializing NASRIUM Environment..." -ForegroundColor Cyan',
        '',
        '$RootPath = "D:\NASRIUM"',
        '$ModuleDir = Join-Path $RootPath "Core\Modules\Game"',
        '',
        '# بارگذاری ایمن ماژول‌ها (جلوگیری از خطاهای Scope)',
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
        '        throw "FATAL: $mod not found. Run build commands first."',
        '    }',
        '}',
        '',
        'Write-Host ""',
        'Write-Host "==========================================" -ForegroundColor Yellow',
        'Write-Host "   STARTING NASRIUM GAME SERVER" -ForegroundColor Yellow',
        'Write-Host "==========================================" -ForegroundColor Yellow',
        '',
        '# روشن کردن سرور روی پورت 8080',
        'Start-NSMGameServer -Port 8080'
    ) -join "`r`n"
    
    [System.IO.File]::WriteAllText($LauncherPath, $LauncherCode, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  [OK] Master Launcher Generated." -ForegroundColor Green

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_142_001"",`n`t""task"": ""API Auth & Launcher"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_142_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_142 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_142_COMPLETE" -ForegroundColor Green
}

Invoke-CMD_142_UpdateApiAndLauncher
