# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_098
# File ID   : CMD_098_002
# Module    : Chat
# Component : Chat System Integration Test (Null Check Patch)
# Version   : 1.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Invoke-ChatIntegrationTest {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM CHAT INTEGRATION TEST" -ForegroundColor Cyan
    Write-Host "Command   : CMD_098_002" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $MetadataDir = "$Root\Data\Metadata"
    $TestReportPath = "$MetadataDir\NSM_CHAT_INTEGRATION_TEST_V1.json"

    $ConfigModulePath = "$ModuleDir\NSM_ChatConfig.psm1"
    $ModeratorFile = "$ModuleDir\NSM_ChatModerator.psm1"
    $PipelineFile = "$ModuleDir\NSM_ChatPipeline.psm1"

    Write-Host "[CMD_098] Loading Chat Modules..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ChatPipeline, NSM_ChatModerator, NSM_ChatConfig -ErrorAction SilentlyContinue
        Import-Module $ConfigModulePath -Force
        Import-Module $ModeratorFile -Force
        Import-Module $PipelineFile -Force
        Write-Host "  [OK] Modules Loaded." -ForegroundColor Green
    } catch {
        throw "Failed to load modules: $_"
    }

    $TestResults = @()

    # Test 1: Invalid Channel
    Write-Host "[CMD_098] Running Test 1: Invalid Channel..." -ForegroundColor Cyan
    try {
        $Result1 = Send-NSMChatPipeline -Channel "InvalidChannel" -Message "Test"
        if ($Result1.Reason -ne "InvalidChannel") { throw "Unexpected result." }
        $TestResults += [ordered]@{ Test = "InvalidChannel"; Status = "PASSED"; Detail = $Result1.Reason }
        Write-Host "  [OK] Test 1 Passed." -ForegroundColor Green
    } catch {
        $TestResults += [ordered]@{ Test = "InvalidChannel"; Status = "FAILED"; Detail = $_.Exception.Message }
        Write-Host "  [FAIL] Test 1 Failed." -ForegroundColor Red
    }

    # Test 2: Blacklisted Word
    Write-Host "[CMD_098] Running Test 2: Blacklisted Word..." -ForegroundColor Cyan
    try {
        $Result2 = Send-NSMChatPipeline -Channel "Global" -Message "this is a scam"
        if ($Result2.Status -ne "REJECTED" -or $Result2.Reason -ne "BlacklistedWordDetected") { throw "Unexpected result." }
        $TestResults += [ordered]@{ Test = "BlacklistedWord"; Status = "PASSED"; Detail = $Result2.Reason }
        Write-Host "  [OK] Test 2 Passed." -ForegroundColor Green
    } catch {
        $TestResults += [ordered]@{ Test = "BlacklistedWord"; Status = "FAILED"; Detail = $_.Exception.Message }
        Write-Host "  [FAIL] Test 2 Failed." -ForegroundColor Red
    }

    # Test 3: Valid Message
    Write-Host "[CMD_098] Running Test 3: Valid Message..." -ForegroundColor Cyan
    try {
        $Result3 = Send-NSMChatPipeline -Channel "Trade" -Message "Hello Nasrium Ecosystem"
        if ($Result3.Status -ne "DELIVERED") { throw "Unexpected result." }
        $TestResults += [ordered]@{ Test = "ValidMessage"; Status = "PASSED"; Detail = $Result3.Status }
        Write-Host "  [OK] Test 3 Passed." -ForegroundColor Green
    } catch {
        $TestResults += [ordered]@{ Test = "ValidMessage"; Status = "FAILED"; Detail = $_.Exception.Message }
        Write-Host "  [FAIL] Test 3 Failed." -ForegroundColor Red
    }

    # Save Test Report
    Write-Host "[CMD_098] Generating Test Report..." -ForegroundColor Cyan
    try {
        $Report = [ordered]@{
            Command = "CMD_098"
            Time    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Results = $TestResults
        }
        $Report | ConvertTo-Json -Depth 3 | Set-Content $TestReportPath -Encoding UTF8
        Write-Host "  [OK] Report Saved." -ForegroundColor Green
    } catch {
        throw "Failed to save report: $_"
    }

    # Verify all passed (Fixed StrictMode Null Check)
    $FailedTests = @($TestResults | Where-Object { $_.Status -eq "FAILED" })
    if ($FailedTests.Count -gt 0) {
        Write-Host "=========================================" -ForegroundColor Red
        Write-Host "   CMD_098 INTEGRATION TEST FAILED" -ForegroundColor Red
        Write-Host "=========================================" -ForegroundColor Red
        throw "Integration tests failed."
    }

    Write-Host "[CMD_098] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_098_002"
            task = "Chat System Integration Test"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_099"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_098_002_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_098 INTEGRATION TEST COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_098_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_098_002" -Action { Invoke-ChatIntegrationTest }
} else {
    Invoke-ChatIntegrationTest
}
