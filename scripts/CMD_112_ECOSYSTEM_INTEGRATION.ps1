# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_112
# File ID   : CMD_112_001
# Module    : Governance
# Component : Ecosystem Cross-Module Integration & State Seal
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Invoke-EcosystemIntegration {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ECOSYSTEM INTEGRATION TEST" -ForegroundColor Cyan
    Write-Host "Command   : CMD_112" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $GameDir = "$Root\Core\Modules\Game"
    $InfraDir = "$Root\Core\Modules\Infrastructure"
    $Web3Dir = "$Root\Core\Modules\Web3"
    $AiDir = "$Root\Core\Modules\AI"

    Write-Host "[CMD_112] Loading All Ecosystem Modules..." -ForegroundColor Cyan
    try {
        Remove-Module NSM_GameDomain, NSM_GameConfig, NSM_GameEngine, NSM_ResourceEngine, NSM_PlayerPersistence, NSM_GameSession, NSM_TokenEngine -ErrorAction SilentlyContinue
        Remove-Module NSM_GameRouter, NSM_TelegramAPI, NSM_TonApi, NSM_AgentCore -ErrorAction SilentlyContinue
        
        Import-Module (Join-Path $GameDir "NSM_GameConfig.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameDomain.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_ResourceEngine.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_PlayerPersistence.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_GameSession.psm1") -Force
        Import-Module (Join-Path $GameDir "NSM_TokenEngine.psm1") -Force
        
        Import-Module (Join-Path $InfraDir "NSM_TelegramAPI.psm1") -Force
        Import-Module (Join-Path $InfraDir "NSM_GameRouter.psm1") -Force
        
        Import-Module (Join-Path $Web3Dir "NSM_TonApi.psm1") -Force
        Import-Module (Join-Path $AiDir "NSM_AgentCore.psm1") -Force
        
        Write-Host "  [OK] All Modules Loaded Successfully." -ForegroundColor Green
    } catch {
        throw "Module Loading Failed: $_"
    }

    Write-Host "[CMD_112] Running Cross-Module Workflow..." -ForegroundColor Cyan
    try {
        # 1. Telegram receives command (Router)
        $ChatId = "ECO_TEST_001"
        $BuildResult = Invoke-NSMGameCommand -ChatId $ChatId -CommandText "/build GoldMine"
        if ($BuildResult -notmatch "SUCCESS") { throw "Workflow Step 1 Failed: Router/Build error." }
        
        # 2. AI Agent executes task
        $Agent = New-NSMAgent -Name "EcoMonitor" -Capabilities @("Monitoring")
        $AgentResult = Invoke-NSMAgentTask -Agent $Agent -TaskPrompt "Check economy"
        if ($AgentResult.Status -ne "SUCCESS") { throw "Workflow Step 2 Failed: AI Agent error." }
        
        # 3. TON API check (Mocked safe failure)
        $TonResult = Get-NSMTonWalletBalance -WalletAddress "EQATest"
        if ($TonResult.Reason -ne "TonApiKeyNotConfigured") { throw "Workflow Step 3 Failed: TON API unexpected response." }
        
        # 4. Token Economy operation
        $Player = Load-NSMPlayer -PlayerId $ChatId
        $RewardResult = Reward-NSMToken -Player $Player -Amount 5.0
        if ($RewardResult.Status -ne "SUCCESS") { throw "Workflow Step 4 Failed: Token Engine error." }
        
        Write-Host "  [OK] Cross-Module Workflow Passed." -ForegroundColor Green
    } catch {
        throw "Cross-Module Test Failed: $_"
    }

    Write-Host "[CMD_112] Updating Project State & Governance..." -ForegroundColor Cyan
    try {
        $StateFile = "$Root\Core\Knowledge\AI Governance Package\02_PROJECT_STATE.json"
        $StateJson = Get-Content $StateFile -Raw | ConvertFrom-Json
        $StateJson.current_phase.id = "PHASE_3"
        $StateJson.current_phase.name = "Game & Ecosystem Core Architecture"
        $StateJson.current_phase.status = "COMPLETED"
        $StateJson | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
        
        Write-Host "  [OK] Project State Updated to PHASE_3 COMPLETE." -ForegroundColor Green
    } catch {
        throw "Failed to update project state: $_"
    }

    Write-Host "[CMD_112] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_112_001"
            task = "Ecosystem Cross-Module Integration & State Seal"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_113"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_112_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_112 ECOSYSTEM INTEGRATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_112_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_112" -Action { Invoke-EcosystemIntegration }
} else {
    Invoke-EcosystemIntegration
}
