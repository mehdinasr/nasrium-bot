# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_173
# File ID   : CMD_173_001
# Module    : Infrastructure | Dockerfile Final Fix
# Component : Fix Dockerfile for Railway build
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_173 - DOCKERFILE FINAL FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_173" -ForegroundColor Yellow
Write-Host "File ID   : CMD_173_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Dockerfile Final Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Dockerfile for Railway build" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Create proper Dockerfile
Write-Host "[STEP 1] Creating proper Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM node:18-alpine
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start command
CMD ["node", "src/index.js"]
"@

$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile created" -ForegroundColor Green

# Step 2: Create .dockerignore
Write-Host ""
Write-Host "[STEP 2] Creating .dockerignore..." -ForegroundColor Cyan
$dockerignore = @"
node_modules
npm-debug.log
.git
"@
$dockerignore | Set-Content ".dockerignore" -Encoding UTF8
Write-Host "[OK] .dockerignore created" -ForegroundColor Green

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_173: Fix Dockerfile for Railway"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_173_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway!" -ForegroundColor Yellow
Write-Host "Select Dockerfile builder and Deploy!" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_173
# File ID   : CMD_173_001
# Module    : Infrastructure | Dockerfile Final Fix
# Component : Fix Dockerfile for Railway build
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_173 - DOCKERFILE FINAL FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_173" -ForegroundColor Yellow
Write-Host "File ID   : CMD_173_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Dockerfile Final Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Dockerfile for Railway build" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Create proper Dockerfile
Write-Host "[STEP 1] Creating proper Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM node:18-alpine
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start command
CMD ["node", "src/index.js"]
"@

$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile created" -ForegroundColor Green

# Step 2: Create .dockerignore
Write-Host ""
Write-Host "[STEP 2] Creating .dockerignore..." -ForegroundColor Cyan
$dockerignore = @"
node_modules
npm-debug.log
.git
"@
$dockerignore | Set-Content ".dockerignore" -Encoding UTF8
Write-Host "[OK] .dockerignore created" -ForegroundColor Green

# Step 3: Commit and push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_173: Fix Dockerfile for Railway"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_173_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT: Go to Railway!" -ForegroundColor Yellow
Write-Host "Select Dockerfile builder and Deploy!" -ForegroundColor Green
