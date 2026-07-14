# ================================================================================
# NASRIUM
# CMD_094_VALIDATE_PROJECT_STRUCTURE (REVISED WITH PAUSE)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$Required = @(
    "$Root\Core",
    "$Root\Core\Knowledge",
    "$Root\Core\Modules",
    "$Root\Scripts",
    "$Root\Builder",
    "$Root\Builder\History",
    "$Root\Builder\Reports",
    "$Root\Backups",
    "$Root\Data"
)

$Errors = @()

# بررسی وجود پوشهها
foreach ($Item in $Required) {
    if (!(Test-Path $Item)) {
        $Errors += "Missing Folder: $Item"
    }
}

# بررسی وجود فایلهای پایه معماری
$Files = @(
    "$Root\Core\Knowledge\PROJECT_STATE.json",
    "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json",
    "$Root\Core\Knowledge\ROADMAP.json",
    "$Root\Core\Knowledge\NASRIUM_CONSTITUTION.md"
)

foreach ($Item in $Files) {
    if (!(Test-Path $Item)) {
        $Errors += "Missing File: $Item"
    }
}

# پردازش نتیجه اعتبارسنجی
if ($Errors.Count -gt 0) {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host "       PROJECT VALIDATION FAILED         " -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host ""
    $Errors | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
} else {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "       PROJECT VALIDATION SUCCESS        " -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "All required folders and architecture files are present." -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to proceed..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}
