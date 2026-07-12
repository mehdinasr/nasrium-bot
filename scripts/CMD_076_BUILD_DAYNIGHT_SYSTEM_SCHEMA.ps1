# ================================================================================
# NASRIUM PROJECT
# CMD_076_BUILD_DAYNIGHT_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Day/Night System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$DayNightDir = "$Root\Data\Systems\DayNight"

if (!(Test-Path $DayNightDir)) {
    New-Item -ItemType Directory -Path $DayNightDir -Force | Out-Null
}

$DayNightFile = "$DayNightDir\NSM_DAYNIGHT_SYSTEM_SCHEMA_V1.json"

$DayNightSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_076"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    TimeCycles = @()

}

$DayNightSystem |
ConvertTo-Json -Depth 20 |
Set-Content $DayNightFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_076 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_076_BUILD_DAYNIGHT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Day/Night Cycle Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DayNightFile = "$Root\Data\Systems\DayNight\NSM_DAYNIGHT_SYSTEM_SCHEMA_V1.json"

$DayNightSystem = Get-Content $DayNightFile -Raw | ConvertFrom-Json

$DayNightSystem.TimeCycles = @(

    [PSCustomObject]@{

        Id = "cycle_001"

        Name = "Dawn"

        StartHour = 5

        EndHour = 7

        AmbientLight = 0.45

        NPCActivity = "Wake"

        SpawnModifier = 1.00

        PvPAllowed = $true

    },

    [PSCustomObject]@{

        Id = "cycle_002"

        Name = "Day"

        StartHour = 7

        EndHour = 18

        AmbientLight = 1.00

        NPCActivity = "Normal"

        SpawnModifier = 1.00

        PvPAllowed = $true

    },

    [PSCustomObject]@{

        Id = "cycle_003"

        Name = "Dusk"

        StartHour = 18

        EndHour = 20

        AmbientLight = 0.55

        NPCActivity = "Return"

        SpawnModifier = 1.10

        PvPAllowed = $true

    },

    [PSCustomObject]@{

        Id = "cycle_004"

        Name = "Night"

        StartHour = 20

        EndHour = 5

        AmbientLight = 0.15

        NPCActivity = "Sleep"

        SpawnModifier = 1.35

        PvPAllowed = $true

    }

)

$DayNightSystem |
ConvertTo-Json -Depth 20 |
Set-Content $DayNightFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_076 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_076_BUILD_DAYNIGHT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DayNightFile = "$Root\Data\Systems\DayNight\NSM_DAYNIGHT_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_DAYNIGHT_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_DAYNIGHT_SYSTEM_VALIDATION_V1.json"

$DayNightSystem = Get-Content $DayNightFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $DayNightFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_076"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    TimeCycleCount = @($DayNightSystem.TimeCycles).Count

    File = $DayNightFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_076"

    Status = "SUCCESS"

    DayNightFile = (Test-Path $DayNightFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_076 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_076_BUILD_DAYNIGHT_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DayNightFile = "$Root\Data\Systems\DayNight\NSM_DAYNIGHT_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_DAYNIGHT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $DayNightFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $DayNightFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_076"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $DayNightFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_076_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_076
STATUS  : SUCCESS

FILE
----
$DayNightFile

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
Set-Content "$ReportDir\CMD_076_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_076 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

