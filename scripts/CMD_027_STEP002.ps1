Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$File="D:\NASRIUM\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

$json=Get-Content $File -Raw | ConvertFrom-Json

$json.Skills += [pscustomobject]@{

    SkillId="SKL_001"

    Name="Sword Slash"

    Category="Attack"

    Description="Basic melee attack."

    MaxLevel=10

    Cooldown=2

    ManaCost=0

    Target="Enemy"

    Formula=[pscustomobject]@{

        BaseDamage=20

        DamageMultiplier=1.25

    }

}

$json |
ConvertTo-Json -Depth 20 |
Set-Content $File -Encoding UTF8

Write-Host ""
Write-Host "CMD_027 STEP-002 SUCCESS" -ForegroundColor Green

