$ErrorActionPreference = "Stop"

$stageId = "CMD_013_TOKENFILE"
$root = "D:\NASRIUM"
$appDir = "D:\NASRIUM\Apps\telegram-bot"
$core = Join-Path $root "Core"
$logsDir = Join-Path $core "Logs"
$secretsDir = Join-Path $core "Secrets"
$tokenFile = Join-Path $secretsDir "telegram_bot_token.txt"
$pidFile = Join-Path $logsDir "telegram-bot.pid"
$stdoutLog = Join-Path $logsDir "telegram-bot_stdout.log"
$stderrLog = Join-Path $logsDir "telegram-bot_stderr.log"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$transcript = Join-Path $logsDir ($stageId + "_" + $ts + ".transcript.txt")

function Step($i,$n,$msg){ Write-Host ("STEP {0}/{1} - {2}" -f $i,$n,$msg) -ForegroundColor Cyan }
function OK($msg){ Write-Host ("OK  - {0}" -f $msg) -ForegroundColor Green }
function WARN($msg){ Write-Host ("WARN- {0}" -f $msg) -ForegroundColor Yellow }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null
$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "NASRIUM - CMD_013_TOKENFILE (Token in File)" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan

  Step 1 8 "Check app folder"
  if (!(Test-Path $appDir)) { throw ("App folder not found: " + $appDir) }
  OK "App folder exists"

  Step 2 8 "Stop previous bot process (if exists)"
  if (Test-Path $pidFile) {
    $botPidStr = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
    if ($botPidStr -match "^\d+$") {
      $botPid = [int]$botPidStr
      $p = Get-Process -Id $botPid -ErrorAction SilentlyContinue
      if ($p -and $p.ProcessName -eq "node") { Stop-Process -Id $botPid -Force; OK ("Stopped old bot PID=" + $botPid) }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  } else {
    OK "No previous PID file"
  }

  Step 3 8 "Ensure token file exists and open Notepad for paste"
  New-Item -ItemType Directory -Path $secretsDir -Force | Out-Null
  if (!(Test-Path $tokenFile)) { New-Item -ItemType File -Path $tokenFile -Force | Out-Null }

  Write-Host ""
  Write-Host "اکنون Notepad باز میشود." -ForegroundColor Yellow
  Write-Host "توکن BotFather را داخل فایل Paste کنید سپس Ctrl+S بزنید و Notepad را ببندید." -ForegroundColor Yellow
  Write-Host ("مسیر فایل توکن: " + $tokenFile) -ForegroundColor Gray
  Write-Host ""

  Start-Process notepad.exe -ArgumentList $tokenFile -Wait

  Step 4 8 "Read token from file (token will not be printed)"
  $token = ""
  if (Test-Path $tokenFile) { $token = (Get-Content $tokenFile -Raw -ErrorAction SilentlyContinue) }
  if ($null -eq $token) { $token = "" }
  $token = [string]$token
  $token = $token.Trim()

  if ([string]::IsNullOrWhiteSpace($token)) { throw "Token file is empty. Paste full token and save." }
  if ($token.Length -lt 35) { throw ("Token too short (len=" + $token.Length + "). Paste full token from BotFather.") }
  OK ("Token loaded. Length=" + $token.Length + " (masked)")

  Step 5 8 "Write .env"
  @("BOT_TOKEN=$token","NODE_ENV=development") | Out-File -FilePath (Join-Path $appDir ".env") -Encoding UTF8 -Force
  OK ".env written"

  Step 6 8 "Disable webhook if active (allow long polling)"
  try {
    $info = Invoke-RestMethod -Uri ("https://api.telegram.org/bot" + $token + "/getWebhookInfo") -Method Get -TimeoutSec 20
    $whUrl = $info.result.url
    if (![string]::IsNullOrWhiteSpace($whUrl)) {
      WARN ("Webhook ACTIVE: " + $whUrl)
      $null = Invoke-RestMethod -Uri ("https://api.telegram.org/bot" + $token + "/setWebhook?url=") -Method Get -TimeoutSec 20
      OK "Webhook disabled"
    } else {
      OK "Webhook not set"
    }
  } catch {
    WARN ("Webhook check failed: " + $_.Exception.Message)
  }

  Step 7 8 "Install/build and start bot"
  Push-Location $appDir
  npm install --no-fund --no-audit | Out-Null
  npm run build | Out-Null

  if (Test-Path $stdoutLog) { Remove-Item $stdoutLog -Force -ErrorAction SilentlyContinue }
  if (Test-Path $stderrLog) { Remove-Item $stderrLog -Force -ErrorAction SilentlyContinue }

  $proc = Start-Process -FilePath "node" -ArgumentList "dist/index.js" -WorkingDirectory $appDir -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -PassThru
  $proc.Id | Out-File -FilePath $pidFile -Encoding ASCII -Force
  Pop-Location
  OK ("Bot started. PID=" + $proc.Id)

  Step 8 8 "Finish"
  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Green
  Write-Host ("DONE: " + $stageId + " SUCCESS | Duration: " + [math]::Round($sw.Elapsed.TotalSeconds,2) + "s") -ForegroundColor Green
  Write-Host ("PID: " + $proc.Id) -ForegroundColor Yellow
  Write-Host "حالا در تلگرام /start را بزنید." -ForegroundColor Cyan
  Write-Host "----------------------------------------" -ForegroundColor Green
}
catch {
  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Red
  Write-Host ("DONE: " + $stageId + " FAILED | Duration: " + [math]::Round($sw.Elapsed.TotalSeconds,2) + "s") -ForegroundColor Red
  Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("Transcript: " + $transcript) -ForegroundColor Yellow
  Write-Host "----------------------------------------" -ForegroundColor Red
  throw
}
finally {
  Stop-Transcript | Out-Null
}
