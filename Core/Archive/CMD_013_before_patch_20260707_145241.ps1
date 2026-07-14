$ErrorActionPreference = "Stop"

$stageId = "CMD_013"
$root = "D:\NASRIUM"
$appDir = "D:\NASRIUM\Apps\telegram-bot"

$core = Join-Path $root "Core"
$logsDir = Join-Path $core "Logs"
$reportsDir = Join-Path $core "Reports"
$knowledgeDir = Join-Path $core "Knowledge"
$archiveDir = Join-Path $core "Archive"

$contextPath = Join-Path $knowledgeDir "NASRIUM_CONTEXT.json"
$historyPath = Join-Path $reportsDir "command_history.ndjson"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$transcript = Join-Path $logsDir "$stageId`_$ts.transcript.txt"
$cmdLog = Join-Path $logsDir "$stageId`_$ts.log.txt"

$pidFile = Join-Path $logsDir "telegram-bot.pid"
$stdoutLog = Join-Path $logsDir "telegram-bot_stdout.log"
$stderrLog = Join-Path $logsDir "telegram-bot_stderr.log"

function Step($i,$n,$msg){ Write-Host ("STEP {0}/{1} - {2}" -f $i,$n,$msg) -ForegroundColor Cyan }
function OK($msg){ Write-Host ("OK  - {0}" -f $msg) -ForegroundColor Green }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null
$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "NASRIUM - CMD_013 (Configure .env + Run bot)" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan

  Step 1 7 "Checking bot app folder exists"
  if (!(Test-Path $appDir)) { throw "App folder not found: $appDir (Run CMD_012_REPAIR first)" }
  OK "App folder exists"

  Step 2 7 "Stopping previous bot process if running (safe check)"
  if (Test-Path $pidFile) {
    $oldPid = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
    if ($oldPid -match '^\d+$') {
      $p = Get-Process -Id ([int]$oldPid) -ErrorAction SilentlyContinue
      if ($p -and $p.ProcessName -eq "node") {
        Stop-Process -Id $p.Id -Force
        OK "Stopped previous node process PID=$oldPid"
      } else {
        OK "PID file existed but no running node process found (ignored)"
      }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  } else {
    OK "No previous bot PID file"
  }

  Step 3 7 "Reading BOT_TOKEN securely and writing .env"
  Push-Location $appDir

  # Secure input (won't show token on screen)
  $secure = Read-Host "Paste your Telegram BOT_TOKEN (input hidden)" -AsSecureString
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  $token = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

  $token = ($token ?? "").Trim()
  if ([string]::IsNullOrWhiteSpace($token)) { throw "BOT_TOKEN is empty" }

  @(
    "BOT_TOKEN=$token"
    "NODE_ENV=development"
  ) | Out-File -FilePath (Join-Path $appDir ".env") -Encoding UTF8 -Force

  OK ".env written"

  Step 4 7 "Typecheck (tsc)"
  npm run typecheck
  OK "typecheck passed"

  Step 5 7 "Build (tsc -> dist/)"
  npm run build
  OK "build completed"

  Step 6 7 "Starting bot in background (node dist/index.js) + writing PID + logs"
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
  OK ("STDOUT log: {0}" -f $stdoutLog)
  OK ("STDERR log: {0}" -f $stderrLog)

  Pop-Location

  Step 7 7 "Updating context + history"
  New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
  if (Test-Path $contextPath) {
    Copy-Item $contextPath (Join-Path $archiveDir "NASRIUM_CONTEXT_$ts.json") -Force
    $ctx = Get-Content $contextPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ctx.meta.last_update = $now
    $ctx.state.last_stage_id = $stageId
    $ctx.state.last_stage_time = $now
    $ctx.state.last_action = "Created .env, built bot, started background process"
    $ctx.state.next_action = "CMD_014 - Add /start keyboard + basic game entrypoint + bot stop/start commands"
    ($ctx | ConvertTo-Json -Depth 50) | Out-File -FilePath $contextPath -Encoding UTF8 -Force

    if (!(Test-Path $historyPath)) { New-Item -ItemType File -Path $historyPath -Force | Out-Null }
    $hist = [ordered]@{
      stage_id = $stageId
      time = $now
      result = "SUCCESS"
      outputs = @{
        pid = $proc.Id
        pid_file = $pidFile
        stdout = $stdoutLog
        stderr = $stderrLog
        transcript = $transcript
      }
    }
    ($hist | ConvertTo-Json -Depth 10 -Compress) | Out-File -FilePath $historyPath -Append -Encoding UTF8
  }

  $sw.Stop()
  "SUCCESS $stageId $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $cmdLog -Encoding UTF8 -Force

  Write-Host "----------------------------------------" -ForegroundColor Green
  Write-Host ("DONE: {0} SUCCESS | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Green
  Write-Host ("Bot PID: {0}" -f $proc.Id) -ForegroundColor Gray
  Write-Host ("Stop with: Stop-Process -Id {0}" -f $proc.Id) -ForegroundColor Yellow
  Write-Host ("Or use PID file: {0}" -f $pidFile) -ForegroundColor Yellow
  Write-Host "----------------------------------------" -ForegroundColor Green
}
catch {
  $sw.Stop()
  "FAILED $stageId $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $($_.Exception.Message)" | Out-File -FilePath $cmdLog -Encoding UTF8 -Force
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
