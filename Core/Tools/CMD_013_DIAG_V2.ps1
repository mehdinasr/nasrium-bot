$ErrorActionPreference = "Stop"

$stageId = "CMD_013_DIAG_V2"
$root = "D:\NASRIUM"
$appDir = "D:\NASRIUM\Apps\telegram-bot"
$logsDir = "D:\NASRIUM\Core\Logs"
$pidFile = Join-Path $logsDir "telegram-bot.pid"
$stdoutLog = Join-Path $logsDir "telegram-bot_stdout.log"
$stderrLog = Join-Path $logsDir "telegram-bot_stderr.log"
$envPath = Join-Path $appDir ".env"

function Step($msg){ Write-Host "==> $msg" -ForegroundColor Cyan }
function OK($msg){ Write-Host "OK  - $msg" -ForegroundColor Green }
function WARN($msg){ Write-Host "WARN- $msg" -ForegroundColor Yellow }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NASRIUM - CMD_013_DIAG_V2" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Step "Check app folder"
if (!(Test-Path $appDir)) { throw "App folder not found: $appDir" }
OK "App folder exists"

Step "Check PID file + process"
if (Test-Path $pidFile) {
  $botPidStr = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
  OK "PID file exists: $pidFile (PID=$botPidStr)"

  if ($botPidStr -match '^\d+$') {
    $botPid = [int]$botPidStr
    $p = Get-Process -Id $botPid -ErrorAction SilentlyContinue
    if ($p) {
      OK "Process is running: Name=$($p.ProcessName) Id=$($p.Id)"
    } else {
      WARN "PID in file but process is NOT running (crashed or stopped)"
    }
  } else {
    WARN "PID file content is not numeric"
  }
} else {
  WARN "PID file not found (bot likely not running)"
}

Step "Check .env existence + BOT_TOKEN length (token will NOT be printed)"
if (Test-Path $envPath) {
  $lines = Get-Content $envPath -Encoding UTF8
  $btLine = ($lines | Where-Object { $_ -match '^BOT_TOKEN=' } | Select-Object -First 1)

  if ($btLine) {
    $botToken = $btLine.Substring("BOT_TOKEN=".Length).Trim()
    OK "Found BOT_TOKEN line. Length=$($botToken.Length)"
  } else {
    WARN "BOT_TOKEN line not found in .env"
  }
} else {
  WARN ".env not found: $envPath"
}

Step "Tail STDOUT log (last 60 lines)"
if (Test-Path $stdoutLog) {
  OK "STDOUT log exists: $stdoutLog"
  Get-Content $stdoutLog -Tail 60
} else {
  WARN "STDOUT log not found: $stdoutLog"
}

Step "Tail STDERR log (last 200 lines) [IMPORTANT]"
if (Test-Path $stderrLog) {
  OK "STDERR log exists: $stderrLog"
  Get-Content $stderrLog -Tail 200
} else {
  WARN "STDERR log not found: $stderrLog"
}

Step "Check Telegram Webhook status (if token exists in .env)"
if ($botToken -and $botToken.Length -gt 20) {
  try {
    $url = "https://api.telegram.org/bot$botToken/getWebhookInfo"
    $info = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 20
    $whUrl = $info.result.url
    $pending = $info.result.pending_update_count
    if ([string]::IsNullOrWhiteSpace($whUrl)) {
      OK "Webhook: NOT set (good for long polling). Pending updates=$pending"
    } else {
      WARN "Webhook: ACTIVE -> $whUrl  (This can block getUpdates). Pending updates=$pending"
    }
  } catch {
    WARN "Could not query getWebhookInfo: $($_.Exception.Message)"
  }
} else {
  WARN "Token not available for webhook check (BOT_TOKEN missing?)"
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "DONE: CMD_013_DIAG_V2 SUCCESS" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Green
