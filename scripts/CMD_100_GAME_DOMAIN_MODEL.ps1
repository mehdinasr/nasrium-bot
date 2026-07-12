# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_100
# File ID   : CMD_100_001
# Module    : Game
# Component : Game Domain Model Foundation
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-GameDomainModel {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME DOMAIN MODEL BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_100" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $ModuleDir = "$Root\Core\Modules\Game"
    $ModuleFile = "$ModuleDir\NSM_GameDomain.psm1"
    $MetadataDir = "$Root\Data\Metadata"

    if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
    if (!(Test-Path $MetadataDir)) { New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null }

    Write-Host "[CMD_100] Building NSM_GameDomain.psm1..." -ForegroundColor Cyan
    
    $ModuleLines = @(
        'function New-NSMPlayer {',
        '    param([string]$Username)',
        '    return [PSCustomObject]@{',
        '        Id = [guid]::NewGuid().ToString()',
        '        Username = $Username',
        '        Level = 1',
        '        Resources = New-NSMResource',
        '        Buildings = @()',
        '        CreatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
        '    }',
        '}',
        '',
        'function New-NSMResource {',
        '    return [PSCustomObject]@{',
        '        Gold = 500',
        '        NSM = 0',
        '        Energy = 100',
        '    }',
        '}',
        '',
        'function New-NSMBuilding {',
        '    param([string]$Type, [int]$Level = 1)',
        '    return [PSCustomObject]@{',
        '        Type = $Type',
        '        Level = $Level',
        '        Upgrading = $false',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Domain Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Domain Module: $_"
    }

    Write-Host "[CMD_100] Running Unit Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_GameDomain -ErrorAction SilentlyContinue
        Import-Module $ModuleFile -Force
        
        $Player = New-NSMPlayer -Username "NasriumFounder"
        if ($Player.Username -ne "NasriumFounder") { throw "Player creation failed." }
        if ($Player.Resources.Gold -ne 500) { throw "Default resources failed." }
        
        $Building = New-NSMBuilding -Type "TownHall"
        if ($Building.Type -ne "TownHall") { throw "Building creation failed." }
        
        Write-Host "  [OK] Unit Tests Passed." -ForegroundColor Green
    } catch {
        throw "Unit Test Failed: $_"
    }

    Write-Host "[CMD_100] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_100_001"
            task = "Game Domain Model Foundation"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_101"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_100_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_100 DOMAIN MODEL COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_100_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_100" -Action { Build-GameDomainModel }
} else {
    Build-GameDomainModel
}
