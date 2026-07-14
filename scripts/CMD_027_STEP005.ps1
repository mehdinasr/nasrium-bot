Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$Root="D:\NASRIUM\Data\Balance\Skills"

$ValidationFile="$Root\NSM_SKILL_VALIDATION_V1.json"

$Validation=[ordered]@{

    Metadata=[ordered]@{

        Module="CMD_027"

        Version="1.0.0"

        Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Passed=$true

    Warnings=@()

    Errors=@()

}

$Validation |
ConvertTo-Json -Depth 10 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_027 STEP-005 SUCCESS" -ForegroundColor Green

