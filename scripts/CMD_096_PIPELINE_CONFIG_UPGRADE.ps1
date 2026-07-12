# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_096
# File ID   : CMD_096_001
# Module    : Chat
# Component : Pipeline Dynamic Config Upgrade
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Refactor-PipelineConfig {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PIPELINE DYNAMIC CONFIG UPGRADE" -ForegroundColor Cyan
    Write-Host "Command   : CMD_096" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $PipelineFile = "$ModuleDir\NSM_ChatPipeline.psm1"
    $ConfigModulePath = "$ModuleDir\NSM_ChatConfig.psm1"

    Write-Host "[CMD_096] Refactoring NSM_ChatPipeline.psm1..." -ForegroundColor Cyan
    
    $PipelineLines = @(
        'function Process-NSMChatMessage {',
        '    param([string]$Message)',
        '    return [PSCustomObject]@{ Status = "RECEIVED"; Message = $Message; ProcessedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }',
        '}',
        '',
        'function Route-NSMChatMessage {',
        '    param([string]$Channel, [string]$Message)',
        '    return [PSCustomObject]@{ Channel = $Channel; Message = $Message; RouteStatus = "ACCEPTED"; RoutedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }',
        '}',
        '',
        'function Validate-NSMChatMessage {',
        '    param([string]$Message)',
        '    $Config = Get-NSMChatConfig',
        '    $MaxLength = $Config.max_message_length',
        '    $Result = [ordered]@{ Valid = $true; Length = $Message.Length; Reason = "" }',
        '    if ([string]::IsNullOrWhiteSpace($Message)) { $Result.Valid = $false; $Result.Reason = "EmptyMessage" }',
        '    elseif ($Message.Length -gt $MaxLength) { $Result.Valid = $false; $Result.Reason = "MaximumLengthExceeded" }',
        '    return [PSCustomObject]$Result',
        '}',
        '',
        'function Invoke-NSMChatModeration {',
        '    param([string]$Message)',
        '    $ModeratorPath = "D:\NASRIUM\Core\Modules\Chat\NSM_ChatModerator.psm1"',
        '    if (Test-Path $ModeratorPath) {',
        '        Import-Module $ModeratorPath -Force',
        '        return Verify-NSMChatMessage -Message $Message',
        '    }',
        '    return [PSCustomObject]@{ Status = "SKIPPED"; Reason = "ModeratorModuleNotFound" }',
        '}',
        '',
        'function Send-NSMChatPipeline {',
        '    param([string]$Channel, [string]$Message)',
        '    $Config = Get-NSMChatConfig',
        '    if ($Config.channels -notcontains $Channel) {',
        '        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = "InvalidChannel" }',
        '    }',
        '    $Validation = Validate-NSMChatMessage -Message $Message',
        '    if ($Validation.Valid -eq $false) {',
        '        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = $Validation.Reason }',
        '    }',
        '    $Route = Route-NSMChatMessage -Channel $Channel -Message $Message',
        '    return [PSCustomObject]@{ Status = "DELIVERED"; Channel = $Route.Channel; Message = $Route.Message; Time = $Route.RoutedTime }',
        '}',
        '',
        'Export-ModuleMember -Function Process-NSMChatMessage, Route-NSMChatMessage, Validate-NSMChatMessage, Invoke-NSMChatModeration, Send-NSMChatPipeline'
    )

    try {
        $ModuleContent = $PipelineLines -join "`r`n"
        [System.IO.File]::WriteAllText($PipelineFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Pipeline Module Refactored." -ForegroundColor Green
    } catch {
        throw "Failed to refactor Pipeline: $_"
    }

    Write-Host "[CMD_096] Running Unit Test..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ChatPipeline, NSM_ChatConfig -ErrorAction SilentlyContinue
        Import-Module $ConfigModulePath -Force
        Import-Module $PipelineFile -Force
        
        $TestReject = Send-NSMChatPipeline -Channel "InvalidChannel" -Message "Test"
        if ($TestReject.Reason -ne "InvalidChannel") { throw "Channel validation failed." }
        
        Write-Host "  [OK] Unit Test Passed." -ForegroundColor Green
    } catch {
        throw "Unit Test Failed: $_"
    }

    Write-Host "[CMD_096] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_096_001"
            task = "Pipeline Dynamic Config Upgrade"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_097"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_096_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_096 PIPELINE UPGRADE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_096_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_096" -Action { Refactor-PipelineConfig }
} else {
    Refactor-PipelineConfig
}
