# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_033
# File ID   : CMD_033_001
# Module    : Infrastructure | Mini App Build Fix
# Component : Fix package.json BOM and rebuild clean
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_033 - BUILD FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_033" -ForegroundColor Yellow
Write-Host "File ID   : CMD_033_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Mini App Build Fix" -ForegroundColor Yellow
Write-Host "Component : Fix package.json BOM and rebuild clean" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$MiniAppDir = "D:\NASRIUM\mini-app"
Set-Location $MiniAppDir

# Step 1: Remove corrupted files
Write-Host "[STEP 1] Removing corrupted files..." -ForegroundColor Cyan
Remove-Item "package.json" -Force -ErrorAction SilentlyContinue
Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Corrupted files removed" -ForegroundColor Green

# Step 2: Create clean package.json without BOM
Write-Host ""
Write-Host "[STEP 2] Creating clean package.json..." -ForegroundColor Cyan
$jsonContent = '{
  "name": "nasrium-mini-app",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "@tonconnect/ui-react": "^2.0.0",
    "axios": "^1.6.0",
    "react-router-dom": "^6.20.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": ["react-app"]
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  }
}'
[System.IO.File]::WriteAllText("$MiniAppDir\package.json", $jsonContent, [System.Text.UTF8Encoding]::new($false))
Write-Host "[OK] Clean package.json created (no BOM)" -ForegroundColor Green

# Step 3: Install dependencies
Write-Host ""
Write-Host "[STEP 3] Installing dependencies..." -ForegroundColor Cyan
npm install
Write-Host "[OK] Dependencies installed" -ForegroundColor Green

# Step 4: Build production
Write-Host ""
Write-Host "[STEP 4] Building production..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Build successful" -ForegroundColor Green

# Step 5: Deploy to Vercel
Write-Host ""
Write-Host "[STEP 5] Deploying to Vercel..." -ForegroundColor Cyan
npx vercel --prod --yes
Write-Host "[OK] Deployed to Vercel" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_033_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
