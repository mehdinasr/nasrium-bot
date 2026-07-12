# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_034
# File ID   : CMD_034_001
# Module    : TON Integration | Connect Manifest
# Component : Create TON Connect manifest for wallet integration
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_034 - TON CONNECT MANIFEST" -ForegroundColor Cyan
Write-Host "Command   : CMD_034" -ForegroundColor Yellow
Write-Host "File ID   : CMD_034_001" -ForegroundColor Yellow
Write-Host "Module    : TON Integration | Connect Manifest" -ForegroundColor Yellow
Write-Host "Component : TON Connect manifest for wallet" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$MiniAppDir = "D:\NASRIUM\mini-app"
$PublicDir = "$MiniAppDir\public"
Set-Location $MiniAppDir

# Step 1: Create tonconnect-manifest.json
Write-Host "[STEP 1] Creating tonconnect-manifest.json..." -ForegroundColor Cyan
$manifest = @{
    url = "https://nasrium.vercel.app"
    name = "NASRIUM"
    iconUrl = "https://nasrium.vercel.app/logo.png"
    termsOfUseUrl = "https://nasrium.vercel.app/terms"
    privacyPolicyUrl = "https://nasrium.vercel.app/privacy"
}
$manifest | ConvertTo-Json -Depth 3 | Set-Content "$PublicDir\tonconnect-manifest.json" -Encoding UTF8
Write-Host "[OK] tonconnect-manifest.json created" -ForegroundColor Green

# Step 2: Create placeholder logo
Write-Host ""
Write-Host "[STEP 2] Creating placeholder logo..." -ForegroundColor Cyan
$svgLogo = '<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00d4ff"/>
      <stop offset="100%" style="stop-color:#7b2cbf"/>
    </linearGradient>
  </defs>
  <rect width="512" height="512" rx="128" fill="url(#grad)"/>
  <text x="256" y="320" font-family="Arial Black, sans-serif" font-size="200" fill="white" text-anchor="middle">N</text>
</svg>'
$svgLogo | Set-Content "$PublicDir\logo.svg" -Encoding UTF8
Write-Host "[OK] logo.svg created" -ForegroundColor Green

# Step 3: Update App.js with correct manifest URL
Write-Host ""
Write-Host "[STEP 3] Updating App.js manifest URL..." -ForegroundColor Cyan
$appPath = "$MiniAppDir\src\App.js"
if (Test-Path $appPath) {
    $appContent = Get-Content $appPath -Raw
    $appContent = $appContent -replace 'const MANIFEST_URL = ".*";', 'const MANIFEST_URL = "https://nasrium.vercel.app/tonconnect-manifest.json";'
    $appContent | Set-Content $appPath -Encoding UTF8
    Write-Host "[OK] App.js updated" -ForegroundColor Green
} else {
    Write-Host "[WARNING] App.js not found" -ForegroundColor Yellow
}

# Step 4: Rebuild and redeploy
Write-Host ""
Write-Host "[STEP 4] Rebuilding Mini App..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Build successful" -ForegroundColor Green

Write-Host ""
Write-Host "[STEP 5] Redeploying to Vercel..." -ForegroundColor Cyan
npx vercel --prod --yes
Write-Host "[OK] Redeployed to Vercel" -ForegroundColor Green

# Step 5: Commit
Write-Host ""
Write-Host "[STEP 6] Committing to GitHub..." -ForegroundColor Cyan
Set-Location "D:\NASRIUM"
git add .
git commit -m "CMD_034: Add TON Connect manifest" --allow-empty
git push origin master
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_034_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "TON CONNECT READY:" -ForegroundColor Yellow
Write-Host "  Manifest: https://nasrium.vercel.app/tonconnect-manifest.json" -ForegroundColor White
Write-Host "  Logo: https://nasrium.vercel.app/logo.svg" -ForegroundColor White
Write-Host ""
Write-Host "NEXT: CMD_036 - API Backend (Mini App to Bot)" -ForegroundColor Magenta
