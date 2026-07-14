# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_004
# File ID   : CMD_004_002
# Module    : Refactor
# Component : Orchestrator Crash Recovery Patch
# Version   : 2.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM ORCHESTRATOR RECOVERY PATCH" -ForegroundColor Cyan
Write-Host "Command : CMD_004_002" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$OrchPath = Join-Path $Root "Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

$newOrchCode = @"
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000_002
# Component : Governance Orchestrator Engine
# Version   : 2.1.0 (With Crash Recovery)
# Status    : Production
# ================================================================================

`$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

`$Root = "D:\NASRIUM"
`$RegistryPath = Join-Path `$Root "Core\Registry"
`$LogsPath = Join-Path `$Root "Logs"

function Write-OrchLog {
    param([string]`$Message)
    `$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    `$line = "[`$ts] [ORCHESTRATOR] `$Message"
    Add-Content -Path (Join-Path `$LogsPath "orchestrator.log") -Value `$line -Encoding UTF8
    Write-Host `$line -ForegroundColor Cyan
}

function Repair-StalledCommands {
    `$states = Get-ChildItem `$RegistryPath -Filter "*_state.json"
    foreach (`$s in `$states) {
        `$json = Get-Content `$s.FullName -Raw | ConvertFrom-Json
        if (`$json.status -eq "IN_PROGRESS") {
            `$json.status = "FAILED"
            `$json | Add-Member -NotePropertyName "failed_at" -NotePropertyValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -Force
            `$json | Add-Member -NotePropertyName "failure_reason" -NotePropertyValue "Crash Recovery: IN_PROGRESS converted to FAILED" -Force
            `$json | ConvertTo-Json -Depth 3 | Set-Content `$s.FullName -Encoding UTF8
            Write-OrchLog "RECOVERY: `$(`$s.Name) marked as FAILED (was stalled)"
        }
    }
}

function Get-LastCompletedCommand {
    `$states = Get-ChildItem `$RegistryPath -Filter "*_state.json" |
              Sort-Object LastWriteTime -Descending
    if (`$states.Count -eq 0) { return `$null }
    return (Get-Content `$states[0].FullName -Raw | ConvertFrom-Json)
}

function Validate-CommandSequence {
    param([string]`$NextCmd)

    Repair-StalledCommands

    `$last = Get-LastCompletedCommand
    if (`$null -eq `$last) { return }

    if (`$last.status -eq "COMPLETED") { 
        Write-OrchLog "Previous command: `$(`$last.cmd_id) [COMPLETED]"
        return
    }

    if (`$last.status -eq "FAILED") {
        Write-OrchLog "Previous command: `$(`$last.cmd_id) [FAILED - Retry Allowed]"
        return
    }

    throw "Unknown state: `$(`$last.status)"
}

function Register-CommandStart {
    param([string]`$CmdId)
    `$obj = @{
        cmd_id = `$CmdId
        status = "IN_PROGRESS"
        started_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    } | ConvertTo-Json -Depth 3
    Set-Content (Join-Path `$RegistryPath "`${CmdId}_state.json") `$obj -Encoding UTF8
}

function Register-CommandComplete {
    param([string]`$CmdId)
    `$obj = @{
        cmd_id = `$CmdId
        status = "COMPLETED"
        completed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    } | ConvertTo-Json -Depth 3
    Set-Content (Join-Path `$RegistryPath "`${CmdId}_state.json") `$obj -Encoding UTF8
}

function Invoke-NasriumCommand {
    param(
        [string]`$CmdId,
        [scriptblock]`$Action
    )

    Validate-CommandSequence -NextCmd `$CmdId
    Register-CommandStart -CmdId `$CmdId

    Write-OrchLog "Executing `$CmdId ..."

    try {
        & `$Action
        Register-CommandComplete -CmdId `$CmdId
        Write-OrchLog "`$CmdId completed successfully."
    }
    catch {
        `$failObj = @{
            cmd_id = `$CmdId
            status = "FAILED"
            failed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
            failure_reason = `$_.Exception.Message
        } | ConvertTo-Json -Depth 3
        Set-Content (Join-Path `$RegistryPath "`${CmdId}_state.json") `$failObj -Encoding UTF8
        Write-OrchLog "FAILED: `$CmdId - `$(`$_.Exception.Message)"
        throw
    }
}

Write-OrchLog "Governance Orchestrator Engine v2.1 Ready."
"@

$newOrchCode | Set-Content $OrchPath -Encoding UTF8

Write-Host ""
Write-Host "✅ CMD_004_002 ORCHESTRATOR PATCH COMPLETE" -ForegroundColor Green
Write-Host "Features Added:" -ForegroundColor Yellow
Write-Host "  [+] Crash Recovery (IN_PROGRESS -> FAILED)" -ForegroundColor Green
Write-Host "  [+] Retry After Failure" -ForegroundColor Green
Write-Host "  [+] Try/Catch in Invoke" -ForegroundColor Green
Write-Host "  [+] Failure Reason Logging" -ForegroundColor Green
