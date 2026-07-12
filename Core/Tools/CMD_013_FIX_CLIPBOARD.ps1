$ErrorActionPreference = "Stop"

$stageId = "CMD_013_FIX_CLIPBOARD"
$root = "D:\NASRIUM"
$appDir = "D:\NASRIUM\Apps\telegram-bot"

$core = Join-Path $root "Core"
$logsDir = Join-Path $core "Logs"
$pidFile = Join-Path $logsDir "telegram-bot.pid"
$stdoutLog = Join-Path $logsDir "telegram-bot_stdout.log"
$stderrLog = Join-Path $logsDir "telegram-bot_stderr.log"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$transcript = Join-Path $logsDir "$stageId`_$ts.transcript.txt"

function Step($i,$n,$msg){ Write-Host ("STEP {0}/{1} - {2}" -f $i,$n,$msg) -ForegroundColor Cyan }
function OK($msg){ Write-Host ("OK  - {0}" -f $msg) -ForegroundColor Green }
function WARN($msg){ Write-Host ("WARN- {0}" -f $msg) -ForegroundColor Yellow }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null
$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "NASRIUM - CMD_013_FIX_CLIPBOARD" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan

  Step 1 7 "Check bot app folder"
  if (!(Test-Path $appDir)) { throw "App folder not found: $appDir" }
  OK "App folder exists"

  Step 2 7 "Stop previous bot process (if PID exists)"
  if (Test-Path $pidFile) {
    $botPidStr = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
    if ($botPidStr -match '^\d+$') {
      $botPid = [int]$botPidStr
      $p = Get-Process -Id $botPid -ErrorAction SilentlyContinue
      if ($p -and $p.ProcessName -eq "node") {
        Stop-Process -Id $botPid -Force
        OK "Stopped old bot PID=$botPid"
      } else {
        OK "PID file existed but process not running"
      }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  } else {
    OK "No previous PID file"
  }

  Step 3 7 "Read BOT_TOKEN from Clipboard (token will not be printed)"
  $token = (Get-Clipboard -Raw)
  if ($null -eq $token) { $token = "" }
  $token = [string]$token
  $token = $token.Trim()

  # اعتبارسنجی: الگوی توکن تلگرام معمولاً "عدد:رشته"
  if ([string]::IsNullOrWhiteSpace($token)) { throw "Clipboard is empty. Copy token from BotFather first." }
  if ($token.Length -lt 35) { throw ("Token too short (len={0}). Copy the full token again." -f $token.Length) }
  if ($token -notmatch '^\d+:[A-Za-z0-9_-]{20,}$') { WARN "Token format not typical, but will continue." }

  # برای امنیت: کلیپبورد را خالی میکنیم
  Set-Clipboard -Value ""

  OK ("Token captured from clipboard. Length={0} (masked)" -f $token.Length)

  Step 4 7 "Write .env"
  @(
    "BOT_TOKEN=$token"
    "NODE_ENV=development"
  ) | Out-File -FilePath (Join-Path $appDir ".env") -Encoding UTF8 -Force
  OK ".env written"

  Step 5 7 "Disable webhook if active (allow long polling)"
  try {
    $info = Invoke-RestMethod -Uri ("https://api.telegram.org/bot{0}/getWebhookInfo" -f $token) -Method Get -TimeoutSec 20
    $whUrl = $info.result.url
    if (![string]::IsNullOrWhiteSpace($whUrl)) {
      WARN ("Webhook ACTIVE: {0}" -f $whUrl)
      $null = Invoke-RestMethod -Uri ("https://api.telegram.org/bot{0}/setWebhook?url=" -f $token) -Method Get -TimeoutSec 20
      OK "Webhook disabled"
    } else {
      OK "Webhook not set"
    }
  } catch {
    WARN ("Webhook check failed: {0}" -f $_.Exception.Message)
  }

  Step 6 7 "Install/build + start bot"
  Push-Location $appDir

  npm install --no-fund --no-audit | Out-Null
  OK "npm install ok"

  npm run build
  OK "build ok"

  if (Test-Path $stdoutLog) { Remove-Item $stdoutLog -Force -ErrorAction SilentlyContinue }
  if (Test-Path $stderrLog) { Remove-Item $stderrLog -Force -ErrorAction SilentlyContinue }

  $proc = Start-Process -FilePath "node" `
    -ArgumentList "dist/index.js" `
    -WorkingDirectory $appDir `
    -RedirectStandardOutput $stdoutLog `
    -RedirectStandardError $stderrLog `
    -PassThru

  $proc.Id | Out-File -FilePath $pidFile -Encoding ASCII -Force
  OK ("Bot started. PID={0}" -f $proc.Id)
  OK ("STDERR: {0}" -f $stderrLog)

  Pop-Location

  Step 7 7 "Final"
  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Green
  Write-Host ("DONE: {0} SUCCESS | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Green
  Write-Host ("Now test in Telegram: send /start") -ForegroundColor Yellow
  Write-Host "----------------------------------------" -ForegroundColor Green
}
catch {
  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Red
  Write-Host ("DONE: {0} FAILED | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Red
  Write-Host ("ERROR: {0}" -f $_.Exception.Message) -ForegroundColor Red
  Write-Host ("Transcript: {0}" -f $transcript) -ForegroundColor Yellow
  Write-Host "----------------------------------------" -ForegroundColor Red
  throw
}
finally {
  Pop-Location -ErrorAction SilentlyContinue
  Stop-Transcript | Out-Null
}
