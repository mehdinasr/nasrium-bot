# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_003
# File ID   : CMD_003_001
# Module    : Architecture
# Component : Constitutional Compliance Audit
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM ARCHITECTURAL COMPLIANCE AUDIT" -ForegroundColor Cyan
Write-Host "Command : CMD_003_001" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$ReportPath = Join-Path $Root "PPR_Reports\CMD_003_Architectural_Audit_Report.txt"
$RegistryPath = Join-Path $Root "Core\Registry"
$ScriptsPath = Join-Path $Root "Scripts"

$violations = @()

# --------------------------------------------------
# RULE CHECK 1: StrictMode in Scripts
# --------------------------------------------------
Get-ChildItem $ScriptsPath -Filter "*.ps1" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -notmatch "Set-StrictMode") {
        $violations += "Missing StrictMode in: $($_.Name)"
    }
}

# --------------------------------------------------
# RULE CHECK 2: ErrorActionPreference
# --------------------------------------------------
Get-ChildItem $ScriptsPath -Filter "*.ps1" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -notmatch "ErrorActionPreference") {
        $violations += "Missing ErrorActionPreference in: $($_.Name)"
    }
}

# --------------------------------------------------
# RULE CHECK 3: Duplicate CMD IDs
# --------------------------------------------------
$cmdNames = Get-ChildItem $ScriptsPath -Filter "CMD_*.ps1" | Select-Object -ExpandProperty Name
$duplicates = $cmdNames | Group-Object | Where-Object { $_.Count -gt 1 }

foreach ($dup in $duplicates) {
    $violations += "Duplicate Command File: $($dup.Name)"
}

# --------------------------------------------------
# RULE CHECK 4: Registry State Integrity
# --------------------------------------------------
Get-ChildItem $RegistryPath -Filter "*_state.json" | ForEach-Object {
    $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if (-not $json.status) {
        $violations += "State missing status field: $($_.Name)"
    }
}

# --------------------------------------------------
# Generate Report
# --------------------------------------------------
$report = @()
$report += "NASRIUM SDPA CONSTITUTION AUDIT REPORT"
$report += "Generated: $(Get-Date)"
$report += "========================================="

if ($violations.Count -eq 0) {
    $report += "No violations detected."
    Write-Host "✅ Constitution Compliance: PASSED" -ForegroundColor Green
}
else {
    $report += "Violations detected:"
    $violations | ForEach-Object { $report += " - $_" }
    Write-Host "⚠ Violations detected. See report." -ForegroundColor Yellow
}

$report | Set-Content $ReportPath -Encoding UTF8

Write-Host "Audit Report Saved:"
Write-Host $ReportPath -ForegroundColor Cyan

Write-Host ""
Write-Host "CMD_003_001 AUDIT COMPLETE" -ForegroundColor Green
