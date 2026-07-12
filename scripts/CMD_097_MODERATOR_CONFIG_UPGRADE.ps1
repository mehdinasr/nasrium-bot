# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_097
# File ID   : CMD_097_001
# Module    : Chat
# Component : Moderator Dynamic Config Upgrade
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Refactor-ModeratorConfig {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM MODERATOR DYNAMIC CONFIG UPGRADE" -ForegroundColor Cyan
    Write-Host "Command   : CMD_097" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $ModeratorFile = "$ModuleDir\NSM_ChatModerator.psm1"
    $ConfigModulePath = "$ModuleDir\NSM_ChatConfig.psm1"

    Write-Host "[CMD_097] Refactoring NSM_ChatModerator.psm1..." -ForegroundColor Cyan
    
    $ModeratorLines = @(
        'function Verify-NSMChatMessage {',
        '    param([string]$Message)',
        '    $Config = Get-NSMChatConfig',
        '    $Blacklist = $Config.blacklist',
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
        $ModuleContent = $ModeratorLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModeratorFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Moderator Module Refactored." -ForegroundColor Green
    } catch {
        throw "Failed to refactor Moderator: $_"
    }

    Write-Host "[CMD_097] Running Unit Test..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ChatModerator, NSM_ChatConfig -ErrorAction SilentlyContinue
        Import-Module $ConfigModulePath -Force
        Import-Module $ModeratorFile -Force
        
        $TestBlock = Verify-NSMChatMessage -Message "this is a scam"
        if ($TestBlock.Status -ne "BLOCKED") { throw "Blacklist validation failed." }

        $TestPass = Verify-NSMChatMessage -Message "Hello Nasrium"
        if ($TestPass.Status -ne "PASS") { throw "Clean message validation failed." }
        
        Write-Host "  [OK] Unit Test Passed." -ForegroundColor Green
    } catch {
        throw "Unit Test Failed: $_"
    }

    Write-Host "[CMD_097] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_097_001"
            task = "Moderator Dynamic Config Upgrade"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_098"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_097_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_097 MODERATOR UPGRADE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_097_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_097" -Action { Refactor-ModeratorConfig }
} else {
    Refactor-ModeratorConfig
}
