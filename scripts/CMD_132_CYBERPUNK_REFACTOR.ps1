# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_132
# File ID   : CMD_132_001
# Module    : Game
# Component : Cyberpunk Theme Code Refactor
# Version   : 1.0.1 (Hotfix)
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Refactor-CyberpunkTheme {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM CYBERPUNK THEME REFACTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_132" -ForegroundColor Yellow
    Write-Host "Status    : REFACTORING DOMAINS & CONFIGS" -ForegroundColor Magenta
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = Join-Path $Root "Core\Modules\Game"
    $ConfigDir = Join-Path $Root "Core\Config"

    # ---------------------------------------------------------
    # PHASE 1: Refactor Game Domain (Business Logic Objects)
    # ---------------------------------------------------------
    
    Write-Host "[CMD_132] Refactoring NSM_GameDomain.psm1..." -ForegroundColor Cyan
    
    if (!(Test-Path $GameDir)) { New-Item -ItemType Directory -Path $GameDir -Force | Out-Null }

    $DomainFile = Join-Path $GameDir "NSM_GameDomain.psm1"
    $DomainLines = @(
        '<#',
        '  NASRIUM GAME DOMAIN MODULE v2.0 (Cyberpunk Edition)',
        '  Defines core objects: Player, Resource, Building, Syndicate.',
        '#>',
        '',
        'function New-NSMPlayer {',
        '    param([string]$Username)',
        '    return [PSCustomObject]@{',
        '        Id            = [guid]::NewGuid().ToString()',
        '        Username      = $Username',
        '        Level         = 1',
        '        XP            = 0',
        '        Resources     = New-NSMResource',
        '        Buildings     = @{} ',
        '        WalletAddress = ""',
        '        Firewalls     = 0  ',
        '        Nfts          = @()',
        '        SyndicateId   = "" ',
        '        VipTier       = "Free"',
        '        VipExpiry     = $null',
        '        CreatedAt     = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
        '    }',
        '}',
        '',
        'function New-NSMResource {',
        '    return [PSCustomObject]@{',
        '        Credits       = 500   ',
        '        Bandwidth     = 100   ',
        '        DataShards    = 0     ',
        '        NSM_Token     = 0     ',
        '    }',
        '}',
        '',
        'function New-NSMBuilding {',
        '    param(',
        '        [string]$Type,',
        '        [int]$Level = 1,',
        '        [bool]$IsUpgrading = $false',
        '    )',
        '    return [PSCustomObject]@{',
        '        Type        = $Type',
        '        Level       = $Level',
        '        IsUpgrading = $IsUpgrading',
        '        UpgradeEnds = $null',
        '    }',
        '}',
        '',
        'function New-NSMSyndicate {',
        '    param([string]$Name, [string]$LeaderId)',
        '    return [PSCustomObject]@{',
        '        Id           = [guid]::NewGuid().ToString()',
        '        Name         = $Name',
        '        LeaderId     = $LeaderId',
        '        Members      = @($LeaderId)',
        '        BankCredits  = 0',
        '        BankData     = 0',
        '        Level        = 1',
        '        CreatedAt    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding, New-NSMSyndicate'
    ) -join "`r`n"

    try {
        [System.IO.File]::WriteAllText($DomainFile, $DomainLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Domain Object Model Updated." -ForegroundColor Green
    } catch {
        throw "Failed to write Domain Module: $_"
    }

    # ---------------------------------------------------------
    # PHASE 2: Refactor Game Configuration (Static Data)
    # ---------------------------------------------------------
    
    Write-Host "[CMD_132] Refactoring NSM_GameConfig.json..." -ForegroundColor Cyan

    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    
    # --- FIX APPLIED HERE ---
    # Changed 'units' from [ordered]@(Array) to just @(Array) because 
    # [ordered] is only valid for HashTables (Objects), not Arrays.
    
    $ConfigObject = [ordered]@{
        theme_version = "2.0-cyberpunk"
        description   = "NASRIUM Node Configuration Matrix"
        resources = @{
            credit_name = "Credits"
            energy_name = "Bandwidth"
            soft_currency= "DataShards"
        }
        buildings = [ordered]@{
            AI_CORE = @{
                name = "AI Core"
                desc = "Central Processing Unit."
                max_level = 15
            }
            DATA_MINER = @{
                name = "Data Miner"
                desc = "Extracts raw data to Credits."
                max_level = 12
            }
            SERVER_FARM = @{
                name = "Server Farm"
                desc = "Generates bandwidth."
                max_level = 8
            }
            FIREWALL_SERVER = @{
                name = "Firewall Gateway"
                desc = "Protects node from Raids."
                max_level = 5
            }
            BOT_FOUNDRY = @{
                name = "Agent Foundry"
                desc = "Compiles Digital Agents."
                max_level = 10
            }
        }
        units = @(                               # <---FIXED: Removed [ordered]
            @{id="SCOUT_DRONE"; name="Scout Drone"},
            @{id="NET_RUNNER"; name="Net Runner"},
            @{id="CY_BORG"; name="Cy-Borg"}
        )
    }

    try {
        $JsonContent = $ConfigObject | ConvertTo-Json -Depth 5
        [System.IO.File]::WriteAllText($ConfigFile, $JsonContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Sealed." -ForegroundColor Green
    } catch {
        throw "Failed to write Config File: $_"
    }

    # ---------------------------------------------------------
    # PHASE 3: Registry & State Update
    # ---------------------------------------------------------
    Write-Host "[CMD_132] Committing State..." -ForegroundColor Cyan
    try {
        $RegistryPath = Join-Path $Root "Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        
        $state = @{
            cmd_id = "CMD_132_001"
            task = "Cyberpunk Theme Code Refactor (Fixed)"
            status = "COMPLETED"
            completed_at = $stampISO
        } | ConvertTo-Json -Depth 3
        
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_132_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_132 REFACTOR COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_132_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_132" -Action { Refactor-CyberpunkTheme }
} else {
    Refactor-CyberpunkTheme
}
