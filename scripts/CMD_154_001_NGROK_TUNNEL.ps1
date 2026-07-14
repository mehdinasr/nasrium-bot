# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_154
# File ID   : CMD_154_001
# Module    : Infrastructure | Ngrok Tunnel
# Component : Ngrok Quick Tunnel Setup
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_154 - NGROK TUNNEL" -ForegroundColor Cyan
Write-Host "Command   : CMD_154" -ForegroundColor Yellow
Write-Host "File ID   : CMD_154_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Ngrok Tunnel" -ForegroundColor Yellow
Write-Host "Component : Ngrok Quick Tunnel Setup" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RootPath = "D:\NASRIUM"
$NgrokPath = Join-Path $RootPath "ngrok.exe"

# Check if ngrok exists
if (Test-Path $NgrokPath) {
    Write-Host "[OK] ngrok.exe found" -ForegroundColor Green
} else {
    Write-Host "[DOWNLOAD] ngrok.exe not found. Downloading..." -ForegroundColor Yellow
    
    # Download ngrok for Windows
    $url = "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip"
    $zipPath = Join-Path $RootPath "ngrok.zip"
    
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $RootPath -Force
    Remove-Item $zipPath
    
    Write-Host "[OK] ngrok.exe downloaded and extracted" -ForegroundColor Green
}

# Start Ngrok Tunnel
Write-Host ""
Write-Host "Starting Ngrok Tunnel..." -ForegroundColor Cyan
Write-Host "Local Server: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "Your public URL will appear below:" -ForegroundColor Green
Write-Host "Copy the https://xxx.ngrok-free.app URL" -ForegroundColor Yellow
Write-Host ""

Start-Process -FilePath $NgrokPath -ArgumentList "http", "8080" -NoNewWindow -Wait

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_154_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
