# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_166
# File ID   : CMD_166_001
# Module    : Infrastructure | Dockerfile Fix
# Component : Fix Dockerfile for Railway Build
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_166 - DOCKERFILE FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_166" -ForegroundColor Yellow
Write-Host "File ID   : CMD_166_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Dockerfile Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Dockerfile for Railway Build" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Copy package.json to root
Write-Host "[STEP 1] Copying package.json to root..." -ForegroundColor Cyan
Copy-Item "bot\package.json" "package.json" -Force
Copy-Item "bot\package-lock.json" "package-lock.json" -Force
Write-Host "[OK] package.json copied" -ForegroundColor Green

# Step 2: Fix Dockerfile
Write-Host ""
Write-Host "[STEP 2] Fixing Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM node:18-alpine
WORKDIR /app

# Copy package files from root
COPY package*.json ./
RUN npm install

# Copy source files
COPY bot/src ./src
COPY bot/.env ./.env

# Expose port
EXPOSE 8080

# Start command
CMD ["node", "src/index.js"]
"@

$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile fixed" -ForegroundColor Green

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_166: Fix Dockerfile for Railway build"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_166_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
