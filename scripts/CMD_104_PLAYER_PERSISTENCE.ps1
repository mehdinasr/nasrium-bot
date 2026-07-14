# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_104
# File ID   : CMD_104_001
# Module    : Game
# Component : Player State Persistence Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-PlayerPersistence {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM PLAYER PERSISTENCE ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_104" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $DatabaseDir = "$Root\Data\Database\Players"
    $ModuleFile = Join-Path $ModuleDir "NSM_PlayerPersistence.psm1"

    if (!(Test-Path $DatabaseDir)) { New-Item -ItemType Directory -Path $DatabaseDir -Force | Out-Null }

    Write-Host "[CMD_104] Building NSM_PlayerPersistence.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function Save-NSMPlayer {',
        '    param($Player)',
        '    $DatabaseDir = "D:\NASRIUM\Data\Database\Players"',
        '    if (!(Test-Path $DatabaseDir)) { New-Item -ItemType Directory -Path $DatabaseDir -Force | Out-Null }',
        '    $FilePath = Join-Path $DatabaseDir "$($Player.Id).json"',
        '    try {',
        '        $Player | ConvertTo-Json -Depth 5 | Set-Content $FilePath -Encoding UTF8',
        '        return $true',
        '    } catch {',
        '        throw "Failed to save player data: $_"',
        '    }',
        '}',
        '',
        'function Load-NSMPlayer {',
        '    param([string]$PlayerId)',
        '    $FilePath = Join-Path "D:\NASRIUM\Data\Database\Players" "$PlayerId.json"',
        '    if (!(Test-Path $FilePath)) {',
        '        throw "Player data not found: $PlayerId"',
        '    }',
        '    try {',
        '        return Get-Content $FilePath -Raw | ConvertFrom-Json',
        '    } catch {',
        '        throw "Failed to load player data: $_"',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function Save-NSMPlayer, Load-NSMPlayer'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Player Persistence Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Persistence Module: $_"
    }

    Write-Host "[CMD_104] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $DomainPath = "$ModuleDir\NSM_GameDomain.psm1"
        $GameConfigPath = "$ModuleDir\NSM_GameConfig.psm1"
        $EnginePath = "$ModuleDir\NSM_GameEngine.psm1"
        $ResourcePath = "$ModuleDir\NSM_ResourceEngine.psm1"
        $PersistencePath = $ModuleFile
        
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine, NSM_PlayerPersistence -ErrorAction SilentlyContinue
        Import-Module $GameConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $EnginePath -Force
        Import-Module $ResourcePath -Force
        Import-Module $PersistencePath -Force
        
        # 1. Create and Modify Player
        $TestPlayer = New-NSMPlayer -Username "PersistentUser"
        Start-NSMBuildingUpgrade -Player $TestPlayer -BuildingType "GoldMine" | Out-Null
        
        # 2. Save Player
        $SaveResult = Save-NSMPlayer -Player $TestPlayer
        if (-not $SaveResult) { throw "Save operation failed." }
        
        # 3. Clear Memory & Load Player
        $PlayerId = $TestPlayer.Id
        Remove-Variable TestPlayer
        
        $LoadedPlayer = Load-NSMPlayer -PlayerId $PlayerId
        if ($LoadedPlayer.Username -ne "PersistentUser") { throw "Load failed: Username mismatch." }
        if ($LoadedPlayer.Buildings.Count -ne 1) { throw "Load failed: Buildings data lost." }
        if ($LoadedPlayer.Resources.Gold -ne 200) { throw "Load failed: Resources data lost." }

        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    Write-Host "[CMD_104] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_104_001"
            task = "Player State Persistence Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_105"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_104_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_104 PERSISTENCE ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_104_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_104" -Action { Build-PlayerPersistence }
} else {
    Build-PlayerPersistence
}
