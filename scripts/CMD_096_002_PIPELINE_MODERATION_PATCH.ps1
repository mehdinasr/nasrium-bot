# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_096
# File ID   : CMD_096_002
# Module    : Chat
# Component : Pipeline Moderation Integration Patch
# Version   : 1.1.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Patch-PipelineModeration {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PIPELINE MODERATION PATCH" -ForegroundColor Cyan
    Write-Host "Command   : CMD_096_002" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $PipelineFile = "$ModuleDir\NSM_ChatPipeline.psm1"

    Write-Host "[CMD_096_002] Patching NSM_ChatPipeline.psm1..." -ForegroundColor Cyan
    
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
        '    $Moderation = Invoke-NSMChatModeration -Message $Message',
        '    if ($Moderation.Status -eq "BLOCKED") {',
        '        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = $Moderation.Reason }',
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
        Write-Host "  [OK] Pipeline Patched with Moderation Logic." -ForegroundColor Green
    } catch {
        throw "Failed to patch Pipeline: $_"
    }

    Write-Host "[CMD_096_002] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_096_002"
            task = "Pipeline Moderation Integration Patch"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_098"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_096_002_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_096_002 PATCH COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_096_002_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_096_002" -Action { Patch-PipelineModeration }
} else {
    Patch-PipelineModeration
}
