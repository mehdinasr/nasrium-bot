# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_094
# File ID   : CMD_094_001
# Module    : Chat
# Component : Chat Moderation Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Load Orchestrator (if exists, per Constitution)
$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ModerationEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM CHAT MODERATION ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_094" -ForegroundColor Yellow
    Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $ModuleFile = "$ModuleDir\NSM_ChatModerator.psm1"
    $MetadataDir = "$Root\Data\Metadata"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $MetadataDir)) { New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null }

    # Step 1: Build Moderator Module
    Write-Host "[CMD_094] Building NSM_ChatModerator.psm1..." -ForegroundColor Cyan
    $ModuleLines = @(
        'function Verify-NSMChatMessage {',
        '    param([string]$Message)',
        '    $Blacklist = @("spam", "scam", "hack")',
        '    $Result = [ordered]@{ Status = "PASS"; Reason = ""; Severity = 0 }',
        '    foreach ($Word in $Blacklist) {',
        '        if ($Message -match $Word) {',
        '            $Result.Status = "BLOCKED"',
        '            $Result.Reason = "BlacklistedWordDetected"',
        '            $Result.Severity = 10',
        '            break',
        '        }',
        '    }',
        '    return [PSCustomObject]$Result',
        '}',
        '',
        'Export-ModuleMember -Function Verify-NSMChatMessage'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Moderator Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to build Moderator Module: $_"
    }

    # Step 2: Unit Test Moderator
    Write-Host "[CMD_094] Running Unit Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ChatModerator -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $TestPass = Verify-NSMChatMessage -Message "Hello Nasrium"
        if ($TestPass.Status -ne "PASS") { throw "Unit Test PASS failed." }
        
        $TestBlock = Verify-NSMChatMessage -Message "This is spam"
        if ($TestBlock.Status -ne "BLOCKED") { throw "Unit Test BLOCK failed." }
        
        Write-Host "  [OK] Unit Tests Passed." -ForegroundColor Green
    } catch {
        throw "Moderator Unit Test Failed: $_"
    }

    # Step 3: Integration Test with Pipeline (CMD_093)
    Write-Host "[CMD_094] Running Integration Test with Pipeline..." -ForegroundColor Cyan
    try {
        $PipelineFile = "$ModuleDir\NSM_ChatPipeline.psm1"
        if (Test-Path $PipelineFile) {
            Remove-Module NSM_ChatPipeline -ErrorAction SilentlyContinue
            Import-Module $PipelineFile -Force
            
            $IntegrationTest = Invoke-NSMChatModeration -Message " scam attempt "
            if ($IntegrationTest.Status -ne "BLOCKED") { throw "Integration Test failed." }
            
            Write-Host "  [OK] Integration Test Passed." -ForegroundColor Green
        } else {
            Write-Host "  [WARN] Pipeline module not found, skipping integration." -ForegroundColor Yellow
        }
    } catch {
        throw "Integration Test Failed: $_"
    }

    # Step 4: Metadata & Registry
    Write-Host "[CMD_094] Sealing Metadata & Registry..." -ForegroundColor Cyan
    try {
        $Hash = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash
        $Validation = [ordered]@{
            Command = "CMD_094"
            SHA256  = $Hash
            Time    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $Validation | ConvertTo-Json | Set-Content "$MetadataDir\NSM_CHAT_MODERATION_VALIDATION_V1.json" -Encoding UTF8

        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_094_001"
            task = "Build Chat Moderation Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_095"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_094_001_state.json"), $state, [System.Text.Encoding]::UTF8)

        Write-Host "  [OK] Metadata Sealed." -ForegroundColor Green
    } catch {
        throw "Failed to seal metadata: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_094 MODERATION ENGINE DEPLOYED" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_094_COMPLETE" -ForegroundColor Green
}

# Execution Wrapper
if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_094" -Action { Build-ModerationEngine }
} else {
    Build-ModerationEngine
}
