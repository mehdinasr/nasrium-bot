# ================================================================================
# NASRIUM PROJECT
# CMD_074_BUILD_WORLD_EVENT_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create World Event System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$WorldEventDir = "$Root\Data\Systems\WorldEvents"

if (!(Test-Path $WorldEventDir)) {
    New-Item -ItemType Directory -Path $WorldEventDir -Force | Out-Null
}

$WorldEventFile = "$WorldEventDir\NSM_WORLD_EVENT_SYSTEM_SCHEMA_V1.json"

$WorldEventSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_074"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    WorldEvents = @()

}

$WorldEventSystem |
ConvertTo-Json -Depth 20 |
Set-Content $WorldEventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_074 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_074_BUILD_WORLD_EVENT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# World Event Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WorldEventFile = "$Root\Data\Systems\WorldEvents\NSM_WORLD_EVENT_SYSTEM_SCHEMA_V1.json"

$WorldEventSystem = Get-Content $WorldEventFile -Raw | ConvertFrom-Json

$WorldEventSystem.WorldEvents = @(

    [PSCustomObject]@{

        Id = "world_event_001"

        Name = "Goblin Invasion"

        Category = "Combat"

        TriggerType = "Scheduled"

        DurationMinutes = 30

        RepeatIntervalHours = 6

        GlobalAnnouncement = $true

        Enabled = $true

    },

    [PSCustomObject]@{

        Id = "world_event_002"

        Name = "Double Experience"

        Category = "Bonus"

        TriggerType = "Scheduled"

        DurationMinutes = 1440

        RepeatIntervalHours = 168

        GlobalAnnouncement = $true

        Enabled = $true

    },

    [PSCustomObject]@{

        Id = "world_event_003"

        Name = "Treasure Hunt"

        Category = "Exploration"

        TriggerType = "Random"

        DurationMinutes = 60

        RepeatIntervalHours = 24

        GlobalAnnouncement = $true

        Enabled = $true

    },

    [PSCustomObject]@{

        Id = "world_event_004"

        Name = "World Boss"

        Category = "Raid"

        TriggerType = "Scheduled"

        DurationMinutes = 90

        RepeatIntervalHours = 12

        GlobalAnnouncement = $true

        Enabled = $true

    }

)

$WorldEventSystem |
ConvertTo-Json -Depth 20 |
Set-Content $WorldEventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_074 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_074_BUILD_WORLD_EVENT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WorldEventFile = "$Root\Data\Systems\WorldEvents\NSM_WORLD_EVENT_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_WORLD_EVENT_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_WORLD_EVENT_SYSTEM_VALIDATION_V1.json"

$WorldEventSystem = Get-Content $WorldEventFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $WorldEventFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_074"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    WorldEventCount = @($WorldEventSystem.WorldEvents).Count

    File = $WorldEventFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_074"

    Status = "SUCCESS"

    WorldEventFile = (Test-Path $WorldEventFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_074 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_074_BUILD_WORLD_EVENT_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WorldEventFile = "$Root\Data\Systems\WorldEvents\NSM_WORLD_EVENT_SYSTEM_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir, $HistoryDir, $ReportDir)) {
    if (!(Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_WORLD_EVENT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $WorldEventFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $WorldEventFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_074"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $WorldEventFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_074_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_074
STATUS  : SUCCESS

FILE
----
$WorldEventFile

BACKUP
------
$BackupFile

SHA256
------
$SHA256

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_074_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_074 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

