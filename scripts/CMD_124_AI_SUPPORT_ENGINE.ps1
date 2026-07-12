# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_124
# File ID   : CMD_124_001
# Module    : AI
# Component : AI Support Engine & Token-Gated Integration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Build-AiSupportEngine {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM AI SUPPORT ENGINE BUILD" -ForegroundColor Cyan
    Write-Host "Command   : CMD_124" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $AiDir = "$Root\Core\Modules\AI"
    $InfraDir = "$Root\Core\Modules\Infrastructure"
    $ConfigDir = "$Root\Core\Config"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"

    # 1. Ratify AI Support Rules in Governance (Rule 35)
    Write-Host "[CMD_124] Ratifying AI Support Rules in Governance..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw
    $AiRules = @"

## 11. AI Support Integration
- Players can use `/ask` command to query the Nasrium AI Assistant.
- AI Support is Token-Gated: it consumes **NSM_Soft** tokens.
- Tiers and Costs:
  - **FAQ/Help** (Rule-based): 0 NSM_Soft.
  - **Simple Analysis** (Low Cost Model): 5 NSM_Soft.
  - **Advanced Strategy** (High Quality Model): 20 NSM_Soft.
- This creates a sustainable use-case for in-app tokens and reduces human support costs.
"@
    $DocContent += $AiRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # 2. Patch Game Config with AI Costs
    Write-Host "[CMD_124] Updating NSM_GameConfig.json with AI Support Costs..." -ForegroundColor Cyan
    $ConfigFile = Join-Path $ConfigDir "NSM_GameConfig.json"
    $ConfigContent = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    $ConfigContent | Add-Member -NotePropertyName "ai_support" -NotePropertyValue @{
        "faq" = @{ cost_nsm_soft = 0; model = "local" };
        "simple" = @{ cost_nsm_soft = 5; model = "api_low" };
        "advanced" = @{ cost_nsm_soft = 20; model = "api_high" }
    } -Force
    try {
        $ConfigContent | ConvertTo-Json -Depth 5 | Set-Content $ConfigFile -Encoding UTF8
        Write-Host "  [OK] Game Config Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update config: $_"
    }

    # 3. Build AI Support Module
    Write-Host "[CMD_124] Building NSM_SupportAI.psm1..." -ForegroundColor Cyan
    $ModuleFile = Join-Path $AiDir "NSM_SupportAI.psm1"
    $ModuleLines = @(
        'function Request-NSMAiSupport {',
        '    param($Player, [string]$Query, [string]$Tier = "simple")',
        '    ',
        '    $Config = Get-NSMGameConfig',
        '    if (-not $Config.ai_support.$Tier) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidAiTier" }',
        '    }',
        '    ',
        '    $Cost = $Config.ai_support.$Tier.cost_nsm_soft',
        '    ',
        '    if ($Player.Resources.NSM_Soft -lt $Cost) {',
        '        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }',
        '    }',
        '    ',
        '    # Deduct Cost',
        '    $Player.Resources.NSM_Soft -= $Cost',
        '    ',
        '    # Mock AI Response (Future: API Integration)',
        '    $Response = "AI_RESPONSE ($Tier): Analysis of your query ''$Query'' is complete. Optimize your GoldMines first."',
        '    ',
        '    return [PSCustomObject]@{ Status = "SUCCESS"; Response = $Response; TokensSpent = $Cost }',
        '}',
        '',
        'Export-ModuleMember -Function Request-NSMAiSupport'
    )
    try {
        $ModuleContent = $ModuleLines -join "`r`n"
        [System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] AI Support Module Created." -ForegroundColor Green
    } catch {
        throw "Failed to create AI Support Module: $_"
    }

    # 4. Update Game Router with /ask command
    Write-Host "[CMD_124] Updating NSM_GameRouter.psm1 with /ask..." -ForegroundColor Cyan
    $RouterFile = Join-Path $InfraDir "NSM_GameRouter.psm1"
    $RouterLines = @(
        'function Invoke-NSMGameCommand {',
        '    param([string]$ChatId, [string]$CommandText)',
        '    ',
        '    $Parts = $CommandText -split " "', 
        '    $Cmd = $Parts[0].ToLower()',
        '    $Arg1 = if ($Parts.Length -gt 1) { $Parts[1] } else { "" }',
        '    $Arg2 = if ($Parts.Length -gt 2) { $Parts[2] } else { "" }',
        '    ',
        '    $Player = $null',
        '    try {',
        '        $Player = Import-NSMPlayer -PlayerId $ChatId',
        '    } catch {',
        '        $Player = New-NSMPlayer -Username "TG_$ChatId"',
        '        $Player.Id = $ChatId',
        '        Export-NSMPlayer -Player $Player | Out-Null',
        '    }',
        '    ',
        '    $ResponseText = ""',
        '    ',
        '    switch ($Cmd) {',
        '        "/start" {',
        '            $ResponseText = "Welcome to NASRIUM! Use /build, /claim, /status, or /ask <tier> <question>."',
        '        }',
        '        "/status" {',
        '            $ResponseText = "=== STATUS ===`r`nLevel: $($Player.Level)`r`nGold: $($Player.Resources.Gold)`r`nEnergy: $($Player.Resources.Energy)`r`nSoft: $($Player.Resources.NSM_Soft)`r`nWithdraw: $($Player.Resources.NSM_Withdraw)"',
        '        }',
        '        "/build" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }',
        '            $Result = Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: $Arg1 upgraded. Gold: $($Result.RemainingGold)"',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/claim" {',
        '            if (-not $Arg1) { $ResponseText = "Usage: /claim <BuildingType>"; break }',
        '            $Building = $Player.Buildings | Where-Object { $_.Type -eq $Arg1 } | Select-Object -First 1',
        '            if ($Building) { $Building.Upgrading = $false }',
        '            $Result = Receive-NSMResources -Player $Player -BuildingType $Arg1',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "SUCCESS: Claimed $($Result.YieldAmount) Gold."',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        "/ask" {',
        '            if (-not $Arg1 -or -not $Arg2) { $ResponseText = "Usage: /ask <faq|simple|advanced> <question>"; break }',
        '            $Tier = $Arg1',
        '            $Query = $CommandText.Substring($CommandText.IndexOf($Arg2))',
        '            $Result = Request-NSMAiSupport -Player $Player -Query $Query -Tier $Tier',
        '            if ($Result.Status -eq "SUCCESS") {',
        '                Export-NSMPlayer -Player $Player | Out-Null',
        '                $ResponseText = "$($Result.Response) (Cost: $($Result.TokensSpent) NSM_Soft)"',
        '            } else { $ResponseText = "FAILED: $($Result.Reason)" }',
        '        }',
        '        default { $ResponseText = "Unknown command." }',
        '    }',
        '    return $ResponseText',
        '}',
        '',
        'Export-ModuleMember -Function Invoke-NSMGameCommand'
    )
    try {
        $ModuleContent = $RouterLines -join "`r`n"
        [System.IO.File]::WriteAllText($RouterFile, $ModuleContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Router Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Router: $_"
    }

    # 5. Integration Test
    Write-Host "[CMD_124] Running Integration Tests..." -ForegroundColor Cyan
    try {
        $ConfigPath = "$GameDir\NSM_GameConfig.psm1"
        $DomainPath = "$GameDir\NSM_GameDomain.psm1"
        $TokenPath = "$GameDir\NSM_TokenEngine.psm1"
        $EnginePath = "$GameDir\NSM_GameEngine.psm1"
        $EnergyPath = "$GameDir\NSM_EnergyEngine.psm1"
        $PersistencePath = "$GameDir\NSM_PlayerPersistence.psm1"
        $SessionPath = "$GameDir\NSM_GameSession.psm1"
        $ResourcePath = "$GameDir\NSM_ResourceEngine.psm1"
        
        Remove-Module NSM_GameConfig, NSM_GameDomain, NSM_TokenEngine, NSM_GameEngine, NSM_EnergyEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_ResourceEngine, NSM_SupportAI, NSM_GameRouter -ErrorAction SilentlyContinue
        
        Import-Module $ConfigPath -Force
        Import-Module $DomainPath -Force
        Import-Module $TokenPath -Force
        Import-Module $EnergyPath -Force
        Import-Module $PersistencePath -Force
        Import-Module $SessionPath -Force
        Import-Module $ResourcePath -Force
        Import-Module $EnginePath -Force
        Import-Module $ModuleFile -Force
        Import-Module $RouterFile -Force
        
        $TestChatId = "TG_AI_TEST_001"
        Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/start" | Out-Null
        
        # Test 1: Ask without Soft Tokens
        $Result1 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/ask simple how to farm?"
        if ($Result1 -notmatch "InsufficientSoftToken") { throw "Test 1 Failed: Should require Soft Token. Got: $Result1" }
        
        # Grant Tokens and Test Ask
        $Player = Import-NSMPlayer -PlayerId $TestChatId
        Grant-NSMToken -Player $Player -Amount 100 -TokenType NSM_Soft | Out-Null
        Export-NSMPlayer -Player $Player | Out-Null
        
        $Result2 = Invoke-NSMGameCommand -ChatId $TestChatId -CommandText "/ask simple how to farm?"
        if ($Result2 -notmatch "AI_RESPONSE") { throw "Test 2 Failed: Should get AI response. Got: $Result2" }
        
        $Player2 = Import-NSMPlayer -PlayerId $TestChatId
        if ($Player2.Resources.NSM_Soft -ne 95) { throw "Test 2 Failed: 5 Soft tokens not deducted." }
        
        Write-Host "  [OK] Integration Tests Passed." -ForegroundColor Green
    } catch {
        throw "Integration Test Failed: $_"
    }

    # 6. Registry
    Write-Host "[CMD_124] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_124_001"
            task = "AI Support Engine & Token-Gated Integration"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_125"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_124_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_124 AI SUPPORT ENGINE COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_124_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_124" -Action { Build-AiSupportEngine }
} else {
    Build-AiSupportEngine
}
