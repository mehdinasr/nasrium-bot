# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_119
# File ID   : CMD_119_001
# Module    : Game
# Component : Dual Token Economy Implementation
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Implement-DualToken {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM DUAL TOKEN ECONOMY IMPLEMENTATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_119" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"

    # 1. Patch Game Domain (NSM_GameDomain.psm1)
    Write-Host "[CMD_119] Patching NSM_GameDomain.psm1 for Dual Token..." -ForegroundColor Cyan
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
        '        NSM_Soft = 0',
        '        NSM_Withdraw = 0',
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

    # 2. Refactor Token Engine (NSM_TokenEngine.psm1)
    Write-Host "[CMD_119] Refactoring NSM_TokenEngine.psm1 for Dual Token..." -ForegroundColor Cyan
    $TokenFile = Join-Path $GameDir "NSM_TokenEngine.psm1"
    $TokenLines = @(
        'function Use-NSMToken {',
        '    param($Player, [decimal]$Amount, [ValidateSet("NSM_Soft", "NSM_Withdraw")]$TokenType = "NSM_Soft")',
        '    if ($Player.Resources.$TokenType -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientTokens" }',
        '    }',
        '    $Player.Resources.$TokenType -= $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Spent = $Amount; Type = $TokenType; Remaining = $Player.Resources.$TokenType }',
        '}',
        '',
        'function Grant-NSMToken {',
        '    param($Player, [decimal]$Amount, [ValidateSet("NSM_Soft", "NSM_Withdraw")]$TokenType = "NSM_Soft")',
        '    $Player.Resources.$TokenType += $Amount',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Rewarded = $Amount; Type = $TokenType; Total = $Player.Resources.$TokenType }',
        '}',
        '',
        'Export-ModuleMember -Function Use-NSMToken, Grant-NSMToken'
    )
    try {
        $ModuleContent = $TokenLines -join "`r`n"
        [System.IO.File]::WriteAllText($TokenFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Token Engine Refactored." -ForegroundColor Green
    } catch {
        throw "Failed to refactor Token Engine: $_"
    }

    # 3. Update Game Config for Withdrawal Rates
    Write-Host "[CMD_119] Updating NSM_GameConfig.json with Withdrawal Rates..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $Root "Core\Config\NSM_GameConfig.json"
    $ConfigLines = @(
        '{',
        '  "buildings": {',
        '    "TownHall": {',
        '      "levels": {',
        '        "1": { "cost_gold": 0, "build_time_seconds": 0, "yield_gold_per_cycle": 0, "energy_cost_to_build": 0 },',
        '        "2": { "cost_gold": 1000, "build_time_seconds": 60, "yield_gold_per_cycle": 0, "energy_cost_to_build": 20 },',
        '        "3": { "cost_gold": 5000, "build_time_seconds": 300, "yield_gold_per_cycle": 0, "energy_cost_to_build": 50 }',
        '      }',
        '    },',
        '    "GoldMine": {',
        '      "levels": {',
        '        "1": { "cost_gold": 300, "build_time_seconds": 10, "yield_gold_per_cycle": 50, "energy_cost_to_build": 10 },',
        '        "2": { "cost_gold": 800, "build_time_seconds": 30, "yield_gold_per_cycle": 150, "energy_cost_to_build": 20 }',
        '      }',
        '    }',
        '  },',
        '  "economy": {',
        '    "initial_gold": 500,',
        '    "initial_nsm_soft": 0,',
        '    "initial_nsm_withdraw": 0,',
        '    "initial_energy": 100,',
        '    "energy_regenerate_rate": 1,',
        '    "withdraw_rates": {',
        '      "3": 5.0,',
        '      "4": 5.5,',
        '      "5": 6.0,',
        '      "6": 6.5,',
        '      "7": 7.5,',
        '      "8": 8.5,',
        '      "9": 9.0',
        '    }',
        '  }',
        '}'
    ) -join "`r`n"
    try {
        [System.IO.File]::WriteAllText($ConfigFile, $ConfigLines, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 4. Validation Test
    Write-Host "[CMD_119] Running Validation Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainFile -Force
        Import-Module $TokenFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "DualTokenUser"
        
        # Test 1: Grant Soft Token
        $Result1 = Grant-NSMToken -Player $TestPlayer -Amount 100 -TokenType NSM_Soft
        if ($Result1.Status -ne "SUCCESS" -or $TestPlayer.Resources.NSM_Soft -ne 100) { throw "Test 1 Failed: Soft Token grant error." }
        
        # Test 2: Grant Withdraw Token
        $Result2 = Grant-NSMToken -Player $TestPlayer -Amount 50 -TokenType NSM_Withdraw
        if ($Result2.Status -ne "SUCCESS" -or $TestPlayer.Resources.NSM_Withdraw -ne 50) { throw "Test 2 Failed: Withdraw Token grant error." }
        
        # Test 3: Use Withdraw Token
        $Result3 = Use-NSMToken -Player $TestPlayer -Amount 10 -TokenType NSM_Withdraw
        if ($Result3.Status -ne "SUCCESS" -or $TestPlayer.Resources.NSM_Withdraw -ne 40) { throw "Test 3 Failed: Withdraw Token use error." }
        
        # Test 4: Config Withdraw Rates Check
        $Config = Get-NSMGameConfig
        if ($Config.economy.withdraw_rates."3" -ne 5.0) { throw "Test 4 Failed: Withdraw rates not loaded." }
        
        Write-Host "  [OK] Validation Tests Passed." -ForegroundColor Green
    } catch {
        throw "Validation Test Failed: $_"
    }

    # 5. Registry
    Write-Host "[CMD_119] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_119_001"
            task = "Dual Token Economy Implementation"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_120"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_119_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_119 DUAL TOKEN COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_119_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_119" -Action { Implement-DualToken }
} else {
    Implement-DualToken
}
