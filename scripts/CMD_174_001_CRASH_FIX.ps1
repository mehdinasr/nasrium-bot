# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_174
# File ID   : CMD_174_001
# Module    : Infrastructure | Crash Fix
# Component : Fix Railway deployment crash
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_174 - CRASH FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_174" -ForegroundColor Yellow
Write-Host "File ID   : CMD_174_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Crash Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Railway deployment crash" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Check if .env has BOT_TOKEN
Write-Host "[STEP 1] Checking .env file..." -ForegroundColor Cyan
if (Test-Path ".env") {
    $envContent = Get-Content ".env" -Raw
    if ($envContent -match "BOT_TOKEN") {
        Write-Host "[OK] BOT_TOKEN found in .env" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] BOT_TOKEN NOT found in .env!" -ForegroundColor Red
        Write-Host "You need to add BOT_TOKEN to Railway Variables!" -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARNING] .env file not found!" -ForegroundColor Red
}

# Step 2: Fix index.js to use Railway PORT
Write-Host ""
Write-Host "[STEP 2] Fixing index.js for Railway PORT..." -ForegroundColor Cyan
$indexPath = "src/index.js"
if (Test-Path $indexPath) {
    $content = Get-Content $indexPath -Raw
    
    # Replace hardcoded port with process.env.PORT
    $content = $content -replace "const PORT = \d+;", "const PORT = process.env.PORT || 8080;"
    $content = $content -replace "const port = \d+;", "const port = process.env.PORT || 8080;"
    
    # Add health check endpoint if not exists
    if ($content -notmatch "app.get\(['`"]\/['`"]") {
        $healthCheck = @"

// Railway Health Check
app.get('/', (req, res) => {
    res.status(200).json({ status: 'ok', service: 'nasrium-bot' });
});
"@
        $content = $content + $healthCheck
    }
    
    $content | Set-Content $indexPath -Encoding UTF8
    Write-Host "[OK] index.js fixed for Railway" -ForegroundColor Green
} else {
    Write-Host "[WARNING] src/index.js not found!" -ForegroundColor Red
}

# Step 3: Update Dockerfile to remove health check (Railway handles it)
Write-Host ""
Write-Host "[STEP 3] Updating Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM node:18-alpine
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port (Railway assigns dynamically)
EXPOSE 8080

# Start command
CMD ["node", "src/index.js"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile updated" -ForegroundColor Green

# Step 4: Commit and push
Write-Host ""
Write-Host "[STEP 4] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_174: Fix Railway crash - PORT and health check"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_174_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Go to Railway Dashboard" -ForegroundColor Cyan
Write-Host "2. Click 'Variables' tab" -ForegroundColor Cyan
Write-Host "3. Add: BOT_TOKEN = your_telegram_bot_token" -ForegroundColor Cyan
Write-Host "4. Click 'Deploy' button" -ForegroundColor Cyan
Write-Host ""
Write-Host "The bot should stay green now!" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_174
# File ID   : CMD_174_001
# Module    : Infrastructure | Crash Fix
# Component : Fix Railway deployment crash
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_174 - CRASH FIX" -ForegroundColor Cyan
Write-Host "Command   : CMD_174" -ForegroundColor Yellow
Write-Host "File ID   : CMD_174_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Crash Fix" -ForegroundColor Yellow
Write-Host "Component : Fix Railway deployment crash" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$RailwayDir = "D:\NASRIUM\railway-deploy"
Set-Location $RailwayDir

# Step 1: Check if .env has BOT_TOKEN
Write-Host "[STEP 1] Checking .env file..." -ForegroundColor Cyan
if (Test-Path ".env") {
    $envContent = Get-Content ".env" -Raw
    if ($envContent -match "BOT_TOKEN") {
        Write-Host "[OK] BOT_TOKEN found in .env" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] BOT_TOKEN NOT found in .env!" -ForegroundColor Red
        Write-Host "You need to add BOT_TOKEN to Railway Variables!" -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARNING] .env file not found!" -ForegroundColor Red
}

# Step 2: Fix index.js to use Railway PORT
Write-Host ""
Write-Host "[STEP 2] Fixing index.js for Railway PORT..." -ForegroundColor Cyan
$indexPath = "src/index.js"
if (Test-Path $indexPath) {
    $content = Get-Content $indexPath -Raw
    
    # Replace hardcoded port with process.env.PORT
    $content = $content -replace "const PORT = \d+;", "const PORT = process.env.PORT || 8080;"
    $content = $content -replace "const port = \d+;", "const port = process.env.PORT || 8080;"
    
    # Add health check endpoint if not exists
    if ($content -notmatch "app.get\(['`"]\/['`"]") {
        $healthCheck = @"

// Railway Health Check
app.get('/', (req, res) => {
    res.status(200).json({ status: 'ok', service: 'nasrium-bot' });
});
"@
        $content = $content + $healthCheck
    }
    
    $content | Set-Content $indexPath -Encoding UTF8
    Write-Host "[OK] index.js fixed for Railway" -ForegroundColor Green
} else {
    Write-Host "[WARNING] src/index.js not found!" -ForegroundColor Red
}

# Step 3: Update Dockerfile to remove health check (Railway handles it)
Write-Host ""
Write-Host "[STEP 3] Updating Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM node:18-alpine
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port (Railway assigns dynamically)
EXPOSE 8080

# Start command
CMD ["node", "src/index.js"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile updated" -ForegroundColor Green

# Step 4: Commit and push
Write-Host ""
Write-Host "[STEP 4] Committing and pushing..." -ForegroundColor Cyan
git add .
git commit -m "CMD_174: Fix Railway crash - PORT and health check"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_174_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Go to Railway Dashboard" -ForegroundColor Cyan
Write-Host "2. Click 'Variables' tab" -ForegroundColor Cyan
Write-Host "3. Add: BOT_TOKEN = your_telegram_bot_token" -ForegroundColor Cyan
Write-Host "4. Click 'Deploy' button" -ForegroundColor Cyan
Write-Host ""
Write-Host "The bot should stay green now!" -ForegroundColor Green
