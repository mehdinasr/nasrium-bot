$ErrorActionPreference = "Stop"

$stageId = "TEST_012_TYPECHECK"
$root = "D:\NASRIUM"
$appDir = "D:\NASRIUM\Apps\telegram-bot"
$logsDir = "D:\NASRIUM\Core\Logs"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$transcript = Join-Path $logsDir "$stageId`_$ts.transcript.txt"

function Step($msg){ Write-Host "==> $msg" -ForegroundColor Cyan }
function OK($msg){ Write-Host "OK  - $msg" -ForegroundColor Green }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null

$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "NASRIUM - $stageId" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan

  Step "Checking app folder exists: $appDir"
  if (!(Test-Path $appDir)) { throw "App folder not found: $appDir" }
  OK "App folder exists"

  Step "Checking required files"
  if (!(Test-Path (Join-Path $appDir "package.json"))) { throw "package.json not found" }
  if (!(Test-Path (Join-Path $appDir "src\index.ts"))) { throw "src\index.ts not found" }
  OK "Required files exist"

  Step "Installing dependencies (only if node_modules missing)"
  Push-Location $appDir
  if (!(Test-Path (Join-Path $appDir "node_modules"))) {
    npm install --no-fund --no-audit
    OK "npm install finished"
  } else {
    OK "node_modules already exists (skip install)"
  }

  Step "Running TypeScript typecheck"
  npm run typecheck
  OK "typecheck passed"

  $sw.Stop()
  Write-Host "----------------------------------------" -ForegroundColor Green
  Write-Host ("DONE: {0} SUCCESS | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Green
  Write-Host ("Transcript: {0}" -f $transcript) -ForegroundColor Gray
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
