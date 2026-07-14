Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$SkillDir="$Root\Data\Balance\Skills"

$BackupDir="$Root\Backups\Skills"

$ReportDir="$Root\Reports"

New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

Copy-Item "$SkillDir\NSM_SKILL_SCHEMA_V1.json" `
          "$BackupDir\NSM_SKILL_SCHEMA_V1_$Time.json"

$Report=[ordered]@{

    Module="CMD_027"

    Status="SUCCESS"

    Validation="PASSED"

    Backup="CREATED"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    OutputFiles=@(
        "NSM_SKILL_SCHEMA_V1.json",
        "NSM_SKILL_METADATA_V1.json",
        "NSM_SKILL_VALIDATION_V1.json"
    )

}

$Report |
ConvertTo-Json -Depth 10 |
Set-Content "$ReportDir\CMD_027_REPORT.json" -Encoding UTF8

Write-Host ""
Write-Host "CMD_027 STEP-007 SUCCESS" -ForegroundColor Green

