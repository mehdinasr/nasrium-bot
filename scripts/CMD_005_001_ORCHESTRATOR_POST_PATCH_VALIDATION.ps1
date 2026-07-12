# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_005
# File ID   : CMD_005_001
# Module    : Governance
# Component : Orchestrator Post-Patch Validation (Functional)
# Version   : 2.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "========================================="
Write-Host "ORCHESTRATOR FUNCTIONAL VALIDATION"
Write-Host "========================================="

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (!(Test-Path $OrchPath)) { throw "Orchestrator not found." }

# Load Orchestrator
. $OrchPath

# Execute a dry-run test command
Invoke-NasriumCommand -CmdId "CMD_TEST_VALIDATION" -Action {
    Write-Host "Test execution"
}

$statePath = "D:\NASRIUM\Core\Registry\CMD_TEST_VALIDATION_state.json"

if (!(Test-Path $statePath)) {
    throw "State file was not created correctly."
}

Write-Host "✅ ORCHESTRATOR FUNCTIONAL VALIDATION PASSED (v2.1 STABLE)"
