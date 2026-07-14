Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$File="D:\NASRIUM\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

(Get-FileHash $File -Algorithm SHA256).Hash |
Set-Content "$File.sha256"

Write-Host ""
Write-Host "SHA256 GENERATED" -ForegroundColor Green
Write-Host "CMD_027 STEP-004 SUCCESS" -ForegroundColor Green

