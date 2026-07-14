# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_201_2
# File ID   : CMD_201_2_006
# Module    : Frontend | Mini App Upgrade (Part 2)
# Component : Backend API Injection into mini_api.py
# Version   : 1.0.2
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_201_2 - MINI_API PATCH" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\Nasrium"

$filePath = "mini_api.py"

if (-not (Test-Path $filePath)) {
    Write-Host "[FATAL] mini_api.py not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[STEP 1] Reading mini_api.py safely..." -ForegroundColor Cyan
$lines = Get-Content $filePath
$newLines = [System.Collections.ArrayList]::new()
$apiInjected = $false

foreach ($line in $lines) {
    # Inject API route right before the app.run definition
    if ($line -match "app\.run\(host=" -and -not $apiInjected) {
        Write-Host "[INJECT] Inserting Profile API Endpoint..." -ForegroundColor Yellow
        
        $newLines.Add("") | Out-Null
        $newLines.Add("@app.route(`"/api/profile/<int:uid>`", methods=[""GET""])") | Out-Null
        $newLines.Add("def get_profile_api(uid):") | Out-Null
        $newLines.Add("    try:") | Out-Null
        $newLines.Add("        p = players_collection.find_one({""user_id"": uid})") | Out-Null
        $newLines.Add("        if not p:") | Out-Null
        $newLines.Add("            return jsonify({""error"": ""Player not found""}), 404") | Out-Null
        $newLines.Add("        ") | Out-Null
        $newLines.Add("        return jsonify({") | Out-Null
        $newLines.Add("            ""gold"": p.get(""gold"", 0),") | Out-Null
        $newLines.Add("            ""gems"": p.get(""gems"", 0),") | Out-Null
        $newLines.Add("            ""nsm_soft"": p.get(""nsm_soft"", 0),") | Out-Null
        $newLines.Add("            ""nsm_hard"": p.get(""nsm_hard"", 0),") | Out-Null
        $newLines.Add("            ""th_level"": p.get(""town_hall_level"", 1),") | Out-Null
        $newLines.Add("            ""troops"": p.get(""troops"", 0),") | Out-Null
        $newLines.Add("            ""buildings"": p.get(""buildings"", {""gold_mine"": 0, ""gem_drill"": 0})") | Out-Null
        $newLines.Add("        })") | Out-Null
        $newLines.Add("    except Exception as e:") | Out-Null
        $newLines.Add("        return jsonify({""error"": str(e)}), 500") | Out-Null
        $newLines.Add("") | Out-Null
        
        $apiInjected = $true
    }
    
    $newLines.Add($line) | Out-Null
}

if (-not $apiInjected) { 
    Write-Host "[WARN] Could not find 'app.run' to inject API." -ForegroundColor Red 
} else {
    Write-Host "[OK] Profile API successfully injected." -ForegroundColor Green
}

Write-Host "[STEP 2] Saving modified mini_api.py..." -ForegroundColor Cyan
$newLines | Set-Content $filePath -Encoding UTF8
Write-Host "[OK] mini_api.py updated safely" -ForegroundColor Green

# Step 3: Commit and Push
Write-Host ""
Write-Host "[STEP 3] Committing and pushing..." -ForegroundColor Cyan
git add -A
git commit -m "CMD_201_2: Add Profile API to mini_api.py for Mini App data fetching"
git push origin main --force

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_201_2 PATCH COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
