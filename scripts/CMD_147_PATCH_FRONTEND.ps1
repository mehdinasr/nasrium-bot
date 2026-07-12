# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_147
# File ID   : CMD_147_001
# Module    : Frontend | Patch
# Component : Smart JS Logic & Auto-Registration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_147_PatchFrontend {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM FRONTEND SMART PATCH" -ForegroundColor Cyan
    Write-Host "Command   : CMD_147" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $RootPath     = "D:\NASRIUM"
    $FrontendDir  = Join-Path $RootPath "Core\Modules\Game\Frontend"
    $AppJsPath    = Join-Path $FrontendDir "app.js"

    Write-Host "[CMD_147] Updating app.js with Auto-Auth Logic..." -ForegroundColor Cyan
    
    $JsContent = @(
        'const API_BASE = "http://localhost:8080/api";',
        'const PLAYER_ID = "TEST_USER_001";',
        '',
        '// دریافت اطلاعات بازیکن از سرور',
        'async function fetchPlayerData() {',
        '    try {',
        '        let res = await fetch(`${API_BASE}/player/${PLAYER_ID}`);',
        '        let data = await res.json();',
        '        ',
        '        // اگر کاربر پیدا نشد ابتدا او را ثبتنام کن',
        '        if (data.Status === "Fail" && data.Message === "Player Not Found") {',
        '            logStatus("Registering new node...");',
        '            res = await fetch(`${API_BASE}/auth/${PLAYER_ID}?name=CyberRunner`);',
        '            data = await res.json();',
        '        }',
        '        ',
        '        if (data.Resources) {',
        '            document.getElementById("res-credits").innerText = Math.floor(data.Resources.Credits);',
        '            document.getElementById("res-bandwidth").innerText = Math.floor(data.Resources.Bandwidth);',
        '            logStatus("System Online. Awaiting commands.");',
        '        }',
        '    } catch (e) {',
        '        logStatus("Connection Error: Server offline?");',
        '    }',
        '}',
        '',
        '// ارسال درخواست ارتقا به سرور',
        'async function upgradeBuilding(type) {',
        '    logStatus(`Upgrading ${type}...`);',
        '    try {',
        '        const res = await fetch(`${API_BASE}/upgrade/${PLAYER_ID}?building=${type}`);',
        '        const data = await res.json();',
        '        if (data.Success) {',
        '            logStatus(`Success! ${type} upgraded to Level ${data.NewLevel}.`);',
        '            fetchPlayerData(); // بروزرسانی منابع',
        '        } else {',
        '            logStatus(`Failed: ${data.Message}`);',
        '        }',
        '    } catch (e) {',
        '        logStatus("Network Error");',
        '    }',
        '}',
        '',
        'function logStatus(msg) {',
        '    document.getElementById("status-log").innerText = msg;',
        '}',
        '',
        '// لود اولیه اطلاعات',
        'fetchPlayerData();'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($AppJsPath, $JsContent, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] app.js Patched Successfully." -ForegroundColor Green
    } catch {
        throw "خطا در بروزرسانی فایل JS: $_"
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_147 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
}

Invoke-CMD_147_PatchFrontend
