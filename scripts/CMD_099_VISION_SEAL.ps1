# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_099
# File ID   : CMD_099_001
# Module    : Governance
# Component : Ecosystem Vision & Architecture Seal
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Seal-EcosystemVision {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM ECOSYSTEM VISION SEAL" -ForegroundColor Cyan
    Write-Host "Command   : CMD_099" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"
    $StateFile = "$Root\Core\Knowledge\AI Governance Package\02_PROJECT_STATE.json"

    if (!(Test-Path $DocsDir)) { New-Item -ItemType Directory -Path $DocsDir -Force | Out-Null }

    # Step 1: Write Ecosystem Architecture Document
    Write-Host "[CMD_099] Writing ECOSYSTEM_ARCHITECTURE.md..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "ECOSYSTEM_ARCHITECTURE.md"
    
    $DocLines = @(
        '# NASRIUM ECOSYSTEM ARCHITECTURE',
        '# Version: 1.0.0',
        '# Status: Ratified Source of Truth',
        '',
        '## 1. Project Identity',
        '- **Name:** Nasrium (NSM)',
        '- **Type:** Web3 + AI Ecosystem',
        '- **Network:** TON Blockchain',
        '',
        '## 2. Core Vision',
        'Nasrium is an intelligent Web3 ecosystem where the NSM token acts as the economic fuel. Users interact through a Telegram game, AI tools, and digital services.',
        '',
        '## 3. Ecosystem Pillars',
        '1. **Telegram Game (Clash of Clans model):** Primary user acquisition and token sink.',
        '2. **AI Agents & Services:** Personal assistants, automation, and decision systems.',
        '3. **Web3 Infrastructure (TON):** Low-cost wallet integration and smart contracts.',
        '4. **NSM Token Economy:** Utility-driven value, not meme-based speculation.',
        '',
        '## 4. Development Phases',
        '- **Phase 1:** Architecture Bootstrap & Governance (COMPLETED)',
        '- **Phase 2:** Chat & Moderation Engine (COMPLETED)',
        '- **Phase 3:** Game Core Architecture (NEXT)',
        '- **Phase 4:** TON Integration & Token Contracts',
        '- **Phase 5:** AI Agent Infrastructure',
        '',
        '## 5. Architecture Principles',
        '- Modular Design (Loose Coupling, High Cohesion)',
        '- Disk Is Truth (Governance First)',
        '- Ecosystem-First Approach (Not Game-Only)'
    )

    try {
        $DocContent = $DocLines -join "`r`n"
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Ecosystem Architecture Documented." -ForegroundColor Green
    } catch {
        throw "Failed to write document: $_"
    }

    # Step 2: Update Project State
    Write-Host "[CMD_099] Updating 02_PROJECT_STATE.json..." -ForegroundColor Cyan
    try {
        $StateJson = Get-Content $StateFile -Raw | ConvertFrom-Json
        $StateJson.current_phase.id = "PHASE_2"
        $StateJson.current_phase.name = "Chat & Moderation Engine"
        $StateJson.current_phase.status = "COMPLETED"
        $StateJson | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
        Write-Host "  [OK] Project State Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update project state: $_"
    }

    # Step 3: Re-Seal Governance Manifest
    Write-Host "[CMD_099] Re-sealing Governance Manifest..." -ForegroundColor Cyan
    try {
        $BuilderPath = "$Root\Core\Builder\Governance\BUILD_GOVERNANCE_PACKAGE.ps1"
        if (Test-Path $BuilderPath) {
            & $BuilderPath
        } else {
            Write-Host "  [WARN] Builder not found. Manual manifest rebuild required." -ForegroundColor Yellow
        }
    } catch {
        throw "Failed to re-seal manifest: $_"
    }

    # Step 4: Registry Update
    Write-Host "[CMD_099] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_099_001"
            task = "Ecosystem Vision & Architecture Seal"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_100"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_099_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_099 VISION SEAL COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_099_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_099" -Action { Seal-EcosystemVision }
} else {
    Seal-EcosystemVision
}
