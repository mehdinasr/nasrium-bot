# ================================================================================
# NASRIUM PROJECT
# CMD_027_BUILD_SKILL_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$SkillDir="$Root\Data\Balance\Skills"

if(!(Test-Path $SkillDir)){
    New-Item -ItemType Directory -Path $SkillDir -Force | Out-Null
}

$SkillFile="$SkillDir\NSM_SKILL_SCHEMA_V1.json"

$Skill=[ordered]@{

Metadata=[ordered]@{

Module="CMD_027"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Skills=@()

}

$Skill |
ConvertTo-Json -Depth 20 |
Set-Content $SkillFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_027 STEP-001 SUCCESS" -ForegroundColor Green

