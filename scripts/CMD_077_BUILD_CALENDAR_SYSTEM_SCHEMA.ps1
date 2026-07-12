# ================================================================================
# NASRIUM PROJECT
# CMD_077_BUILD_CALENDAR_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Calendar System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$CalendarDir = "$Root\Data\Systems\Calendar"

if (!(Test-Path $CalendarDir)) {
    New-Item -ItemType Directory -Path $CalendarDir -Force | Out-Null
}

$CalendarFile = "$CalendarDir\NSM_CALENDAR_SYSTEM_SCHEMA_V1.json"

$CalendarSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_077"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    CalendarConfig = [ordered]@{

        DaysPerWeek   = 7

        MonthsPerYear = 12

        HoursPerDay   = 24

        MinutesPerHour = 60

        SecondsPerMinute = 60

        EpochYear = 1

    }

    Months = @()

    WeekDays = @()

    Holidays = @()

}

$CalendarSystem |
ConvertTo-Json -Depth 20 |
Set-Content $CalendarFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_077 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_077_BUILD_CALENDAR_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Calendar Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CalendarFile = "$Root\Data\Systems\Calendar\NSM_CALENDAR_SYSTEM_SCHEMA_V1.json"

$CalendarSystem = Get-Content $CalendarFile -Raw | ConvertFrom-Json

$CalendarSystem.Months = @(

    [PSCustomObject]@{ Id="month_01"; Name="January";   Days=31 },
    [PSCustomObject]@{ Id="month_02"; Name="February";  Days=28 },
    [PSCustomObject]@{ Id="month_03"; Name="March";     Days=31 },
    [PSCustomObject]@{ Id="month_04"; Name="April";     Days=30 },
    [PSCustomObject]@{ Id="month_05"; Name="May";       Days=31 },
    [PSCustomObject]@{ Id="month_06"; Name="June";      Days=30 },
    [PSCustomObject]@{ Id="month_07"; Name="July";      Days=31 },
    [PSCustomObject]@{ Id="month_08"; Name="August";    Days=31 },
    [PSCustomObject]@{ Id="month_09"; Name="September"; Days=30 },
    [PSCustomObject]@{ Id="month_10"; Name="October";   Days=31 },
    [PSCustomObject]@{ Id="month_11"; Name="November";  Days=30 },
    [PSCustomObject]@{ Id="month_12"; Name="December";  Days=31 }

)

$CalendarSystem.WeekDays = @(

    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"

)

$CalendarSystem.Holidays = @(

    [PSCustomObject]@{

        Id = "holiday_001"

        Name = "Founders Day"

        Month = 1

        Day = 1

        GlobalEvent = $true

    },

    [PSCustomObject]@{

        Id = "holiday_002"

        Name = "Harvest Festival"

        Month = 9

        Day = 21

        GlobalEvent = $true

    }

)

$CalendarSystem |
ConvertTo-Json -Depth 20 |
Set-Content $CalendarFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_077 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_077_BUILD_CALENDAR_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CalendarFile = "$Root\Data\Systems\Calendar\NSM_CALENDAR_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_CALENDAR_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_CALENDAR_SYSTEM_VALIDATION_V1.json"

$CalendarSystem = Get-Content $CalendarFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $CalendarFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_077"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    MonthCount = @($CalendarSystem.Months).Count

    WeekDayCount = @($CalendarSystem.WeekDays).Count

    HolidayCount = @($CalendarSystem.Holidays).Count

    File = $CalendarFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_077"

    Status = "SUCCESS"

    CalendarFile = (Test-Path $CalendarFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_077 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_077_BUILD_CALENDAR_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CalendarFile = "$Root\Data\Systems\Calendar\NSM_CALENDAR_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_CALENDAR_SYSTEM_SCHEMA_$Time.json"

Copy-Item $CalendarFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $CalendarFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_077"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $CalendarFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_077_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_077
STATUS  : SUCCESS

FILE
----
$CalendarFile

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
Set-Content "$ReportDir\CMD_077_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_077 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

