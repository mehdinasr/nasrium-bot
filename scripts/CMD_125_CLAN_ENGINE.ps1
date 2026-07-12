# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_125
# File ID   : CMD_125_001
# Module    : Game
# Component : Clan System Engine
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-ClanEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM CLAN SYSTEM ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_125" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Ratify Clan Rules in Governance (Rule 35)
    Write-Host "[CMD_125] Ratifying Clan System Rules in Governance..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw
    $ClanRules = @"

## 12. Clan System Integration
- Players can create or join Clans (Tribes).
- **Clan Creation Cost:** 1000 Gold.
- **Clan Member Limit:** 50 members per clan.
- **Donation System:** Members can donate Gold and NSM_Soft to the Clan Bank.
- **Clan Bank:** Used for Clan upgrades and PvP defenses.
"@
    $DocContent += $ClanRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch Game Config with Clan Settings
    Write-Host "[CMD_125] Updating NSM_GameConfig.json with Clan Settings..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ConfigContent = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    $ConfigContent | Add-Member -NotePropertyName "clan" -NotePropertyValue @{
        "creation_cost_gold" = 1000
        "max_members" = 50
    } -Force
    try {
        $ConfigContent | ConvertTo-Json -Depth 5 | Set-Content $ConfigFile -Encoding UTF8
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Patch Game Domain (Add ClanId)
    Write-Host "[CMD_125] Patching NSM_GameDomain.psm1 for ClanId..." -ForegroundColor Cyan
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
        '        Shields = 0',
        '        Nfts = @()',
        '        ClanId = ""',
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
        'function New-NSMClan {',
        '    param([string]$Name, [string]$LeaderId)',
        '    return [PSCustomObject]@{',
        '        Id = [guid]::NewGuid().ToString()',
        '        Name = $Name',
        '        LeaderId = $LeaderId',
        '        Members = @($LeaderId)',
        '        BankGold = 0',
        '        BankSoft = 0',
        '    }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding, New-NSMClan'
    )
    try {
        $ModuleContent = $DomainLines -join "`r`n"
        [System.IO.File]::WriteAllText($DomainFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Domain Patched." -ForegroundColor Green
    } catch {
        throw "Failed to patch Domain: $_"
    }

    # 4. Build Clan Engine Module
    Write-Host "[CMD_125] Building NSM_ClanEngine.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $GameDir "NSM_ClanEngine.psm1"
    $ModuleLines = @(
        'function New-NSMPlayerClan {',
        '    param($Player, [string]$ClanName)',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    $Cost = $Config.clan.creation_cost_gold',
        '    ',
        '    if ($Player.Resources.Gold -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }',
        '    }',
        '    ',
        '    if ($Player.ClanId -ne "") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "AlreadyInClan" }',
        '    }',
        '    ',
        '    # Deduct Cost & Create Clan',
        '    $Player.Resources.Gold -= $Cost',
        '    $Clan = New-NSMClan -Name $ClanName -LeaderId $Player.Id',
        '    $Player.ClanId = $Clan.Id',
        '    ',
        '    # Save Clan to Disk (Simulated DB)',
        '    $ClanDir = "D:\NASRIUM\Data\Database\Clans"',
        '    if (!(Test-Path $ClanDir)) { New-Item -ItemType Directory -Path $ClanDir -Force | Out-Null }',
        '    $Clan | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $ClanDir "$($Clan.Id).json") -Encoding UTF8',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; ClanId = $Clan.Id; ClanName = $Clan.Name }',
        '}',
        '',
        'function Submit-NSMClanDonation {',
        '    param($Player, [decimal]$Amount, [ValidateSet("Gold", "NSM_Soft")]$Type = "Gold")',
        '    ',
        '    if ($Player.ClanId -eq "") {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "NotInClan" }',
        '    }',
        '    ',
        '    if ($Type -eq "Gold" -and $Player.Resources.Gold -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }',
        '    }',
        '    ',
        '    if ($Type -eq "NSM_Soft" -and $Player.Resources.NSM_Soft -lt $Amount) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }',
        '    }',
        '    ',
        '    # Deduct from Player',
        '    if ($Type -eq "Gold") { $Player.Resources.Gold -= $Amount }',
        '    if ($Type -eq "NSM_Soft") { $Player.Resources.NSM_Soft -= $Amount }',
        '    ',
        '    # Add to Clan Bank (Simulated)',
        '    $ClanDir = "D:\NASRIUM\Data\Database\Clans"',
        '    $ClanPath = Join-Path $ClanDir "$($Player.ClanId).json"',
        '    $Clan = Get-Content $ClanPath -Raw | ConvertFrom-Json',
        '    if ($Type -eq "Gold") { $Clan.BankGold += $Amount }',
        '    if ($Type -eq "NSM_Soft") { $Clan.BankSoft += $Amount }',
        '    $Clan | ConvertTo-Json -Depth 3 | Set-Content $ClanPath -Encoding UTF8',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Amount = $Amount; Type = $Type }',
        '}',
        '',
        'Export-ModuleMember -Function New-NSMPlayerClan, Submit-NSMClanDonation'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Clan Engine Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create Clan Module: $_"
    }

    # 5. Integration Test
    Write-Host "[CMD_125] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_ClanEngine -ErrorAction SilentlyContinue
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $ModuleFile -Force
        
        $TestPlayer = New-NSMPlayer -Username "ClanLeader"
        $TestPlayer.Resources.Gold = 2000
        Grant-NSMToken -Player $TestPlayer -Amount 500 -TokenType NSM_Soft | Out-Null
        
        # Test 1: Create Clan
        $Result1 = New-NSMPlayerClan -Player $TestPlayer -ClanName "NASRIUM_Kings"
        if ($Result1.Status -ne "SUCCESS") { throw "Test 1 Failed: Clan creation failed." }
        if ($TestPlayer.Resources.Gold -ne 1000) { throw "Test 1 Failed: Gold not deducted." }
        if ($TestPlayer.ClanId -eq "") { throw "Test 1 Failed: ClanId not assigned." }
        
        # Test 2: Create Clan when already in one
        $Result2 = New-NSMPlayerClan -Player $TestPlayer -ClanName "AnotherClan"
        if ($Result2.Reason -ne "AlreadyInClan") { throw "Test 2 Failed: Should prevent double joining." }
        
        # Test 3: Donate Gold
        $Result3 = Submit-NSMClanDonation -Player $TestPlayer -Amount 500 -Type Gold
        if ($Result3.Status -ne "SUCCESS") { throw "Test 3 Failed: Gold donation failed." }
        if ($TestPlayer.Resources.Gold -ne 500) { throw "Test 3 Failed: Donation not deducted." }
        
        # Test 4: Donate Soft Token
        $Result4 = Submit-NSMClanDonation -Player $TestPlayer -Amount 100 -Type NSM_Soft
        if ($Result4.Status -ne "SUCCESS") { throw "Test 4 Failed: Soft donation failed." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 6. Registry
    Write-Host "[CMD_125] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_125_001"
            task = "Clan System Engine"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_126"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_125_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_125 CLAN ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_125_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_125" -Action { Build-ClanEngine }
} else {
    Build-ClanEngine
}
