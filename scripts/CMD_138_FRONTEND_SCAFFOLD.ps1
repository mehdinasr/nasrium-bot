# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_138
# File ID   : CMD_138_001
# Module    : Frontend | Mini-App
# Component : Telegram Web App UI Skeleton (Cyberpunk Theme)
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_138_BuildFrontend {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM MINI-APP FRONTEND CONSTRUCTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_138" -ForegroundColor Yellow
    Write-Host "Task      : Build Cyberpunk UI & JS Logic" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- تعریف مسیرها ---
    $RootPath     = "D:\NASRIUM"
    $FrontendDir  = Join-Path $RootPath "Core\Modules\Game\Frontend"
    $RegDir       = Join-Path $RootPath "Core\Registry"

    if (!(Test-Path $FrontendDir)) { New-Item -ItemType Directory -Path $FrontendDir -Force | Out-Null }

    # --- فاز ۱: ساخت فایل HTML با استایل سایبرپانک ---
    Write-Host "[CMD_138] Synthesizing UI (index.html)..." -ForegroundColor Cyan
    
    $HtmlContent = @(
        '<!DOCTYPE html>',
        '<html lang="fa" dir="rtl">',
        '<head>',
        '    <meta charset="UTF-8">',
        '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
        '    <title>NASRIUM Node</title>',
        '    <style>',
        '        body { font-family: "Courier New", monospace; background-color: #0d0d0d; color: #00ffcc; margin: 0; padding: 15px; }',
        '        h1 { text-align: center; text-shadow: 0 0 10px #00ffcc; }',
        '        .node-panel { border: 1px solid #00ffcc; padding: 10px; margin-bottom: 15px; background: rgba(0, 255, 204, 0.05); }',
        '        .resource-bar { display: flex; justify-content: space-between; font-size: 1.2em; }',
        '        .btn-action { width: 100%; padding: 12px; background: #1a1a1a; border: 1px solid #00ffcc; color: #00ffcc; cursor: pointer; font-family: inherit; font-size: 1em; margin-top: 10px; transition: 0.2s; }',
        '        .btn-action:hover { background: #00ffcc; color: #0d0d0d; }',
        '        #status-log { color: #ff00ff; font-size: 0.9em; margin-top: 15px; }',
        '    </style>',
        '</head>',
        '<body>',
        '    <h1>NASRIUM TERMINAL</h1>',
        '    <div class="node-panel">',
        '        <div class="resource-bar">',
        '            <span>Credits: <span id="res-credits">0</span></span>',
        '            <span>Bandwidth: <span id="res-bandwidth">0</span></span>',
        '        </div>',
        '    </div>',
        '    <div class="node-panel">',
        '        <h3>BUILDINGS</h3>',
        '        <button class="btn-action" onclick="upgradeBuilding(''DATA_MINER'')">Upgrade Data Miner</button>',
        '        <button class="btn-action" onclick="upgradeBuilding(''SERVER_FARM'')">Upgrade Server Farm</button>',
        '    </div>',
        '    <div id="status-log">System Ready. Awaiting commands...</div>',
        '',
        '    <script src="app.js"></script>',
        '</body>',
        '</html>'
    ) -join "`r`n"

    try {
        $OutFile = Join-Path $FrontendDir "index.html"
        [System.IO.File]::WriteAllText($OutFile, $HtmlContent, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] UI Template Generated." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت فایل HTML: $_"
    }

    # --- فاز ۲: ساخت فایل جاوااسکریپت (ارتباط با API) ---
    Write-Host "[CMD_138] Synthesizing Logic (app.js)..." -ForegroundColor Cyan
    
    $JsContent = @(
        'const API_BASE = "http://localhost:8080/api";',
        'const PLAYER_ID = "TEST_USER_001"; // شناسه موقت برای تست',
        '',
        '// دریافت اطلاعات بازیکن از سرور',
        'async function fetchPlayerData() {',
        '    try {',
        '        const res = await fetch(`${API_BASE}/player/${PLAYER_ID}`);',
        '        const data = await res.json();',
        '        if (data.Resources) {',
        '            document.getElementById("res-credits").innerText = Math.floor(data.Resources.Credits);',
        '            document.getElementById("res-bandwidth").innerText = Math.floor(data.Resources.Bandwidth);',
        '        }',
        '    } catch (e) {',
        '        logStatus("Connection Error: Server offline?");',
        '    }',
        '}',
        '',
        '// ارسال درخواست ارتقا به سرور',
        'async function upgradeBuilding(type) {',
        '    logStatus(`Sending upgrade request: ${type}...`);',
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
        $OutFile = Join-Path $FrontendDir "app.js"
        [System.IO.File]::WriteAllText($OutFile, $JsContent, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] JS Logic Generated." -ForegroundColor Green
    } catch {
        throw "خطا در ساخت فایل JS: $_"
    }

    # --- فاز ۳: ثبت در رجیستری ---
    $TS = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $RegContent = "{`n`t""cmd_id"": ""CMD_138_001"",`n`t""task"": ""Frontend Build"",`n`t""status"": ""COMPLETED"",`n`t""ts"": ""$TS""`n}"
    [System.IO.File]::WriteAllText((Join-Path $RegDir "CMD_138_STATE.json"), $RegContent)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_138 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_138_COMPLETE" -ForegroundColor Green
}

Invoke-CMD_138_BuildFrontend
