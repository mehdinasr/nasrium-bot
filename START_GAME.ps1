# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_149
# File ID   : CMD_149_001
# Module    : Integration | Launcher
# Component : One-Click Server Starter
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
$stageId = "CMD_149"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$projectRoot = "D:\NASRIUM"
$logsPath = Join-Path $projectRoot "Logs"
New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
$logFile = Join-Path $logsPath "CMD_149_$timestamp.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$time] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

Write-Log "========================================" "HEADER"
Write-Log "NASRIUM CMD_149 - ONE-CLICK STARTER" "HEADER"
Write-Log "========================================" "HEADER"

# --- Start Server ---
Write-Log "--- Starting NASRIUM Server ---" "STEP"
$serverPath = Join-Path $projectRoot "START_NASRIUM_SERVER.ps1"
Start-Process powershell -ArgumentList "-NoExit", "-File", "`"$serverPath`"" -WindowStyle Normal
Write-Log "Server started in new window" "SUCCESS"

# --- Open Browser ---
Write-Log "--- Opening Browser ---" "STEP"
Start-Process "http://localhost:8080"
Write-Log "Browser opened with localhost:8080" "SUCCESS"

# --- Final ---
Write-Log ""
Write-Log "========================================" "HEADER"
Write-Log "CMD_149 COMPLETE" "HEADER"
Write-Log "========================================" "HEADER"
Write-Log "✅ Server: STARTED" "SUCCESS"
Write-Log "✅ Browser: OPENED" "SUCCESS"
Write-Log ""
Write-Log "Game URL: http://localhost:8080" "INFO"
Write-Log ""
Write-Log "To share with others:" "WARNING"
Write-Log "1. Install VPN on your system" "WARNING"
Write-Log "2. Run START_TUNNEL.bat" "WARNING"
Write-Log "3. Get HTTPS URL" "WARNING"
Write-Log "4. Share in Telegram" "WARNING"
