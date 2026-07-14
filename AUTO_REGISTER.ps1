# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_150
# File ID   : CMD_150_001
# Module    : Integration | Auto-Register
# Component : Auto Player Registration
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
$stageId = "CMD_150"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$projectRoot = "D:\NASRIUM"
$logsPath = Join-Path $projectRoot "Logs"
New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
$logFile = Join-Path $logsPath "CMD_150_$timestamp.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$time] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

Write-Log "========================================" "HEADER"
Write-Log "NASRIUM CMD_150 - AUTO REGISTER" "HEADER"
Write-Log "========================================" "HEADER"

# --- Register Player ---
Write-Log "--- Registering Player ---" "STEP"
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/TEST_USER_001?name=Player1" -Method Get -UseBasicParsing -ErrorAction Stop
    $data = $response.Content | ConvertFrom-Json
    Write-Log "Player registered successfully" "SUCCESS"
    Write-Log "Credits: $($data.Resources.Credits)" "SUCCESS"
    Write-Log "Bandwidth: $($data.Resources.Bandwidth)" "SUCCESS"
} catch {
    Write-Log "Failed to register player: $_" "ERROR"
    exit 1
}

# --- Open Browser ---
Write-Log "--- Opening Browser ---" "STEP"
Start-Process "http://localhost:8080"
Write-Log "Browser opened" "SUCCESS"

# --- Final ---
Write-Log ""
Write-Log "========================================" "HEADER"
Write-Log "CMD_150 COMPLETE" "HEADER"
Write-Log "========================================" "HEADER"
Write-Log "✅ Player: REGISTERED" "SUCCESS"
Write-Log "✅ Browser: OPENED" "SUCCESS"
Write-Log ""
Write-Log "Game URL: http://localhost:8080" "INFO"
Write-Log "Credits: 1000 | Bandwidth: 200" "INFO"
