$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "Initializing NASRIUM Environment..." -ForegroundColor Cyan

$RootPath = "D:\NASRIUM"
$ModuleDir = Join-Path $RootPath "Core\Modules\Game"

$modules = @(
    "NSM_GameRepo.psm1",
    "NSM_GameEngine.psm1",
    "NSM_EconomyProcessor.psm1",
    "NSM_ActionHandler.psm1",
    "NSM_UserAuth.psm1",
    "NSM_ApiServer.psm1"
)

foreach ($mod in $modules) {
    $modPath = Join-Path $ModuleDir $mod
    if (Test-Path $modPath) {
        # خواندن فایل به صورت متنی
        $code = [System.IO.File]::ReadAllText($modPath)
        # حذف دستورات مزاحم که باعث خطای اسکوپ میشوند
        $code = $code -replace 'Import-Module.*', ''
        $code = $code -replace 'Export-ModuleMember.*', ''
        # تزریق مستقیم در حافظه
        Invoke-Expression $code
        Write-Host "  [Loaded] $mod" -ForegroundColor Green
    } else {
        throw "FATAL: $mod not found."
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "   NASRIUM SERVER IS STARTING..." -ForegroundColor Yellow
Write-Host "   Open index.html in your browser now!" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow

Start-NSMGameServer -Port 8080
