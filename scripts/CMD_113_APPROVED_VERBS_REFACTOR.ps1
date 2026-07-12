# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_113
# File ID   : CMD_113_001
# Module    : Refactor
# Component : PowerShell Approved Verbs Compliance
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Repair-ApprovedVerbs {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM APPROVED VERBS REFACTOR" -ForegroundColor Cyan
    Write-Host "Command   : CMD_113" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $InfraDir = "$Root\Core\Modules\Infrastructure"

    # 1. Refactor NSM_ResourceEngine.psm1
    Write-Host "[CMD_113] Refactoring NSM_ResourceEngine.psm1..." -ForegroundColor Cyan
    $ResourceFile = Join-Path $GameDir "NSM_ResourceEngine.psm1"
    $ResourceLines = @(
        'function Receive-NSMResources {',
        '    param($Player, [string]$BuildingType)',
        '    ',
        '    $Building = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType -and -not $_.Upgrading } | Select-Object -First 1',
        '    if (-not $Building) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BuildingNotFoundOrUpgrading" }',
        '    }',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $Yield = $Config.buildings.$BuildingType.levels."$($Building.Level)".yield_gold_per_cycle',
        '    ',
        '    if (-not $Yield -or $Yield -eq 0) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "NoYieldDefined" }',
        '    }',
        '    ',
        '    $Player.Resources.Gold += $Yield',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; YieldAmount = $Yield; TotalGold = $Player.Resources.Gold }',
        '}',
        '',
        'Export-ModuleMember -Function Receive-NSMResources'
    )
    try {
        $ModuleContent = $ResourceLines -join "`r`n"
        [System.IO.File]::WriteAllText($ResourceFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] ResourceEngine Refactored." -ForegroundColor Green
    } catch {
        throw "Failed: $_"
    }

    # 2. Refactor NSM_PlayerPersistence.psm1
    Write-Host "[CMD_113] Refactoring NSM_PlayerPersistence.psm1..." -ForegroundColor Cyan
    $PersistenceFile = Join-Path $GameDir "NSM_PlayerPersistence.psm1"
    $PersistenceLines = @(
        'function Export-NSMPlayer {',
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
        'function Import-NSMPlayer {',
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
        'Export-ModuleMember -Function Export-NSMPlayer, Import-NSMPlayer'
    )
    try {
        $ModuleContent = $PersistenceLines -join "`r`n"
        [System.IO.File]::WriteAllText($PersistenceFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] PlayerPersistence Refactored." -ForegroundColor Green
    } catch {
        throw "Failed: $_"
    }

    # 3. Refactor NSM_TokenEngine.psm1
    Write-Host "[CMD_113] Refactoring NSM_TokenEngine.psm1..." -ForegroundColor Cyan
    $TokenFile = Join-Path $GameDir "NSM_TokenEngine.psm1"
    $TokenLines = @(
        'function Use-NSMToken {',
        '    param($Player, [decimal]$Amount)',
        '    if ($Player.Resources.NSM -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientNSM" }',
        '    }',
        '    $Player.Resources.NSM -= $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Spent = $Amount; RemainingNSM = $Player.Resources.NSM }',
        '}',
        '',
        'function Grant-NSMToken {',
        '    param($Player, [decimal]$Amount)',
        '    $Player.Resources.NSM += $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Rewarded = $Amount; TotalNSM = $Player.Resources.NSM }',
        '}',
        '',
        'Export-ModuleMember -Function Use-NSMToken, Grant-NSMToken'
    )
    try {
        $ModuleContent = $TokenLines -join "`r`n"
        [System.IO.File]::WriteAllText($TokenFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] TokenEngine Refactored." -ForegroundColor Green
    } catch {
        throw "Failed: $_"
    }

    # 4. Update Dependencies (NSM_GameSession.psm1 & NSM_GameRouter.psm1)
    Write-Host "[CMD_113] Updating Dependencies..." -ForegroundColor Cyan
    
    # Update GameSession
    $SessionFile = Join-Path $GameDir "NSM_GameSession.psm1"
    $SessionContent = Get-Content $SessionFile -Raw
    $SessionContent = $SessionContent -replace 'Save-NSMPlayer', 'Export-NSMPlayer'
    $SessionContent = $SessionContent -replace 'Claim-NSMResources', 'Receive-NSMResources'
    [System.IO.File]::WriteAllText($SessionFile, $SessionContent, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] GameSession Dependencies Updated." -ForegroundColor Green

    # Update GameRouter
    $RouterFile = Join-Path $InfraDir "NSM_GameRouter.psm1"
    $RouterContent = Get-Content $RouterFile -Raw
    $RouterContent = $RouterContent -replace 'Load-NSMPlayer', 'Import-NSMPlayer'
    $RouterContent = $RouterContent -replace 'Save-NSMPlayer', 'Export-NSMPlayer'
    [System.IO.File]::WriteAllText($RouterFile, $RouterContent, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] GameRouter Dependencies Updated." -ForegroundColor Green

    # 5. Validation Test
    Write-Host "[CMD_113] Running Validation Tests..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_ResourceEngine, NSM_PlayerPersistence, NSM_TokenEngine, NSM_GameSession, NSM_GameRouter -ErrorAction SilentlyContinue
        Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force
        Import-Module $ResourceFile -Force
        Import-Module $PersistenceFile -Force
        Import-Module $TokenFile -Force
        Import-Module $SessionFile -Force
        Import-Module $RouterFile -Force

        $TestPlayer = New-NSMPlayer -Username "VerbTest"
        $TestPlayer.Id = "VERB_TEST_001"
        
        # Test Export (was Save)
        $ExportResult = Export-NSMPlayer -Player $TestPlayer
        if (-not $ExportResult) { throw "Export failed." }
        
        # Test Import (was Load)
        $ImportedPlayer = Import-NSMPlayer -PlayerId $TestPlayer.Id
        if ($ImportedPlayer.Username -ne "VerbTest") { throw "Import failed." }
        
        # Test Grant (was Reward)
        $GrantResult = Grant-NSMToken -Player $ImportedPlayer -Amount 10
        if ($GrantResult.Status -ne "SUCCESS") { throw "Grant failed." }
        
        # Test Use (was Spend)
        $UseResult = Use-NSMToken -Player $ImportedPlayer -Amount 5
        if ($UseResult.Status -ne "SUCCESS") { throw "Use failed." }
        
        Write-Host "  [OK] All Refactored Functions Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # 6. Registry
    Write-Host "[CMD_113] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_113_001"
            task = "PowerShell Approved Verbs Compliance"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_114"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_113_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_113 APPROVED VERBS COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_113_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_113" -Action { Repair-ApprovedVerbs }
} else {
    Repair-ApprovedVerbs
}
