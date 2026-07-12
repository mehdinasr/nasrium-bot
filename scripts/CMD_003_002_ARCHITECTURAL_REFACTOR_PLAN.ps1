# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_003
# File ID   : CMD_003_002
# Module    : Architecture
# Component : Refactor Planning Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM ARCHITECTURAL REFACTOR PLAN" -ForegroundColor Cyan
Write-Host "Command : CMD_003_002" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$AuditReport = Join-Path $Root "PPR_Reports\CMD_003_Architectural_Audit_Report.txt"
$PlanPath = Join-Path $Root "PPR_Reports\CMD_003_Refactor_Plan.txt"

if (!(Test-Path $AuditReport)) {
    throw "Audit report not found. CMD_003_001 must run first."
}

$lines = Get-Content $AuditReport

$plan = @()
$plan += "NASRIUM SDPA REFACTOR PLAN"
$plan += "Generated: $(Get-Date)"
$plan += "========================================="

foreach ($line in $lines) {

    if ($line -like "*Missing StrictMode*") {
        $plan += ""
        $plan += "Violation: $line"
        $plan += "Rule: 23 (StrictMode mandatory)"
        $plan += "Severity: HIGH"
        $plan += "Action: Add Set-StrictMode -Version Latest at script start."
    }

    if ($line -like "*Missing ErrorActionPreference*") {
        $plan += ""
        $plan += "Violation: $line"
        $plan += "Rule: 24 (ErrorActionPreference = Stop)"
        $plan += "Severity: HIGH"
        $plan += "Action: Add `$ErrorActionPreference = 'Stop' in header."
    }

    if ($line -like "*Duplicate Command File*") {
        $plan += ""
        $plan += "Violation: $line"
        $plan += "Rule: 36 (No duplicated scripts)"
        $plan += "Severity: CRITICAL"
        $plan += "Action: Consolidate duplicate commands and remove redundancy."
    }

    if ($line -like "*State missing status field*") {
        $plan += ""
        $plan += "Violation: $line"
        $plan += "Rule: 25 (Validation before completion)"
        $plan += "Severity: MEDIUM"
        $plan += "Action: Enforce state schema validation before writing state files."
    }
}

if ($plan.Count -le 3) {
    $plan += ""
    $plan += "No actionable violations found."
}

$plan | Set-Content $PlanPath -Encoding UTF8

Write-Host "Refactor Plan Generated:"
Write-Host $PlanPath -ForegroundColor Cyan

Write-Host ""
Write-Host "CMD_003_002 PLAN COMPLETE" -ForegroundColor Green
