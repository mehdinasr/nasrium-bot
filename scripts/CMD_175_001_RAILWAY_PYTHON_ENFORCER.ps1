# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_175
# File ID   : CMD_175_001
# Module    : Infrastructure | Railway Enforcer
# Component : Force Python Environment, Erase Node.js & Create railway.toml
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_175 - RAILWAY PYTHON ENFORCER" -ForegroundColor Cyan
Write-Host "Command   : CMD_175" -ForegroundColor Yellow
Write-Host "File ID   : CMD_175_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | Railway Enforcer" -ForegroundColor Yellow
Write-Host "Component : Force Python, Erase Node.js" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

# Step 1: Erase all Node.js files and cache
Write-Host "[STEP 1] Erasing Node.js files from system and Git..." -ForegroundColor Cyan
$NodeTargets = @("src", "package.json", "package-lock.json", "node_modules", "nixpacks.toml", ".nixpacks", "Procfile")
foreach ($item in $NodeTargets) {
    if (Test-Path $item) {
        Remove-Item -Recurse -Force $item -ErrorAction SilentlyContinue
    }
    git rm -r --cached $item -ErrorAction SilentlyContinue
}
Write-Host "[OK] Node.js traces removed" -ForegroundColor Green

# Step 2: Create railway.toml (This forces Railway to use Dockerfile)
Write-Host ""
Write-Host "[STEP 2] Creating railway.toml (Builder Enforcer)..." -ForegroundColor Cyan
$railwayToml = @"
[build]
builder = "DOCKERFILE"
dockerfilePath = "./Dockerfile"

[deploy]
startCommand = "python main.py"
restartPolicyType = "ON_FAILURE"
"@
$railwayToml | Set-Content "railway.toml" -Encoding UTF8
Write-Host "[OK] railway.toml created" -ForegroundColor Green

# Step 3: Ensure Python Dockerfile is standard
Write-Host ""
Write-Host "[STEP 3] Verifying Python Dockerfile..." -ForegroundColor Cyan
$dockerfile = @"
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "main.py"]
"@
$dockerfile | Set-Content "Dockerfile" -Encoding UTF8
Write-Host "[OK] Dockerfile verified" -ForegroundColor Green

# Step 4: Update .dockerignore to block Node.js from reaching Railway
Write-Host ""
Write-Host "[STEP 4] Updating .dockerignore..." -ForegroundColor Cyan
$dockerignore = @"
.git
.gitignore
__pycache__
*.pyc
node_modules
package.json
package-lock.json
src
"@
$dockerignore | Set-Content ".dockerignore" -Encoding UTF8
Write-Host "[OK] .dockerignore updated" -ForegroundColor Green

# Step 5: Commit and Force Push
Write-Host ""
Write-Host "[STEP 5] Committing and Force Pushing..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_175: Enforce Python via railway.toml and erase Node.js"
$branch = git branch --show-current
git push origin $branch --force
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_175_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "CRITICAL RAILWAY DASHBOARD STEP:" -ForegroundColor Red
Write-Host "1. Go to Railway Dashboard" -ForegroundColor White
Write-Host "2. Click on your Project -> Settings" -ForegroundColor White
Write-Host "3. Ensure Builder is set to: Dockerfile" -ForegroundColor Yellow
Write-Host "4. Go to Deployments tab" -ForegroundColor White
Write-Host "5. Click '...' and select: Clear Build Cache and Deploy" -ForegroundColor Yellow
