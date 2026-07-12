# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_095
# File ID   : CMD_095_001
# Module    : Chat
# Component : Chat Configuration Schema Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Load Orchestrator
$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ChatConfigEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM CHAT CONFIG SCHEMA BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_095" -ForegroundColor Yellow
    Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Chat"
    $ConfigDir = "$Root\Core\Config"
    $MetadataDir = "$Root\Data\Metadata"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    if (!(Test-Path $MetadataDir)) { New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null }

    # Step 1: Generate Default Configuration JSON
    Write-Host "[CMD_095] Generating NSM_ChatConfig.json..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_ChatConfig.json"
    
    $ConfigContent = @(
        '{',
        '  "channels": [',
        '    "Global",',
        '    "Trade",',
        '    "Support"',
        '  ],',
        '  "max_message_length": 2000,',
        '  "moderation_strictness": "High",',
        '  "blacklist": [',
        '    "spam",',
        '    "scam",',
        '    "hack",',
        '    "malware"',
        '  ]',
        '}'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] ChatConfig.json Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Config JSON: $_"
    }

    # Step 2: Build Config Reader Module
    Write-Host "[CMD_095] Building NSM_ChatConfig.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $ModuleDir "NSM_ChatConfig.psm1"

    $ModuleLines = @(
        'function Get-NSMChatConfig {',
        '    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_ChatConfig.json"',
        '    if (!(Test-Path $ConfigPath)) { throw "Chat configuration file missing." }',
        '    return Get-Content $ConfigPath -Raw | ConvertFrom-Json',
        '}',
        '',
        'Export-ModuleMember -Function Get-NSMChatConfig'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] ChatConfig Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to build ChatConfig Module: $_"
    }

    # Step 3: Validation Test
    Write-Host "[CMD_095] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ChatConfig -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $Config = Get-NSMChatConfig
        
        if ($Config.max_message_length -ne 2000) { throw "Config read failed." }
        if ($Config.channels.Count -lt 1) { throw "Channels array empty." }
        if ($Config.moderation_strictness -ne "High") { throw "Strictness read failed." }
        
        Write-Host "  [OK] Config Module Reads JSON Successfully." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # Step 4: Metadata & Registry
    Write-Host "[CMD_095] Sealing Metadata & Registry..." -ForegroundColor Cyan
    try {
        $Hash = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash
        $Validation = [ordered]@{
            Command = "CMD_095"
            SHA256  = $Hash
            Time    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $Validation | ConvertTo-Json | Set-Content "$MetadataDir\NSM_CHAT_CONFIG_VALIDATION_V1.json" -Encoding UTF8

        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_095_001"
            task = "Build Chat Configuration Schema Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_096"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_095_001_state.json"), $state, [System.Text.Encoding]::UTF8)

        Write-Host "  [OK] Metadata Sealed." -ForegroundColor Green
    } catch {
        throw "Failed to seal metadata: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_095 CONFIG SCHEMA ENGINE DEPLOYED" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_095_COMPLETE" -ForegroundColor Green
}

# Execution Wrapper
if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_095" -Action { Build-ChatConfigEngine }
} else {
    Build-ChatConfigEngine
}
