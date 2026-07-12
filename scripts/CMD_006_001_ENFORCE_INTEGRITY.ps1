# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_006
# File ID   : CMD_006_001
# Module    : Governance
# Component : Integrity Enforcement Layer
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "ENFORCING GOVERNANCE INTEGRITY LAYER" -ForegroundColor Cyan
Write-Host "Command : CMD_006_001" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$OrchPath = Join-Path $Root "Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

$newOrch = @"
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000_002
# Component : Governance Orchestrator Engine
# Version   : 2.2.0 (Integrity Enforced)
# Status    : Production
# ================================================================================

`$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

`$Root = "D:\NASRIUM"
`$RegistryPath = Join-Path `$Root "Core\Registry"
`$LogsPath = Join-Path `$Root "Logs"
`$ValidatorPath = Join-Path `$Root "Core\Modules\System\NSM_GovernanceValidator.ps1"

function Write-OrchLog {
    param([string]`$Message)
    `$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    `$line = "[`$ts] [ORCHESTRATOR] `$Message"
    Add-Content -Path (Join-Path `$LogsPath "orchestrator.log") -Value `$line -Encoding UTF8
    Write-Host `$line -ForegroundColor Cyan
}

function Invoke-GovernanceValidation {
    if (!(Test-Path `$ValidatorPath)) {
        throw "Governance Validator module missing."
    }

    . `$ValidatorPath

    if (-not (Get-Command Test-NSMGovernanceIntegrity -ErrorAction SilentlyContinue)) {
        throw "Test-NSMGovernanceIntegrity function not found."
    }

    Write-OrchLog "Running Governance Integrity Check..."
    `$result = Test-NSMGovernanceIntegrity
    if (-not `$result) {
        throw "Governance integrity validation failed."
    }

    Write-OrchLog "Governance Integrity Verified."
}

function Repair-StalledCommands {
    `$states = Get-ChildItem `$RegistryPath -Filter "*_state.json"
    foreach (`$s in `$states) {
        `$json = Get-Content `$s.FullName -Raw | ConvertFrom-Json
        if (`$json.status -eq "IN_PROGRESS") {
            `$json.status = "FAILED"
            `$json.failed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
            `$json.failure_reason = "Crash Recovery"
            `$json | ConvertTo-Json -Depth 3 | Set-Content `$s.FullName -Encoding UTF8
            Write-OrchLog "RECOVERY: `$(`$s.Name) marked FAILED"
        }
    }
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

    Repair-StalledCommands
    Invoke-GovernanceValidation
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

Write-OrchLog "Governance Orchestrator Engine v2.2 Ready (Integrity Enforced)."
"@

$newOrch | Set-Content $OrchPath -Encoding UTF8

Write-Host ""
Write-Host "✅ CMD_006_001 COMPLETE" -ForegroundColor Green
Write-Host "Governance Integrity is now NON-BYPASSABLE." -ForegroundColor Yellow
