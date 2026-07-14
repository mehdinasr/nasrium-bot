# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_118
# File ID   : CMD_118_001
# Module    : Governance
# Component : Game Economics & Mechanics Ratification
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Ratify-GameEconomics {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM GAME ECONOMICS RATIFICATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_118" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"
    $StateFile = "$Root\Core\Knowledge\AI Governance Package\02_PROJECT_STATE.json"

    if (!(Test-Path $DocsDir)) { New-Item -ItemType Directory -Path $DocsDir -Force | Out-Null }

    Write-Host "[CMD_118] Writing 09_GAME_ECONOMICS_AND_MECHANICS.md..." -ForegroundColor Cyan
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    
    $DocLines = @(
        '# NASRIUM GAME ECONOMICS & MECHANICS CONSTITUTION',
        '# Version: 1.0.0',
        '# Status: Ratified Source of Truth',
        '',
        '## 1. Token Supply',
        '- **Total Supply**: 100,000,000,000 NSM (100 Billion)',
        '- Distribution happens across seasons and phases.',
        '',
        '## 2. Dual Token Economy',
        'Players earn two types of tokens:',
        '1. **NSM_Withdraw (Liquid)**: Real token, withdrawable to TON wallet.',
        '2. **NSM_Soft (In-App)**: Non-withdrawable, used for upgrades and in-app shop.',
        '',
        '## 3. Wallet Activation',
        '- Wallet linking and withdrawal features unlock at **Town Hall Level 3**.',
        '',
        '## 4. Town Hall Upgrade Rule',
        '- A Town Hall can only be upgraded if at least **80%** of other buildings/equipment are at the maximum available level.',
        '',
        '## 5. Withdrawal Percentages (By Town Hall Level)',
        '- TH3: 5.0%',
        '- TH4: 5.5%',
        '- TH5: 6.0%',
        '- TH6: 6.5%',
        '- TH7: 7.5%',
        '- TH8: 8.5%',
        '- TH9: 9.0%',
        '',
        '## 6. Soft Token Usage',
        '- Can be converted to Shields in the shop.',
        '- Used for daily upgrade expenses.',
        '',
        '## 7. NFT Shop & Withdrawable Tokens',
        '- NFTs are sold for **NSM_Withdraw** tokens.',
        '- Purchased NFTs can be transferred to the player linked TON wallet.',
        '',
        '## 8. PvP & Attack Mechanics',
        '- Players/Clans can attack other tribes.',
        '- Attacked tribe loses up to **20%** of unshielded Soft Tokens and Gold.',
        '- Attacker receives a portion of the looted resources.',
        '',
        '## 9. Daily Missions',
        '- Daily missions and rewards yield **NSM_Soft** tokens only (Non-withdrawable).',
        '',
        '## 10. Social & Clan Features',
        '- Clan creation, donations, and in-network chat features are core mechanics.'
    )

    try {
        $DocContent = $DocLines -join "`r`n"
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Game Economics Documented." -ForegroundColor Green
    } catch {
        throw "Failed to write document: $_"
    }

    Write-Host "[CMD_118] Updating Project State..." -ForegroundColor Cyan
    try {
        $StateJson = Get-Content $StateFile -Raw | ConvertFrom-Json
        $StateJson.current_phase.id = "PHASE_4"
        $StateJson.current_phase.name = "Game Economics & Mechanics Ratification"
        $StateJson.current_phase.status = "COMPLETED"
        $StateJson | ConvertTo-Json -Depth 5 | Set-Content $StateFile -Encoding UTF8
        Write-Host "  [OK] Project State Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update project state: $_"
    }

    Write-Host "[CMD_118] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_118_001"
            task = "Game Economics & Mechanics Ratification"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_119"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_118_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_118 ECONOMICS RATIFICATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_118_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_118" -Action { Ratify-GameEconomics }
} else {
    Ratify-GameEconomics
}
