$ErrorActionPreference="Stop"
$stageId="CMD_018B_HARDPATCH"

$root="D:\NASRIUM"
$core=Join-Path $root "Core"
$archive=Join-Path $core "Archive"
$nos=Join-Path $root "nos.ps1"

$ts=Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Path $archive -Force | Out-Null
$bak=Join-Path $archive ("nos_before_{0}_{1}.ps1" -f $stageId,$ts)

function Step($m){ Write-Host ("==> {0}" -f $m) -ForegroundColor Cyan }
function OK($m){ Write-Host ("OK  - {0}" -f $m) -ForegroundColor Green }

Step "Backup nos.ps1"
if(!(Test-Path $nos)){ throw "nos.ps1 not found: $nos" }
Copy-Item $nos $bak -Force
OK ("Backup: {0}" -f $bak)

Step "Force replace ValidateSet line"
$lines = Get-Content $nos -Encoding UTF8

$replaced = $false
for ($i=0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '^\s*\[ValidateSet\(') {
    $lines[$i] = '  [ValidateSet("status","backup","export","bot-status","bot-start","bot-stop","bot-restart","help")]'
    $replaced = $true
    break
  }
}

if (-not $replaced) { throw "ValidateSet line not found (unexpected)" }

$lines | Out-File -FilePath $nos -Encoding UTF8 -Force
OK "ValidateSet updated"

Step "Show ValidateSet line"
Select-String -Path $nos -Pattern "ValidateSet" | ForEach-Object { $_.Line } | Write-Host

Write-Host "======================================" -ForegroundColor Green
Write-Host "CMD_018B_HARDPATCH SUCCESS" -ForegroundColor Green
Write-Host "Backup: $bak" -ForegroundColor Gray
Write-Host "======================================" -ForegroundColor Green
