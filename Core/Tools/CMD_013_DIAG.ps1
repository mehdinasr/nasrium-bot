$ErrorActionPreference = "Stop"

$stageId = "CMD_013_DIAG"
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
Write-Host "NASRIUM - CMD_013_DIAG" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Step "Check app folder"
if (!(Test-Path $appDir)) { throw "App folder not found: $appDir" }
OK "App folder exists"

Step "Check PID file"
if (Test-Path $pidFile) {
  $pid = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
  OK "PID file exists: $pidFile (PID=$pid)"
  if ($pid -match '^\d+$') {
    $p = Get-Process -Id ([int]$pid) -ErrorAction SilentlyContinue
    if ($p) {
      OK "Process is running: Name=$($p.ProcessName) Id=$($p.Id)"
    } else {
      WARN "PID in file but process is NOT running"
    }
  } else {
    WARN "PID file content is not a number"
  }
} else {
  WARN "PID file not found (bot likely not running)"
}

Step "Check .env existence + BOT_TOKEN length (token will NOT be printed)"
if (Test-Path $envPath) {
  $lines = Get-Content $envPath -Encoding UTF8
  $bt = ($lines | Where-Object { $_ -match '^BOT_TOKEN=' } | Select-Object -First 1)
  if ($bt) {
    $token = $bt.Substring("BOT_TOKEN=".Length).Trim()
    OK "Found BOT_TOKEN line. Length=$($token.Length)"
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

Step "Tail STDERR log (last 120 lines) [IMPORTANT]"
if (Test-Path $stderrLog) {
  OK "STDERR log exists: $stderrLog"
  Get-Content $stderrLog -Tail 120
} else {
  WARN "STDERR log not found: $stderrLog"
}

Step "Find other node processes possibly running NASRIUM bot (conflict check)"
$procs = Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction SilentlyContinue
$hits = @()
foreach($pr in $procs){
  if ($pr.CommandLine -and $pr.CommandLine.ToLower().Contains("nasrium") -and $pr.CommandLine.ToLower().Contains("telegram-bot")) {
    $hits += $pr
  }
}
if ($hits.Count -gt 0) {
  WARN "Other node processes found (may cause Telegram 409 conflict):"
  $hits | Select-Object ProcessId, CommandLine | Format-List
} else {
  OK "No other NASRIUM telegram-bot node processes found"
}

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "DONE: CMD_013_DIAG SUCCESS" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Green
