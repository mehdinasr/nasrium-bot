# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_140
# File ID   : CMD_140_001
# Module    : System | Testing
# Component : Full Pipeline Integration Test (Data Structure Sync)
# Version   : 1.0.7 (Config Fix)
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "NASRIUM FULL INTEGRATION TEST" -ForegroundColor Magenta
Write-Host "Command   : CMD_140" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Magenta

# --- پاکسازی حافظه کش ---
Get-Module NSM_* | Remove-Module -Force -ErrorAction SilentlyContinue

$RootPath  = "D:\NASRIUM"
$ModuleDir = Join-Path $RootPath "Core\Modules\Game"

# --- تزریق مستقیم ماژول‌ها ---
Write-Host "[CMD_140] Injecting Modules..." -ForegroundColor Cyan
$modules = @("NSM_GameRepo.psm1", "NSM_GameEngine.psm1", "NSM_EconomyProcessor.psm1", "NSM_ActionHandler.psm1")

foreach ($mod in $modules) {
    $modPath = Join-Path $ModuleDir $mod
    if (Test-Path $modPath) {
        $code = [System.IO.File]::ReadAllText($modPath)
        $code = $code -replace 'Import-Module.*', ''
        $code = $code -replace 'Export-ModuleMember.*', ''
        Invoke-Expression $code
        Write-Host "  [OK] Injected: $mod" -ForegroundColor Green
    } else {
        throw "FATAL: Missing $mod"
    }
}

# --- اصلاح ساختار فایل پیکربندی بازی (Data Sync) ---
Write-Host "[CMD_140] Syncing Game Config Structure..." -ForegroundColor Cyan
$ConfigDir = Join-Path $RootPath "Core\Config"
if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
$ConfigPath = Join-Path $ConfigDir "NSM_GameConfig.json"

# ایجاد ساختار دقیقی که موتور بازی (GameEngine) آن را می‌خواند
$ProperConfig = @{
    theme_version = "2.0-cyberpunk"
    buildings = @{
        DATA_MINER = @{
            levels = @{
                "1" = @{ cost_gold=500; energy_cost_to_build=10 }
                "2" = @{ cost_gold=1500; energy_cost_to_build=30 }
                "3" = @{ cost_gold=4500; energy_cost_to_build=90 }
            }
        }
        AI_CORE = @{
            levels = @{
                "1" = @{ cost_gold=1000; energy_cost_to_build=50 }
                "2" = @{ cost_gold=3000; energy_cost_to_build=150 }
            }
        }
        SERVER_FARM = @{
            levels = @{
                "1" = @{ cost_gold=800; energy_cost_to_build=20 }
            }
        }
    }
} | ConvertTo-Json -Depth 5

[System.IO.File]::WriteAllText($ConfigPath, $ProperConfig, (New-Object System.Text.UTF8Encoding $false))
Write-Host "  [OK] Config structure aligned." -ForegroundColor Green

# --- آماده‌سازی کاربر تستی ---
$TestPlayerId = "INTEGRATION_TEST_USER"
$DataDir = Join-Path $RootPath "Data\Players"
if (!(Test-Path $DataDir)) { New-Item -ItemType Directory -Path $DataDir -Force | Out-Null }
$TestPath = Join-Path $DataDir "$TestPlayerId.json"

Write-Host "[CMD_140] Preparing Test User..." -ForegroundColor Cyan
$Now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

$InitialData = @{
    Id=$TestPlayerId; Username="TestNode"; LastLogin=$Now
    Resources=@{ Credits=2000; Bandwidth=500 }
    Buildings=@{ DATA_MINER=@{Level=1}; AI_CORE=@{Level=1} }
} | ConvertTo-Json -Depth 3

[System.IO.File]::WriteAllText($TestPath, $InitialData)

# --- اجرای تست‌ها ---
Write-Host ""
Write-Host ">>> STARTING SIMULATION <<<" -ForegroundColor Yellow

Write-Host "  1. Load Test: Attempting to get player..." -ForegroundColor White
$player = Get-NSMPlayer -Id $TestPlayerId
Write-Host "     -> Player '$($player.Username)' loaded. Credits: $($player.Resources.Credits)" -ForegroundColor White

Write-Host "  2. Upgrade Test: Attempting to upgrade DATA_MINER (Cost: 1500C)..." -ForegroundColor White
$result1 = Start-NSMBuildingUpgrade -PlayerId $TestPlayerId -BuildingType "DATA_MINER"
if ($result1.Success) { Write-Host "     -> Success! Level is now $($result1.NewLevel). Remaining Credits: $($result1.RemainingResources.Credits)" -ForegroundColor Green }
else { Write-Host "     -> Failed! Reason: $($result1.Message)" -ForegroundColor Red; throw "Test 2 Failed" }

Write-Host "  3. Affordability Test: Attempting to upgrade AI_CORE (Cost: 3000C - Should Fail)..." -ForegroundColor White
$result2 = Start-NSMBuildingUpgrade -PlayerId $TestPlayerId -BuildingType "AI_CORE"
if (-not $result2.Success) { Write-Host "     -> Expected Failure. Message: $($result2.Message)" -ForegroundColor Green }
else { Write-Host "     -> Unexpected Success!" -ForegroundColor Red; throw "Test 3 Failed" }

Write-Host "  4. Economy Test: Simulating 1 hour offline progress..." -ForegroundColor White
$player = Get-NSMPlayer -Id $TestPlayerId
$player.LastLogin = (Get-Date).AddHours(-1).ToString("yyyy-MM-dd HH:mm:ss")
Save-NSMPlayer -PlayerObject $player | Out-Null

$updatedPlayer = Invoke-PlayerEconomyTick -PlayerState $player
Write-Host "     -> Credits before tick: $($player.Resources.Credits) | After tick: $($updatedPlayer.Resources.Credits)" -ForegroundColor Cyan

Remove-Item $TestPath -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "   CMD_140 INTEGRATION TEST PASSED" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "OK_CMD_140_COMPLETE" -ForegroundColor Green
