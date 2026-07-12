# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_153
# File ID   : CMD_153_001
# Module    : Infrastructure | Tunnel Test
# Component : Multi-Tunnel Connectivity Test
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_153 - TUNNEL CONNECTIVITY TEST" -ForegroundColor Cyan
Write-Host "Command   : CMD_153" -ForegroundColor Yellow
Write-Host "File ID   : CMD_153_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Tunnel Test" -ForegroundColor Yellow
Write-Host "Component : Multi-Tunnel Connectivity Test" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Testing tunnel endpoints..." -ForegroundColor Cyan
Write-Host ""

# Test Bore
Write-Host "[TEST] bore.pub:7835..." -ForegroundColor Yellow
$boreTest = Test-NetConnection -ComputerName "bore.pub" -Port 7835 -WarningAction SilentlyContinue
if ($boreTest.TcpTestSucceeded) {
    Write-Host "  [OK] Bore is reachable" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Bore is blocked" -ForegroundColor Red
}

# Test Cloudflare
Write-Host "[TEST] api.trycloudflare.com:443..." -ForegroundColor Yellow
$cfTest = Test-NetConnection -ComputerName "api.trycloudflare.com" -Port 443 -WarningAction SilentlyContinue
if ($cfTest.TcpTestSucceeded) {
    Write-Host "  [OK] Cloudflare is reachable" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Cloudflare is blocked" -ForegroundColor Red
}

# Test ngrok
Write-Host "[TEST] tunnel.ngrok.com:443..." -ForegroundColor Yellow
$ngrokTest = Test-NetConnection -ComputerName "tunnel.ngrok.com" -Port 443 -WarningAction SilentlyContinue
if ($ngrokTest.TcpTestSucceeded) {
    Write-Host "  [OK] Ngrok is reachable" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Ngrok is blocked" -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_153_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
