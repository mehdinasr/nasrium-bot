# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_131
# File ID   : CMD_131_001
# Module    : Governance
# Component : Distinctive Game Theme & Concept Ratification
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$OrchPath = "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
if (Test-Path $OrchPath) { . $OrchPath }

function Ratify-ThemeShift {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM DISTINCTIVE THEME RATIFICATION" -ForegroundColor Cyan
    Write-Host "Command   : CMD_131" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    $Root = "D:\NASRIUM"
    $DocsDir = "$Root\Core\Knowledge\AI Governance Package\Documentation"
    $DocFile = Join-Path $DocsDir "09_GAME_ECONOMICS_AND_MECHANICS.md"
    $DocContent = Get-Content $DocFile -Raw

    $ThemeRules = @"

## 16. Distinctive Theme & Concept (Copyright Safety)
- NASRIUM is NOT a medieval/fantasy game. It is a **Cyberpunk/Web3 Ecosystem Simulator**.
- **Base:** "Data Node" (not Village).
- **Main Building:** "AI Core" (not Town Hall).
- **Troops:** "Agents" or "Bots" (not Barbarians/Archers).
- **Attack:** "Raid" or "Hack" (not Battle).
- **Clan:** "Syndicate" or "Network" (not Clan).
- **Shield:** "Firewall" (not Shield).
- **Builders:** "Compilers" (not Builders).
- This ensures complete distinction from existing titles while preserving the proven strategic game loop.
"@

    $DocContent += $ThemeRules
    try {
        [System.IO.File]::WriteAllText($DocFile, $DocContent, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Governance Document Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update Governance Doc: $_"
    }

    # Registry
    Write-Host "[CMD_131] Updating Registry..." -ForegroundColor Cyan
    try {
        $RegistryPath = "$Root\Core\Registry"
        $stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $state = @{
            cmd_id = "CMD_131_001"
            task = "Distinctive Game Theme & Concept Ratification"
            status = "COMPLETED"
            completed_at = $stampISO
            next_step = "CMD_132"
        } | ConvertTo-Json -Depth 3
        [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_131_001_state.json"), $state, [System.Text.Encoding]::UTF8)
        Write-Host "  [OK] Registry Updated." -ForegroundColor Green
    } catch {
        throw "Failed to update registry: $_"
    }

    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_131 THEME RATIFICATION COMPLETE" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_131_COMPLETE" -ForegroundColor Green
}

if (Get-Command Invoke-NasriumCommand -ErrorAction SilentlyContinue) {
    Invoke-NasriumCommand -CmdId "CMD_131" -Action { Ratify-ThemeShift }
} else {
    Ratify-ThemeShift
}
