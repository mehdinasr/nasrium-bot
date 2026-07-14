param(
  [Parameter(Position=0)]
  [ValidateSet("status","backup","export","help")]
  [string]$Command = "help"
)

$ErrorActionPreference = "Stop"
$root = "D:\NASRIUM"
$core = Join-Path $root "Core"
$knowledge = Join-Path $core "Knowledge"
$logs = Join-Path $core "Logs"
$reports = Join-Path $core "Reports"
$adr = Join-Path $core "ADR"
$backups = Join-Path $core "Backups"
$archive = Join-Path $core "Archive"

$contextPath = Join-Path $knowledge "NASRIUM_CONTEXT.json"
$handoverPath = Join-Path $knowledge "AI_HANDOVER.md"
$bookPath = Join-Path $knowledge "PROJECT_BOOK.md"
$historyPath = Join-Path $reports "command_history.ndjson"

function Ensure-Folder($p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Path $p -Force | Out-Null } }
function NowTs(){ Get-Date -Format "yyyyMMdd_HHmmss" }
function NowDT(){ Get-Date -Format "yyyy-MM-dd HH:mm:ss" }

function Read-Context(){
  if(!(Test-Path $contextPath)){ throw "Context not found: $contextPath" }
  return (Get-Content $contextPath -Raw -Encoding UTF8 | ConvertFrom-Json)
}

function Archive-Context(){
  Ensure-Folder $archive
  if(Test-Path $contextPath){
    $arch = Join-Path $archive ("NASRIUM_CONTEXT_{0}.json" -f (NowTs))
    Copy-Item $contextPath $arch -Force
    return $arch
  }
  return $null
}

function Write-Context($ctx){
  $ctx.meta.last_update = (NowDT)
  ($ctx | ConvertTo-Json -Depth 50) | Out-File -FilePath $contextPath -Encoding UTF8 -Force
}

function Append-History($stageId,$result,$extra){
  Ensure-Folder $reports
  if(!(Test-Path $historyPath)){ New-Item -ItemType File -Path $historyPath -Force | Out-Null }
  $obj = [ordered]@{
    stage_id = $stageId
    time = (NowDT)
    machine = $env:COMPUTERNAME
    user = $env:USERNAME
    ps_version = $PSVersionTable.PSVersion.ToString()
    result = $result
    extra = $extra
  }
  ($obj | ConvertTo-Json -Depth 10 -Compress) | Out-File -FilePath $historyPath -Append -Encoding UTF8
}

function Cmd-Status(){
  $ctx = Read-Context
  Write-Host "NASRIUM STATUS" -ForegroundColor Cyan
  Write-Host ("Project : {0} ({1})" -f $ctx.meta.project_name, $ctx.meta.token_symbol)
  Write-Host ("Version : {0}" -f $ctx.meta.version)
  Write-Host ("Status  : {0}" -f $ctx.meta.status)
  Write-Host ("Last    : {0} @ {1}" -f $ctx.state.last_stage_id, $ctx.state.last_stage_time)
  Write-Host ("Next    : {0}" -f $ctx.state.next_action) -ForegroundColor Yellow
  Write-Host ("Context : {0}" -f $contextPath)
  Write-Host ("Handover: {0}" -f $handoverPath)
  Write-Host ("Book    : {0}" -f $bookPath)
  Append-History "NOS_status" "SUCCESS" @{ next_action = $ctx.state.next_action }
}

function Cmd-Backup(){
  Ensure-Folder $backups
  $ts = NowTs
  $zipPath = Join-Path $backups ("NASRIUM_CORE_BACKUP_{0}.zip" -f $ts)

  # فایل‌هایی که حتماً باید داخل بکاپ باشند
  $include = @(
    (Join-Path $core "Knowledge"),
    (Join-Path $core "ADR"),
    (Join-Path $core "Reports")
  ) | Where-Object { Test-Path $_ }

  if($include.Count -eq 0){ throw "Nothing to backup. Core folders not found." }

  if(Test-Path $zipPath){ Remove-Item $zipPath -Force }

  Compress-Archive -Path $include -DestinationPath $zipPath -Force
  Write-Host ("BACKUP CREATED: {0}" -f $zipPath) -ForegroundColor Green

  $ctx = Read-Context
  $ctx.state.last_stage_id = "NOS_backup"
  $ctx.state.last_stage_time = (NowDT)
  $ctx.state.last_action = "Created Core backup zip"
  Write-Context $ctx

  Append-History "NOS_backup" "SUCCESS" @{ zip = $zipPath }
}

function Cmd-Export(){
  Ensure-Folder $backups
  $ts = NowTs
  $exportZip = Join-Path $backups ("NASRIUM_EXPORT_{0}.zip" -f $ts)
  $continueTxt = Join-Path $backups ("CONTINUE_IN_NEW_CHAT_{0}.txt" -f $ts)

  $ctxRaw = Get-Content $contextPath -Raw -Encoding UTF8

  $exportText = @"
NASRIUM - CONTINUE PACKAGE

1) Attach/Provide these files from your disk:
- $contextPath
- $handoverPath
- $bookPath
- Latest transcript in: $logs

2) Paste this JSON first in the new chat:
$ctxRaw

3) Then say:
"Read the context JSON and continue from state.next_action"
"@

  $exportText | Out-File -FilePath $continueTxt -Encoding UTF8 -Force

  $include = @(
    (Join-Path $core "Knowledge"),
    (Join-Path $core "ADR"),
    (Join-Path $core "Reports"),
    $continueTxt
  ) | Where-Object { Test-Path $_ }

  if(Test-Path $exportZip){ Remove-Item $exportZip -Force }
  Compress-Archive -Path $include -DestinationPath $exportZip -Force

  Write-Host ("EXPORT CREATED: {0}" -f $exportZip) -ForegroundColor Green
  Write-Host ("CONTINUE FILE : {0}" -f $continueTxt) -ForegroundColor Yellow

  $ctx = Read-Context
  $ctx.state.last_stage_id = "NOS_export"
  $ctx.state.last_stage_time = (NowDT)
  $ctx.state.last_action = "Created export zip + continue instructions"
  Write-Context $ctx

  Append-History "NOS_export" "SUCCESS" @{ export_zip = $exportZip; continue_file = $continueTxt }
}

function Cmd-Help(){
  Write-Host "NASRIUM NOS TOOL" -ForegroundColor Cyan
  Write-Host "Usage:"
  Write-Host "  powershell -ExecutionPolicy Bypass -File D:\NASRIUM\nos.ps1 status"
  Write-Host "  powershell -ExecutionPolicy Bypass -File D:\NASRIUM\nos.ps1 backup"
  Write-Host "  powershell -ExecutionPolicy Bypass -File D:\NASRIUM\nos.ps1 export"
}

Ensure-Folder $logs
Ensure-Folder $reports

try {
  switch ($Command) {
    "status" { Cmd-Status }
    "backup" { Cmd-Backup }
    "export" { Cmd-Export }
    default  { Cmd-Help }
  }
}
catch {
  Write-Host ("ERROR: {0}" -f $_.Exception.Message) -ForegroundColor Red
  Append-History ("NOS_" + $Command) "FAILED" @{ error = $_.Exception.Message }
  throw
}
