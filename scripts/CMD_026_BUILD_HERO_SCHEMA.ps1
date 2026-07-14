# ================================================================================
# NASRIUM PROJECT
# CMD_026_BUILD_HERO_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$HeroDir="$Root\Data\Balance\Heroes"

if(!(Test-Path $HeroDir)){
    New-Item -ItemType Directory -Path $HeroDir -Force | Out-Null
}

$HeroFile="$HeroDir\NSM_HERO_SCHEMA_V1.json"

$Hero=[ordered]@{

Metadata=[ordered]@{

Module="CMD_026"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Heroes=@()

}

$Hero |
ConvertTo-Json -Depth 20 |
Set-Content $HeroFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_026 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_026_BUILD_HERO_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$HeroFile="$Root\Data\Balance\Heroes\NSM_HERO_SCHEMA_V1.json"

$Hero=Get-Content $HeroFile -Raw | ConvertFrom-Json

$Hero.Heroes=@(

    [PSCustomObject]@{

        Id="hero_001"

        Name="Commander"

        Class="Warrior"

        Rarity="Legendary"

        MaxLevel=100

        BaseHP=1000

        HpMultiplier=1.12

        BaseDamage=120

        DamageMultiplier=1.10

        AttackSpeed=1.20

        MoveSpeed=18

        Ability="Leadership"

    },

    [PSCustomObject]@{

        Id="hero_002"

        Name="Ranger"

        Class="Archer"

        Rarity="Epic"

        MaxLevel=100

        BaseHP=750

        HpMultiplier=1.10

        BaseDamage=145

        DamageMultiplier=1.12

        AttackSpeed=1.35

        MoveSpeed=20

        Ability="Precision Shot"

    }

)

$Hero |
ConvertTo-Json -Depth 20 |
Set-Content $HeroFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_026 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_026_BUILD_HERO_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$HeroFile="$Root\Data\Balance\Heroes\NSM_HERO_SCHEMA_V1.json"

$MetadataFile="$Root\Data\Metadata\NSM_HERO_METADATA_V1.json"

$ValidationFile="$Root\Data\Metadata\NSM_HERO_VALIDATION_V1.json"

$Hero=Get-Content $HeroFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $HeroFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_026"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

HeroCount=@($Hero.Heroes).Count

File=$HeroFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_026"

Status="SUCCESS"

HeroFile=(Test-Path $HeroFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_026 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_026_BUILD_HERO_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$HeroFile="$Root\Data\Balance\Heroes\NSM_HERO_SCHEMA_V1.json"

$BackupDir="$Root\Backups"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile="$BackupDir\NSM_HERO_SCHEMA_$Time.json"

Copy-Item $HeroFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_026"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$HeroFile

Backup=$BackupFile

SHA256=(Get-FileHash $HeroFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_026_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_026
STATUS  : SUCCESS

FILE
----
$HeroFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $HeroFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_026_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_026 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

