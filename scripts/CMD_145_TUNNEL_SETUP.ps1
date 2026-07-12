# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_145
# File ID   : CMD_145_001
# Module    : Integration | Network
# Component : Public Tunnel Setup & URL Sync
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_145_TunnelSetup {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PUBLIC TUNNEL CONFIGURATOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_145" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $RootPath     = "D:\NASRIUM"
    $ConfigPath   = Join-Path $RootPath "Core\Config\NSM_BotConfig.json"
    $FrontendDir  = Join-Path $RootPath "Core\Modules\Game\Frontend"
    $AppJsPath    = Join-Path $FrontendDir "app.js"

    Write-Host "برای اتصال کاربران تلگرام به سرور محلی شما، به یک آدرس عمومی نیاز دارید." -ForegroundColor Yellow
    Write-Host "در صورت عدم نصب، برنامه ngrok را از لینک زیر دانلود کنید:" -ForegroundColor Yellow
    Write-Host "https://ngrok.com/download" -ForegroundColor Cyan
    Write-Host "پس از نصب، این دستور را در یک پنجره جداگانه اجرا کنید: ngrok http 8080" -ForegroundColor Yellow
    Write-Host ""
    
    # گرفتن آدرس عمومی از کاربر
    $PublicUrl = Read-Host "لطفاً آدرس عمومی Ngrok خود را وارد کنید (مثال: https://1234abcd.ngrok-free.app)"

    if ([string]::IsNullOrWhiteSpace($PublicUrl)) {
        throw "آدرس عمومی نمی‌تواند خالی باشد."
    }

    # حذف اسلش آخر اگر کاربر گذاشته باشد
    $PublicUrl = $PublicUrl.TrimEnd('/')

    # --- فاز : آپدیت فایل کانفیگ ربات ---
    Write-Host "[CMD_145] در حال بروزرسانی تنظیمات ربات..." -ForegroundColor Cyan
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    $Config.webapp_url = "$PublicUrl/index.html"
    $Config | ConvertTo-Json -Depth 3 | Set-Content $ConfigPath -Encoding UTF8
    Write-Host "  [OK] تنظیمات ربات بروزرسانی شد." -ForegroundColor Green

    # --- فاز : آپدیت فایل app.js برای اتصال به سرور عمومی ---
    Write-Host "[CMD_145] در حال بروزرسانی آدرس API در رابط کاربری..." -ForegroundColor Cyan
    
    if (Test-Path $AppJsPath) {
        $JsContent = [System.IO.File]::ReadAllText($AppJsPath)
        # جایگزینی آدرس API
        $JsContent = $JsContent -replace 'const API_BASE = "http://localhost:8080/api";', "const API_BASE = `"$PublicUrl/api`";"
        [System.IO.File]::WriteAllText($AppJsPath, $JsContent, (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] آدرس API در رابط کاربری بروزرسانی شد." -ForegroundColor Green
    } else {
        Write-Host "  [WARN] فایل app.js یافت نشد. بروزرسانی دستی لازم است." -ForegroundColor Yellow
    }

    # --- فاز : بروزرسانی دکمه ربات تلگرام با آدرس جدید ---
    Write-Host "[CMD_145] در حال بروزرسانی آدرس دکمه منوی تلگرام..." -ForegroundColor Cyan
    
    $BotToken = $Config.bot_token
    if ($BotToken -match '^bot') { $BotToken = $BotToken.Substring(3) }
    $WebUrl = $Config.webapp_url

    $HtmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>NASRIUM Bot Activator</title>
    <style>body{font-family:Tahoma;background:#0d0d0d;color:#00ffcc;text-align:center;padding:50px;}button{padding:15px 30px;font-size:18px;background:#00ffcc;color:#0d0d0d;border:none;cursor:pointer;border-radius:5px;}</style>
</head>
<body>
    <h2>بروزرسانی آدرس دکمه ربات</h2>
    <button onclick="activateBot()">بروزرسانی آدرس منوی ربات</button>
    <p id="status" style="color:yellow;font-size:1.2em;"></p>
    <script>
        async function activateBot() {
            const url = 'https://api.telegram.org/bot$BotToken/setChatMenuButton';
            const body = { menu_button: { type: 'web_app', text: 'Open NASRIUM', web_app: { url: '$WebUrl' } } };
            try {
                const res = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
                const data = await res.json();
                if(data.ok) { document.getElementById('status').innerText = ' موفقیت‌آمیز! آدرس دکمه ربات بروزرسانی شد.'; document.getElementById('status').style.color='#00ff00'; }
                else { document.getElementById('status').innerText = ' خطای API: ' + data.description; document.getElementById('status').style.color='red'; }
            } catch(e) { document.getElementById('status').innerText = ' خطای شبکه: ' + e.message; document.getElementById('status').style.color='red'; }
        }
    </script>
</body>
</html>
"@
    $OutHtml = Join-Path $RootPath "UPDATE_BOT_URL.html"
    [System.IO.File]::WriteAllText($OutHtml, $HtmlContent, (New-Object System.Text.UTF8Encoding $false))
    Start-Process $OutHtml

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_145 COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "گام بعدی: در مرورگر روی دکمه بروزرسانی کلیک کنید!" -ForegroundColor Yellow
}

Invoke-CMD_145_TunnelSetup
