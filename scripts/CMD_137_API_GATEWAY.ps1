# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_137
# File ID   : CMD_137_001
# Module    : Game | API
# Component : Local HTTP Gateway (Telegram Mini-App Bridge)
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_137_BuildApiGateway {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM API GATEWAY CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_137" -ForegroundColor Yellow
    Write-Host "Task      : Build Local HTTP Server Bridge" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"
    $RegDir    = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }

    # --- فاز ۱: ساخت ماژول NSM_ApiServer.psm1 ---
    Write-Host "[CMD_137] Synthesizing API Gateway..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' دروازه ارتباطی بازی ناسریوم v1.0',
        ' وظیفه: دریافت درخواست‌های HTTP و ارجاع آن‌ها به موتور بازی',
        '#>',
        '',
        'Import-Module (Join-Path $PSScriptRoot "NSM_ActionHandler.psm1") -Force',
        'Import-Module (Join-Path $PSScriptRoot "NSM_GameRepo.psm1") -Force',
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
        '            # استخراج بخش‌های آدرس (Routing)',
        '            $segments = $request.Url.Segments | Where-Object { $_ -ne "/" }',
        '            $result = @{ Status="Error"; Message="Unknown Endpoint" }',
        '            ',
        '            try {',
        '                # مسیر دریافت اطلاعات بازیکن',
        '                if ($segments[0] -eq "api/" -and $segments[1] -eq "player/") {',
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
        Write-Host "  [OK] API Gateway Module Generated." -ForegroundColor Green
    } catch {
        throw "خطای بحرانی در نوشتن ماژول: $_"
    }

    # --- فاز ۲: ساخت اسکریپت راه‌انداز سریع (Run Server) ---
    Write-Host "[CMD_137] Creating Server Launcher Script..." -ForegroundColor Cyan
    
    $LauncherPath = Join-Path $RootPath "START_NASRIUM_SERVER.ps1"
    $LauncherCode = @(
        '# راه‌انداز سرور ناسریوم',
        '$ErrorActionPreference = "Stop"',
        'Import-Module "D:\NASRIUM\Core\Modules/Game/NSM_ApiServer.psm1" -Force',
        'Start-NSMGameServer -Port 8080'
    ) -join "`r`n"
    
    [System.IO.File]::WriteAllText($LauncherPath, $LauncherCode, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "  [OK] Launcher Script Generated." -ForegroundColor Green

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_137_001"",`n`t""task"": ""API Gateway Build"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_137_STATE.json"), $RegContent)

    # --- بررسی نهایی ---
    $CheckPath = Join-Path $ModuleDir "NSM_ApiServer.psm1"
    
    Write-Host ""
    Write-Host "===== VERIFICATION =====" -ForegroundColor Cyan
    
    if (Test-Path $CheckPath) {
        Write-Host "  [OK] دروازه ارتباطی با موفقیت ساخته شد." -ForegroundColor Green
        Write-Host ""
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_137 COMPLETE (100%)" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_137_COMPLETE" -ForegroundColor Green
    } else {
        Write-Host "ERROR_CMD_137_INCOMPLETE" -ForegroundColor Red
        exit 1
    }
}

Invoke-CMD_137_BuildApiGateway
