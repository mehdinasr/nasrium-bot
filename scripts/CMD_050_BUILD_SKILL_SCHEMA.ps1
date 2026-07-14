# ================================================================================
# NASRIUM PROJECT
# CMD_050_BUILD_SKILL_SCHEMA
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

Module="CMD_050"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Skills=@()

}

$Skill |
ConvertTo-Json -Depth 20 |
Set-Content $SkillFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_050 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_050_BUILD_SKILL_SCHEMA
# STEP 002
# ================================================================================
#
# Skill Definitions
#
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$SkillFile="$Root\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

$Skill=Get-Content $SkillFile -Raw | ConvertFrom-Json

$Skill.Skills=@(

    [PSCustomObject]@{

        Id="skill_001"

        Name="Power Strike"

        Category="Active"

        DamageType="Physical"

        Power=150

        Cooldown=5

        ManaCost=20

        TargetType="SingleEnemy"

        UnlockLevel=1

    },

    [PSCustomObject]@{

        Id="skill_002"

        Name="Fireball"

        Category="Active"

        DamageType="Magic"

        Power=220

        Cooldown=8

        ManaCost=35

        TargetType="AreaEnemy"

        UnlockLevel=5

    },

    [PSCustomObject]@{

        Id="skill_003"

        Name="Guardian Aura"

        Category="Passive"

        DamageType="None"

        Power=0

        Cooldown=0

        ManaCost=0

        TargetType="Self"

        UnlockLevel=10

    },

    [PSCustomObject]@{

        Id="skill_004"

        Name="Divine Heal"

        Category="Support"

        DamageType="Healing"

        Power=300

        Cooldown=12

        ManaCost=50

        TargetType="SingleAlly"

        UnlockLevel=15

    }

)

$Skill |
ConvertTo-Json -Depth 20 |
Set-Content $SkillFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_050 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_050_BUILD_SKILL_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$SkillFile="$Root\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_SKILL_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_SKILL_VALIDATION_V1.json"

$Skill=Get-Content $SkillFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $SkillFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_050"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    SkillCount=@($Skill.Skills).Count

    File=$SkillFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_050"

    Status="SUCCESS"

    SkillFile=(Test-Path $SkillFile)

    MetadataFile=(Test-Path $MetadataFile)

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_050 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_050_BUILD_SKILL_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$SkillFile="$Root\Data\Balance\Skills\NSM_SKILL_SCHEMA_V1.json"

$BackupDir="$Root\Backups"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

if(!(Test-Path $BackupDir)){
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

if(!(Test-Path $HistoryDir)){
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
}

if(!(Test-Path $ReportDir)){
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile="$BackupDir\NSM_SKILL_SCHEMA_$Time.json"

Copy-Item $SkillFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

    Command="CMD_050"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$SkillFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $SkillFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_050_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_050
STATUS  : SUCCESS

FILE
----
$SkillFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $SkillFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_050_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_050 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

