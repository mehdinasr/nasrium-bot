# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_146
# File ID   : CMD_146_001
# Module    : Game | API
# Component : CORS Fix & Static File Server
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_146_FixCorsAndServe {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM API SERVER PATCH (CORS & STATIC)" -ForegroundColor Cyan
    Write-Host "Command   : CMD_146" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $RootPath  = "D:\NASRIUM"
    $ModuleDir = Join-Path $RootPath "Core\Modules\Game"

    Write-Host "[CMD_146] Updating API Server Module..." -ForegroundColor Cyan
    
    $CodeLines = @( 
        '<#',
        ' دروازه ارتباطی بازی ناسریوم v3.0',
        ' ویژگی‌ها: پشتیبانی از CORS، ارائه فایل‌های استاتیک (HTML/JS)، مسیرهای API',
        '#>',
        '',
        'function Start-NSMGameServer {',
        '    param([int]$Port = 8080)',
        '    ',
        '    $listener = [System.Net.HttpListener]::new()',
        '    $prefix = "http://localhost:$Port/"',
        '    $listener.Prefixes.Add($prefix)',
        '    ',
        '    $FrontendDir = "D:\NASRIUM\Core\Modules/Game/Frontend"',
        '    ',
        '    try {',
        '        $listener.Start()',
        '        Write-Host "NASRIUM Server running on $prefix" -ForegroundColor Green',
        '        ',
        '        while ($listener.IsListening) {',
        '            $context = $listener.GetContext()',
        '            $request = $context.Request',
        '            $response = $context.Response',
        '            ',
        '            # اعمال قانون CORS برای رفع خطای Network Error',
        '            $response.Headers.Add("Access-Control-Allow-Origin", "*")',
        '            $response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")',
        '            $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")',
        '            ',
        '            # پاسخ به درخواست‌های پیش‌فرض مرورگر',
        '            if ($request.HttpMethod -eq "OPTIONS") {',
        '                $response.StatusCode = 200',
        '                $response.Close()',
        '                continue',
        '            }',
        '            ',
        '            $url = $request.Url.AbsolutePath',
        '            ',
        '            # ارائه فایل‌های ظاهری بازی (HTML و JS)',
        '            if ($url -eq "/" -or $url -eq "/index.html") {',
        '                $filePath = Join-Path $FrontendDir "index.html"',
        '                $buffer = [System.IO.File]::ReadAllBytes($filePath)',
        '                $response.ContentType = "text/html; charset=utf-8"',
        '                $response.ContentLength64 = $buffer.Length',
        '                $response.OutputStream.Write($buffer, 0, $buffer.Length)',
        '                $response.Close()',
        '            }',
        '            elseif ($url -eq "/app.js") {',
        '                $filePath = Join-Path $FrontendDir "app.js"',
        '                $buffer = [System.IO.File]::ReadAllBytes($filePath)',
        '                $response.ContentType = "application/javascript; charset=utf-8"',
        '                $response.ContentLength64 = $buffer.Length',
        '                $response.OutputStream.Write($buffer, 0, $buffer.Length)',
        '                $response.Close()',
        '            }',
        '            # مسیرهای API بازی',
        '            else {',
        '                $segments = $request.Url.Segments | Where-Object { $_ -ne "/" }',
        '                $result = @{ Status="Error"; Message="Unknown Endpoint" }',
        '                ',
        '                try {',
        '                    if ($segments[0] -eq "api/" -and $segments[1] -eq "auth/") {',
        '                        $id = $segments[2].TrimEnd("/")',
        '                        $name = $request.QueryString["name"]',
        '                        if (-not $name) { $name = "NewNode" }',
        '                        $result = Initialize-NSMPlayer -TelegramId $id -Username $name',
        '                    }',
        '                    elseif ($segments[0] -eq "api/" -and $segments[1] -eq "player/") {',
        '                        $id = $segments[2].TrimEnd("/")',
        '                        $player = Get-NSMPlayer -Id $id',
        '                        if ($player) { $result = $player } ',
        '                        else { $result = @{ Status="Fail"; Message="Player Not Found" } }',
        '                    }',
        '                    elseif ($segments[0] -eq "api/" -and $segments[1] -eq "upgrade/") {',
        '                        $id = $segments[2].TrimEnd("/")',
        '                        $building = $request.QueryString["building"]',
        '                        $result = Start-NSMBuildingUpgrade -PlayerId $id -BuildingType $building',
        '                    }',
        '                } catch {',
        '                    $result = @{ Status="Exception"; Message=$_.Exception.Message }',
        '                }',
        '                ',
        '                $json = $result | ConvertTo-Json -Depth 3',
        '                $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)',
        '                $response.ContentType = "application/json"',
        '                $response.ContentLength64 = $buffer.Length',
        '                $response.OutputStream.Write($buffer, 0, $buffer.Length)',
        '                $response.Close()',
        '            }',
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
        throw "خطا در بروزرسانی سرور: $_"
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_146 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
}

Invoke-CMD_146_FixCorsAndServe
