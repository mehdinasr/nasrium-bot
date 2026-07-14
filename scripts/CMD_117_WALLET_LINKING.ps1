# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_117
# File ID   : CMD_117_001
# Module    : Web3
# Component : Web3 Wallet Linking Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-WalletLinking {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM WEB3 WALLET LINKING ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_117" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $Web3Dir = "$Root\Core\Modules\Web3"

    if (!(Test-Path $Web3Dir)) { New-Item -ItemType Directory -Path $Web3Dir -Force | Out-Null }

    # Step 1: Patch Game Domain to include WalletAddress
    Write-Host "[CMD_117] Patching NSM_GameDomain.psm1 for Wallet Address..." -ForegroundColor Cyan
    $DomainFile = Join-Path $GameDir "NSM_GameDomain.psm1"
    $DomainLines = @(
        'function New-NSMPlayer {',
        '    param([string]$Username)',
        '    return [PSCustomObject]@{',
        '        Id = [guid]::NewGuid().ToString()',
        '        Username = $Username',
        '        Level = 1',
        '        Resources = New-NSMResource',
        '        Buildings = @()',
        '        WalletAddress = ""',
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
        $ModuleContent = $DomainLines -join "`r`n"
        [System.IO.File]::WriteAllText($DomainFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Domain Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch Domain: $_"
    }

    # Step 2: Build Wallet Manager Module
    Write-Host "[CMD_117] Building NSM_WalletManager.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $Web3Dir "NSM_WalletManager.psm1"
    $ModuleLines = @(
        'function Register-NSMWallet {',
        '    param($Player, [string]$WalletAddress)',
        '    ',
        '    if ($Player.WalletAddress -ne "") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletAlreadyLinked" }',
        '    }',
        '    ',
        '    if ($WalletAddress -notmatch "^EQ" -and $WalletAddress -notmatch "^UQ") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidTonAddressFormat" }',
        '    }',
        '    ',
        '    $Player.WalletAddress = $WalletAddress',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; LinkedWallet = $WalletAddress }',
        '}',
        '',
        'Export-ModuleMember -Function Register-NSMWallet'
    )

    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Wallet Manager Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Wallet Module: $_"
    }

    # Step 3: Validation Test
    Write-Host "[CMD_117] Running Validation Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_WalletManager -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainFile -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "Web3User"
        
        # Test 1: Invalid Address Format
        $Result1 = Register-NSMWallet -Player $TestPlayer -WalletAddress "0xABC123"
        if ($Result1.Reason -ne "InvalidTonAddressFormat") { throw "Test 1 Failed: Should reject invalid format." }
        
        # Test 2: Successful Linking
        $Result2 = Register-NSMWallet -Player $TestPlayer -WalletAddress "EQDKljf32kj45hkj34h5kj345hkj34"
        if ($Result2.Status -ne "SUCCESS" -or $TestPlayer.WalletAddress -eq "") { throw "Test 2 Failed: Wallet not linked." }
        
        # Test 3: Already Linked
        $Result3 = Register-NSMWallet -Player $TestPlayer -WalletAddress "UQAbcdef123456"
        if ($Result3.Reason -ne "WalletAlreadyLinked") { throw "Test 3 Failed: Should reject re-linking." }
        
        Write-Host "  [OK] Validation Tests Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # Step 4: Registry
    Write-Host "[CMD_117] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_117_001"
            task = "Web3 Wallet Linking Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_118"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_117_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_117 WALLET LINKING COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_117_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_117" -Action { Build-WalletLinking }
} else {
    Build-WalletLinking
}
