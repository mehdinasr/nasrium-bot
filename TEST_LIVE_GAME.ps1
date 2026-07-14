# تست کلاینت ناسریوم - این اسکریپت را در یک پنجره دیگر اجرا کنید
$BaseURL = "http://localhost:8080/api"
$TestTgId = "TG_112233445"

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "NASRIUM CLIENT SIMULATION" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta

Write-Host "1. Registering User..." -ForegroundColor Cyan
try {
    $reg = Invoke-RestMethod -Uri "$BaseURL/auth/$TestTgId?name=TestNode" -Method Get
    Write-Host "   Status: User Registered! Credits: $($reg.Resources.Credits)" -ForegroundColor Green
} catch { Write-Host "   Error: $_" -ForegroundColor Red }

Write-Host "2. Fetching Player Data..." -ForegroundColor Cyan
try {
    $data = Invoke-RestMethod -Uri "$BaseURL/player/$TestTgId" -Method Get
    Write-Host "   Data Received: Level 1 AI_CORE found." -ForegroundColor Green
} catch { Write-Host "   Error: $_" -ForegroundColor Red }

Write-Host "3. Upgrading DATA_MINER..." -ForegroundColor Cyan
try {
    $up = Invoke-RestMethod -Uri "$BaseURL/upgrade/$TestTgId?building=DATA_MINER" -Method Get
    Write-Host "   Upgrade Result: Success=$($up.Success), Message=$($up.Message)" -ForegroundColor Green
} catch { Write-Host "   Error: $_" -ForegroundColor Red }

Write-Host "=========================================" -ForegroundColor Green
Write-Host "CLIENT TEST FINISHED" -ForegroundColor Green