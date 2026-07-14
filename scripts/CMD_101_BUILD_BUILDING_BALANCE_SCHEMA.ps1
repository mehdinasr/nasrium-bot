# ================================================================================
# NASRIUM PROJECT
# CMD_101_BUILD_BUILDING_BALANCE_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$BalanceDir = "$Root\Data\Balance\Buildings"

# ساخت پوشه موازنه در صورت عدم وجود
if (!(Test-Path $BalanceDir)) {
    New-Item -ItemType Directory -Path $BalanceDir -Force | Out-Null
}

$SchemaFile = "$BalanceDir\NSM_BUILDING_BALANCE_SCHEMA_V1.json"

$Schema = [ordered]@{
    Metadata = [ordered]@{
        Module      = "CMD_101"
        Version     = "1.0.0"
        Generated   = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Category    = "Game Economy"
        Description = "Building balance sheet including levels, costs, HP, and production rates."
    }
    Buildings = @()
}

$Schema |
ConvertTo-Json -Depth 20 |
Set-Content $SchemaFile -Encoding UTF8 -Force

Write-Host ""
Write-Host "CMD_101 STEP-001 SUCCESS: Building Balance Schema Initialized" -ForegroundColor Green
