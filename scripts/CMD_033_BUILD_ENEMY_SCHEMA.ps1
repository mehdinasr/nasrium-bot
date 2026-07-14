# ================================================================================
# NASRIUM PROJECT
# CMD_033_BUILD_ENEMY_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EnemyDir="$Root\Data\Balance\Enemies"

if(!(Test-Path $EnemyDir)){
    New-Item -ItemType Directory -Path $EnemyDir -Force | Out-Null
}

$EnemyFile="$EnemyDir\NSM_ENEMY_SCHEMA_V1.json"

$Enemy=[ordered]@{

Metadata=[ordered]@{

Module="CMD_033"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Enemies=@()

}

$Enemy |
ConvertTo-Json -Depth 20 |
Set-Content $EnemyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_033 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_033_BUILD_ENEMY_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EnemyFile="$Root\Data\Balance\Enemies\NSM_ENEMY_SCHEMA_V1.json"

$Enemy=Get-Content $EnemyFile -Raw | ConvertFrom-Json

$Enemy.Enemies=@(

    [PSCustomObject]@{

        Id="enemy_001"

        Name="Goblin"

        Category="Normal"

        Level=1

        HP=120

        Attack=15

        Defense=5

        Speed=10

        CriticalRate=2

        Experience=20

        GoldReward=15

        SkillSet=@("SKL_001")

        AIProfile="Aggressive"

    },

    [PSCustomObject]@{

        Id="enemy_002"

        Name="Orc Warrior"

        Category="Elite"

        Level=5

        HP=650

        Attack=48

        Defense=25

        Speed=8

        CriticalRate=5

        Experience=120

        GoldReward=80

        SkillSet=@("SKL_001")

        AIProfile="Balanced"

    },

    [PSCustomObject]@{

        Id="enemy_003"

        Name="Dark Mage"

        Category="Elite"

        Level=8

        HP=480

        Attack=72

        Defense=12

        Speed=14

        CriticalRate=10

        Experience=220

        GoldReward=140

        SkillSet=@("SKL_001")

        AIProfile="Caster"

    },

    [PSCustomObject]@{

        Id="enemy_004"

        Name="Ancient Dragon"

        Category="Boss"

        Level=30

        HP=25000

        Attack=450

        Defense=180

        Speed=20

        CriticalRate=15

        Experience=5000

        GoldReward=10000

        SkillSet=@("SKL_001")

        AIProfile="Boss"

    }

)

$Enemy |
ConvertTo-Json -Depth 20 |
Set-Content $EnemyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_033 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_033_BUILD_ENEMY_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EnemyFile="$Root\Data\Balance\Enemies\NSM_ENEMY_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_ENEMY_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_ENEMY_VALIDATION_V1.json"

$Enemy=Get-Content $EnemyFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $EnemyFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_033"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

EnemyCount=@($Enemy.Enemies).Count

File=$EnemyFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_033"

Status="SUCCESS"

EnemyFile=(Test-Path $EnemyFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_033 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_033_BUILD_ENEMY_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EnemyFile="$Root\Data\Balance\Enemies\NSM_ENEMY_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_ENEMY_SCHEMA_$Time.json"

Copy-Item $EnemyFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_033"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$EnemyFile

Backup=$BackupFile

SHA256=(Get-FileHash $EnemyFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_033_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_033
STATUS  : SUCCESS

FILE
----
$EnemyFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $EnemyFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_033_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_033 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

