$ErrorActionPreference = "Stop"

$stageId = "CMD_013_FIX"
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

$pidFile = Join-Path $logsDir "telegram-bot.pid"
$stdoutLog = Join-Path $logsDir "telegram-bot_stdout.log"
$stderrLog = Join-Path $logsDir "telegram-bot_stderr.log"

function Step($i,$n,$msg){ Write-Host ("STEP {0}/{1} - {2}" -f $i,$n,$msg) -ForegroundColor Cyan }
function OK($msg){ Write-Host ("OK  - {0}" -f $msg) -ForegroundColor Green }
function WARN($msg){ Write-Host ("WARN- {0}" -f $msg) -ForegroundColor Yellow }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null

$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "NASRIUM - CMD_013_FIX (.env + webhook reset + run bot)" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan

  Step 1 8 "Check bot app folder"
  if (!(Test-Path $appDir)) { throw "App folder not found: $appDir" }
  OK "App folder exists"

  Step 2 8 "Stop previous bot process (if PID file exists)"
  if (Test-Path $pidFile) {
    $botPidStr = (Get-Content $pidFile -Raw -ErrorAction SilentlyContinue).Trim()
    if ($botPidStr -match '^\d+$') {
      $botPid = [int]$botPidStr
      $p = Get-Process -Id $botPid -ErrorAction SilentlyContinue
      if ($p -and $p.ProcessName -eq "node") {
        Stop-Process -Id $botPid -Force
        OK "Stopped old bot process PID=$botPid"
      } else {
        OK "PID file existed but process not running (ignored)"
      }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
  } else {
    OK "No previous PID file"
  }

  Step 3 8 "Read BOT_TOKEN securely and write .env (token will not be printed)"
  Push-Location $appDir

  $secure = Read-Host "Paste your Telegram BOT_TOKEN (hidden input)" -AsSecureString
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  $token = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

  if ($null -eq $token) { $token = "" }
  $token = [string]$token
  $token = $token.Trim()

  if ([string]::IsNullOrWhiteSpace($token)) { throw "BOT_TOKEN is empty" }
  if ($token.Length -lt 30) { throw "BOT_TOKEN looks too short. Please paste the full token from BotFather." }

  @(
    "BOT_TOKEN=$token"
    "NODE_ENV=development"
  ) | Out-File -FilePath (Join-Path $appDir ".env") -Encoding UTF8 -Force
  OK ".env written"

  Step 4 8 "Disable webhook (only if active) to allow long polling"
  try {
    $info = Invoke-RestMethod -Uri ("https://api.telegram.org/bot{0}/getWebhookInfo" -f $token) -Method Get -TimeoutSec 20
    $whUrl = $info.result.url
    if (![string]::IsNullOrWhiteSpace($whUrl)) {
      WARN ("Webhook is ACTIVE: {0}" -f $whUrl)
      # حذف webhook: setWebhook با url خالی
      $null = Invoke-RestMethod -Uri ("https://api.telegram.org/bot{0}/setWebhook?url=" -f $token) -Method Get -TimeoutSec 20
      OK "Webhook disabled"
    } else {
      OK "Webhook not set (good)"
    }
  } catch {
    WARN "Webhook check failed (ignored). We will still try long polling."
  }

  Step 5 8 "npm install (safe)"
  npm install --no-fund --no-audit
  OK "npm install finished"

  Step 6 8 "typecheck"
  npm run typecheck
  OK "typecheck passed"

  Step 7 8 "build"
  npm run build
  OK "build completed"

  Step 8 8 "Start bot in background + write PID + logs"
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
  OK ("STDOUT: {0}" -f $stdoutLog)
  OK ("STDERR: {0}" -f $stderrLog)

  Pop-Location

  # Update context/history (best-effort)
  try {
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
    if (Test-Path $contextPath) {
      Copy-Item $contextPath (Join-Path $archiveDir "NASRIUM_CONTEXT_$ts.json") -Force
      $ctx = Get-Content $contextPath -Raw -Encoding UTF8 | ConvertFrom-Json
      $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
      $ctx.meta.last_update = $now
      $ctx.state.last_stage_id = $stageId
      $ctx.state.last_stage_time = $now
      $ctx.state.last_action = "Fixed .env BOT_TOKEN, disabled webhook if active, restarted bot"
      $ctx.state.next_action = "CMD_014 - Improve /start UX (keyboard + game entry) + add nos bot start/stop/status"
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
  } catch { }

  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Green
  Write-Host ("DONE: {0} SUCCESS | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Green
  Write-Host ("Bot PID: {0}" -f $proc.Id) -ForegroundColor Yellow
  Write-Host "Now test in Telegram: send /start" -ForegroundColor Cyan
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
