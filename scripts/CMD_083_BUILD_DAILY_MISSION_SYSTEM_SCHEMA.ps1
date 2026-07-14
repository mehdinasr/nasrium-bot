# ================================================================================
# NASRIUM PROJECT
# CMD_083_BUILD_DAILY_MISSION_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Daily Mission System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$MissionDir = "$Root\Data\Systems\DailyMissions"

if (!(Test-Path $MissionDir)) {
    New-Item -ItemType Directory -Path $MissionDir -Force | Out-Null
}

$MissionFile = "$MissionDir\NSM_DAILY_MISSION_SYSTEM_SCHEMA_V1.json"

$MissionSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_083"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    DailyMissions = @()

}

$MissionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MissionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_083 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_083_BUILD_DAILY_MISSION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Daily Mission System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\DailyMissions\NSM_DAILY_MISSION_SYSTEM_SCHEMA_V1.json"

$MissionSystem=Get-Content $MissionFile -Raw | ConvertFrom-Json

$MissionSystem.DailyMissions=@(

    [PSCustomObject]@{

        Id="daily_001"

        Name="Train Troops"

        Category="Military"

        Target=100

        Reset="Daily"

        Reward=@{

            Gold=500

            Gems=5

            XP=100

        }

        Active=$true

    },

    [PSCustomObject]@{

        Id="daily_002"

        Name="Collect Resources"

        Category="Economy"

        Target=5000

        Reset="Daily"

        Reward=@{

            Gold=1000

            Gems=10

            XP=150

        }

        Active=$true

    },

    [PSCustomObject]@{

        Id="daily_003"

        Name="Win Battles"

        Category="Battle"

        Target=5

        Reset="Daily"

        Reward=@{

            Gold=1500

            Gems=15

            XP=250

        }

        Active=$true

    }

)

$MissionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MissionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_083 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_083_BUILD_DAILY_MISSION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\DailyMissions\NSM_DAILY_MISSION_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_DAILY_MISSION_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_DAILY_MISSION_VALIDATION_V1.json"

$Mission=Get-Content $MissionFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_083"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    MissionCount=@($Mission.DailyMissions).Count

    File=$MissionFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_083"

    Status="SUCCESS"

    SchemaExists=(Test-Path $MissionFile)

    MetadataExists=(Test-Path $MetadataFile)

    MissionCount=@($Mission.DailyMissions).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_083 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_083_BUILD_DAILY_MISSION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\DailyMissions\NSM_DAILY_MISSION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_DAILY_MISSION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $MissionFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_083"

    Module="DAILY_MISSION_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$MissionFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_083_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_083_BUILD_DAILY_MISSION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MissionFile="$Root\Data\Systems\DailyMissions\NSM_DAILY_MISSION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_083_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_083_HISTORY_","")

$BackupFile="$BackupDir\NSM_DAILY_MISSION_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $MissionFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_083
MODULE  : DAILY MISSION SYSTEM
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
Set-Content "$ReportDir\CMD_083_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_083 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

