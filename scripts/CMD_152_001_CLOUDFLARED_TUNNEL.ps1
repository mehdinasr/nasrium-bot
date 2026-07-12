# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_152
# File ID   : CMD_152_001
# Module    : Infrastructure | Tunnel Setup
# Component : Cloudflared Quick Tunnel
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_152 - CLOUDFLARED TUNNEL" -ForegroundColor Cyan
Write-Host "Command   : CMD_152" -ForegroundColor Yellow
Write-Host "File ID   : CMD_152_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Tunnel Setup" -ForegroundColor Yellow
Write-Host "Component : Cloudflared Quick Tunnel" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RootPath = "D:\NASRIUM"
$CloudflaredPath = Join-Path $RootPath "cloudflared.exe"

# Check if cloudflared exists
if (Test-Path $CloudflaredPath) {
    Write-Host "[OK] cloudflared.exe found" -ForegroundColor Green
} else {
    Write-Host "[DOWNLOAD] cloudflared.exe not found. Downloading..." -ForegroundColor Yellow
    
    # Download cloudflared for Windows
    $url = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe"
    Invoke-WebRequest -Uri $url -OutFile $CloudflaredPath
    
    Write-Host "[OK] cloudflared.exe downloaded" -ForegroundColor Green
}

# Start Quick Tunnel
Write-Host ""
Write-Host "Starting Cloudflared Quick Tunnel..." -ForegroundColor Cyan
Write-Host "Local Server: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "Your public URL will appear below:" -ForegroundColor Green
Write-Host "Copy the https://xxx.trycloudflare.com URL" -ForegroundColor Yellow
Write-Host ""

Start-Process -FilePath $CloudflaredPath -ArgumentList "tunnel", "--url", "http://localhost:8080" -NoNewWindow -Wait

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_152_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
