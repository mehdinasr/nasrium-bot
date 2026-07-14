# ================================================================================
# NASRIUM PROJECT
# CMD_084_BUILD_WEEKLY_MISSION_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Weekly Mission System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$MissionDir = "$Root\Data\Systems\WeeklyMissions"

if (!(Test-Path $MissionDir)) {
    New-Item -ItemType Directory -Path $MissionDir -Force | Out-Null
}

$MissionFile = "$MissionDir\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_V1.json"

$MissionSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_084"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    WeeklyMissions = @()

}

$MissionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MissionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_084 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_084_BUILD_WEEKLY_MISSION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Weekly Mission System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\WeeklyMissions\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_V1.json"

$MissionSystem=Get-Content $MissionFile -Raw | ConvertFrom-Json

$MissionSystem.WeeklyMissions=@(

    [PSCustomObject]@{

        Id="weekly_001"

        Name="Master Builder"

        Category="Construction"

        Target=50

        Reset="Weekly"

        Reward=@{

            Gold=10000

            Gems=100

            XP=1000

        }

        Active=$true

    },

    [PSCustomObject]@{

        Id="weekly_002"

        Name="Elite Commander"

        Category="Military"

        Target=1000

        Reset="Weekly"

        Reward=@{

            Gold=15000

            Gems=150

            XP=1500

        }

        Active=$true

    },

    [PSCustomObject]@{

        Id="weekly_003"

        Name="Resource Tycoon"

        Category="Economy"

        Target=500000

        Reset="Weekly"

        Reward=@{

            Gold=20000

            Gems=200

            XP=2000

        }

        Active=$true

    },

    [PSCustomObject]@{

        Id="weekly_004"

        Name="Arena Champion"

        Category="Battle"

        Target=50

        Reset="Weekly"

        Reward=@{

            Gold=25000

            Gems=250

            XP=2500

        }

        Active=$true

    }

)

$MissionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MissionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_084 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_084_BUILD_WEEKLY_MISSION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\WeeklyMissions\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_WEEKLY_MISSION_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_WEEKLY_MISSION_VALIDATION_V1.json"

$Mission=Get-Content $MissionFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_084"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    MissionCount=@($Mission.WeeklyMissions).Count

    File=$MissionFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_084"

    Status="SUCCESS"

    SchemaExists=(Test-Path $MissionFile)

    MetadataExists=(Test-Path $MetadataFile)

    MissionCount=@($Mission.WeeklyMissions).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_084 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_084_BUILD_WEEKLY_MISSION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\WeeklyMissions\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $MissionFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_084"

    Module="WEEKLY_MISSION_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$MissionFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_084_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_084_BUILD_WEEKLY_MISSION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\WeeklyMissions\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_084_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_084_HISTORY_","")

$BackupFile="$BackupDir\NSM_WEEKLY_MISSION_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_084
MODULE  : WEEKLY MISSION SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$MissionFile

BACKUP
------
$BackupFile

SHA256
------
$Hash

DATE
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==========================================================

"@

$Report |
Set-Content "$ReportDir\CMD_084_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_084 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

