# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_201_2
# File ID   : CMD_201_2_002
# Module    : Frontend | Mini App Upgrade (Part 2 - Safe Patch)
# Component : Backend API for Mini App Data Fetching
# Version   : 1.0.1
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_201_2 - SAFE API PATCH" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

$filePath = "main.py"

if (-not (Test-Path $filePath)) {
    Write-Host "[FATAL] main.py not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP 1] Reading main.py safely..." -ForegroundColor Cyan
$lines = Get-Content $filePath
$newLines = [System.Collections.ArrayList]::new()
$apiInjected = $false
$urlPatched = $false

foreach ($line in $lines) {
    # Patch 1: Inject API route right before the run_flask definition
    if ($line -match "def run_flask\(\):" -and -not $apiInjected) {
        Write-Host "[INJECT] Inserting Profile API Endpoint..." -ForegroundColor Yellow
        $newLines.Add("")
        $newLines.Add("# API Endpoint برای ارسال دیتای بازیکن به مینی‌اپ")
        $newLines.Add("@app_flask.route('/api/profile/<int:uid>')")
        $newLines.Add("def get_profile_api(uid):")
        $newLines.Add("    if players_collection is None: return jsonify({`"error`": `"DB offline`"}), 500")
        $newLines.Add("    p = players_collection.find_one({`"user_id`": uid})")
        $newLines.Add("    if not p: return jsonify({`"error`": `"Player not found`"}), 404")
        $newLines.Add("    return jsonify({")
        $newLines.Add("        `"gold`": p.get(`"gold`", 0),")
        $newLines.Add("        `"gems`": p.get(`"gems`", 0),")
        $newLines.Add("        `"nsm_soft`": p.get(`"nsm_soft`", 0),")
        $newLines.Add("        `"nsm_hard`": p.get(`"nsm_hard`", 0),")
        $newLines.Add("        `"th_level`": p.get(`"town_hall_level`", 1),")
        $newLines.Add("        `"troops`": p.get(`"troops`", 0),")
        $newLines.Add("        `"buildings`": p.get(`"buildings`", {`"gold_mine`": 0, `"gem_drill`": 0})")
        $newLines.Add("    })")
        $newLines.Add("")
        $apiInjected = $true
    }

    # Patch 2: Smart URL update
    if ($line -match 'webapp_url = "https://nasrium-bot-production.up.railway.app/mini_app"') {
        Write-Host "[PATCH] Updating WebApp URL with UID parameter..." -ForegroundColor Yellow
        $newLines.Add('webapp_url = f"https://nasrium-bot-production.up.railway.app/mini_app?uid={user.id}"')
        $urlPatched = $true
    } else {
        $newLines.Add($line)
    }
}

if (-not $apiInjected) { Write-Host "[WARN] Could not find 'def run_flask()' to inject API." -ForegroundColor Red }
if (-not $urlPatched) { Write-Host "[WARN] Could not find webapp_url to patch." -ForegroundColor Red }

Write-Host "[STEP 2] Saving modified main.py..." -ForegroundColor Cyan
$newLines | Set-Content $filePath -Encoding UTF8
Write-Host "[OK] main.py updated safely" -ForegroundColor Green

# Step 3: Commit and Push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_201_2: Add Profile API for Mini App data fetching (Safe Patch)"
git push origin main --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_201_2 PATCH COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
