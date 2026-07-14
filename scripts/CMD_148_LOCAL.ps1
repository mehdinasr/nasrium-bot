# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_148_LOCAL
# File ID   : CMD_148_LOCAL_001
# Module    : Integration | Local Test
# Component : Localhost Button for Telegram Desktop
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
$stageId = "CMD_148_LOCAL"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$projectRoot = "D:\NASRIUM"
$scriptsPath = Join-Path $projectRoot "Scripts"
$logsPath = Join-Path $projectRoot "Logs"

New-Item -ItemType Directory -Path $scriptsPath -Force | Out-Null
New-Item -ItemType Directory -Path $logsPath -Force | Out-Null

$logFile = Join-Path $logsPath "CMD_148_LOCAL_$timestamp.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$time] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

Write-Log "========================================" "HEADER"
Write-Log "NASRIUM CMD_148_LOCAL - LOCALHOST TEST" "HEADER"
Write-Log "========================================" "HEADER"

# --- CHECK SERVER ---
Write-Log "--- Checking Server ---" "STEP"
try {
    $r = Invoke-WebRequest -Uri "http://localhost:8080/api/player/TEST_USER_001" -Method Get -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
    Write-Log "Server RUNNING on localhost:8080" "SUCCESS"
} catch {
    Write-Log "Server NOT running! Start it first:" "ERROR"
    Write-Log "D:\NASRIUM\START_NASRIUM_SERVER.ps1" "WARNING"
    Read-Host "Press Enter to exit"
    exit 1
}

# --- USE LOCALHOST ---
$TunnelUrl = "http://localhost:8080"
Write-Log "Using LOCALHOST: $TunnelUrl" "SUCCESS"

# --- UPDATE CONFIGS ---
$configPath = Join-Path $projectRoot "Core\Config\NSM_BotConfig.json"
$appJsPath = Join-Path $projectRoot "Core\Modules\Game\Frontend\app.js"

Write-Log "--- Updating Bot Config ---" "STEP"
$Config = Get-Content $configPath -Raw | ConvertFrom-Json
$Config.webapp_url = "$TunnelUrl/index.html"
$Config | ConvertTo-Json -Depth 3 | Set-Content $configPath -Encoding UTF8
Write-Log "Config updated" "SUCCESS"

Write-Log "--- Updating Frontend ---" "STEP"
$JsContent = [System.IO.File]::ReadAllText($appJsPath)
$JsContent = $JsContent -replace 'const API_BASE = "https://[^"]+/api";', 'const API_BASE = "http://localhost:8080/api";'
$JsContent = $JsContent -replace 'const API_BASE = "http://localhost:8080/api";', 'const API_BASE = "http://localhost:8080/api";'
[System.IO.File]::WriteAllText($appJsPath, $JsContent, (New-Object System.Text.UTF8Encoding $false))
Write-Log "Frontend updated" "SUCCESS"

# --- CREATE HTML BUTTON SENDER ---
Write-Log "--- Creating Button Sender ---" "STEP"
$BotToken = $Config.bot_token
if ($BotToken -match '^bot') { $BotToken = $BotToken.Substring(3) }
$WebUrl = $Config.webapp_url

$HtmlContent = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>NASRIUM - Send Local Button</title>
<style>
body{font-family:Tahoma;background:#0d0d0d;color:#00ffcc;text-align:center;padding:50px;margin:0}
h2{color:#00ffcc;text-shadow:0 0 10px #00ffcc}
.container{max-width:500px;margin:0 auto;background:#1a1a2e;padding:30px;border-radius:15px;border:1px solid #00ffcc}
input{padding:12px;font-size:16px;width:80%;text-align:center;background:#0d0d0d;color:#00ffcc;border:1px solid #00ffcc;border-radius:5px;margin:10px 0}
button{padding:15px 30px;font-size:18px;background:#00ffcc;color:#0d0d0d;border:none;cursor:pointer;border-radius:8px;font-weight:bold;margin-top:20px}
button:hover{background:#00ccaa;transform:scale(1.05)}
#status{margin-top:20px;font-size:1.1em;min-height:30px}
.success{color:#00ff00}.error{color:#ff4444}.info{color:#ffaa00}
.url-box{background:#16213e;padding:10px;border-radius:5px;word-break:break-all;margin:15px 0;font-size:0.9em}
</style>
</head>
<body>
<div class="container">
<h2>🚀 NASRIUM Local Test</h2>
<p>Local URL:</p>
<div class="url-box">$TunnelUrl</div>
<p>Enter your Telegram Chat ID:</p>
<input type="text" id="chatId" value="6964392525">
<br>
<button onclick="sendButton()">📤 SEND LOCAL BUTTON</button>
<p id="status"></p>
</div>
<script>
async function sendButton(){
const chatId=document.getElementById('chatId').value.trim();
if(!chatId){showStatus('Enter Chat ID','error');return;}
showStatus('Sending...','info');
const url='https://api.telegram.org/bot$BotToken/sendMessage';
const body={chat_id:chatId,text:'🎮 *NASRIUM Local Test*\\n\\nClick below (Telegram Desktop only):',parse_mode:'Markdown',reply_markup:{inline_keyboard:[[{text:'🚀 OPEN NASRIUM',web_app:{url:'$WebUrl'}}]]}};
try{const res=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)});const data=await res.json();if(data.ok){showStatus('✅ SUCCESS! Check Telegram Desktop.','success')}else{showStatus('❌ Error: '+data.description,'error')}}catch(e){showStatus('❌ Network error. Turn ON VPN.','error')}}
function showStatus(msg,type){const el=document.getElementById('status');el.textContent=msg;el.className=type;}
</script>
</body>
</html>
"@

$OutHtml = Join-Path $projectRoot "SEND_BUTTON_LOCAL.html"
[System.IO.File]::WriteAllText($OutHtml, $HtmlContent, (New-Object System.Text.UTF8Encoding $false))
Write-Log "Button sender created" "SUCCESS"

# --- OPEN CHROME ---
Write-Log "--- Opening Chrome ---" "STEP"
Start-Process $OutHtml
Write-Log "Chrome opened" "SUCCESS"

# --- FINAL ---
Write-Log ""
Write-Log "========================================" "HEADER"
Write-Log "CMD_148_LOCAL COMPLETE" "HEADER"
Write-Log "========================================" "HEADER"
Write-Log "✅ Server: RUNNING" "SUCCESS"
Write-Log "✅ URL: $TunnelUrl" "SUCCESS"
Write-Log "✅ Configs: UPDATED" "SUCCESS"
Write-Log "✅ Chrome: OPENED" "SUCCESS"
Write-Log ""
Write-Log "IMPORTANT:" "HEADER"
Write-Log "1. Turn ON VPN in Chrome" "INFO"
Write-Log "2. Click 📤 SEND LOCAL BUTTON" "INFO"
Write-Log "3. In Telegram DESKTOP, click 🚀 OPEN NASRIUM" "INFO"
Write-Log ""
Write-Log "⚠️ Telegram Desktop ONLY:" "WARNING"
Write-Log "   Settings → Advanced → Experimental → Allow local http" "WARNING"
Write-Log ""
Write-Log "⚠️ KEEP OPEN:" "WARNING"
Write-Log "   - START_NASRIUM_SERVER.ps1" "WARNING"
