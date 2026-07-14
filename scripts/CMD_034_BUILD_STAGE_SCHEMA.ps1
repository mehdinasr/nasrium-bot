# ================================================================================
# NASRIUM PROJECT
# CMD_034_BUILD_STAGE_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$StageDir="$Root\Data\Balance\Stages"

if(!(Test-Path $StageDir)){
    New-Item -ItemType Directory -Path $StageDir -Force | Out-Null
}

$StageFile="$StageDir\NSM_STAGE_SCHEMA_V1.json"

$Stage=[ordered]@{

Metadata=[ordered]@{

Module="CMD_034"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Stages=@()

}

$Stage |
ConvertTo-Json -Depth 20 |
Set-Content $StageFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_034 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_034_BUILD_STAGE_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$StageFile="$Root\Data\Balance\Stages\NSM_STAGE_SCHEMA_V1.json"

$Stage=Get-Content $StageFile -Raw | ConvertFrom-Json

$Stage.Stages=@(

    [PSCustomObject]@{

        Id="stage_001"

        Name="Green Plains"

        World=1

        Chapter=1

        StageNumber=1

        Difficulty="Normal"

        RecommendedLevel=1

        EnergyCost=5

        TimeLimit=300

        EnemyGroups=@(

            "enemy_001",
            "enemy_001",
            "enemy_002"

        )

        Boss=""

        Rewards=[PSCustomObject]@{

            Gold=100

            Experience=50

            DropTable="DROP_STAGE_001"

        }

    },

    [PSCustomObject]@{

        Id="stage_002"

        Name="Dark Forest"

        World=1

        Chapter=1

        StageNumber=2

        Difficulty="Normal"

        RecommendedLevel=3

        EnergyCost=6

        TimeLimit=300

        EnemyGroups=@(

            "enemy_001",
            "enemy_002",
            "enemy_003"

        )

        Boss=""

        Rewards=[PSCustomObject]@{

            Gold=180

            Experience=90

            DropTable="DROP_STAGE_002"

        }

    },

    [PSCustomObject]@{

        Id="stage_003"

        Name="Dragon Cave"

        World=1

        Chapter=1

        StageNumber=3

        Difficulty="Boss"

        RecommendedLevel=10

        EnergyCost=10

        TimeLimit=600

        EnemyGroups=@(

            "enemy_003"

        )

        Boss="enemy_004"

        Rewards=[PSCustomObject]@{

            Gold=1000

            Experience=500

            DropTable="DROP_BOSS_001"

        }

    }

)

$Stage |
ConvertTo-Json -Depth 20 |
Set-Content $StageFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_034 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_034_BUILD_STAGE_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$StageFile="$Root\Data\Balance\Stages\NSM_STAGE_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_STAGE_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_STAGE_VALIDATION_V1.json"

$Stage=Get-Content $StageFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $StageFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_034"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

StageCount=@($Stage.Stages).Count

File=$StageFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_034"

Status="SUCCESS"

StageFile=(Test-Path $StageFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_034 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_034_BUILD_STAGE_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$StageFile="$Root\Data\Balance\Stages\NSM_STAGE_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_STAGE_SCHEMA_$Time.json"

Copy-Item $StageFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_034"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$StageFile

Backup=$BackupFile

SHA256=(Get-FileHash $StageFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_034_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_034
STATUS  : SUCCESS

FILE
----
$StageFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $StageFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_034_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_034 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

