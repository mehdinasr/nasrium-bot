Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$File="D:\NASRIUM\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

$json=Get-Content $File -Raw | ConvertFrom-Json

if($json.Skills.Count -lt 1){

    throw "No skills found."

}

foreach($s in $json.Skills){

    if([string]::IsNullOrWhiteSpace($s.SkillId)){throw "SkillId missing"}

    if([string]::IsNullOrWhiteSpace($s.Name)){throw "Name missing"}

}

Write-Host ""
Write-Host "VALIDATION PASSED" -ForegroundColor Green
Write-Host "CMD_027 STEP-003 SUCCESS" -ForegroundColor Green

