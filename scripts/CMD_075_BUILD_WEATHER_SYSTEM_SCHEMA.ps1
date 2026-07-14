# ================================================================================
# NASRIUM PROJECT
# CMD_075_BUILD_WEATHER_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Weather System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$WeatherDir = "$Root\Data\Systems\Weather"

if (!(Test-Path $WeatherDir)) {
    New-Item -ItemType Directory -Path $WeatherDir -Force | Out-Null
}

$WeatherFile = "$WeatherDir\NSM_WEATHER_SYSTEM_SCHEMA_V1.json"

$WeatherSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_075"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    WeatherProfiles = @()

}

$WeatherSystem |
ConvertTo-Json -Depth 20 |
Set-Content $WeatherFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_075 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_075_BUILD_WEATHER_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Weather Profile Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WeatherFile = "$Root\Data\Systems\Weather\NSM_WEATHER_SYSTEM_SCHEMA_V1.json"

$WeatherSystem = Get-Content $WeatherFile -Raw | ConvertFrom-Json

$WeatherSystem.WeatherProfiles = @(

    [PSCustomObject]@{

        Id = "weather_001"

        Name = "Clear"

        Category = "Normal"

        Probability = 40

        DurationMinutes = 120

        VisibilityPercent = 100

        MovementModifier = 1.00

        CombatModifier = 1.00

    },

    [PSCustomObject]@{

        Id = "weather_002"

        Name = "Rain"

        Category = "Wet"

        Probability = 30

        DurationMinutes = 90

        VisibilityPercent = 85

        MovementModifier = 0.98

        CombatModifier = 0.97

    },

    [PSCustomObject]@{

        Id = "weather_003"

        Name = "Snow"

        Category = "Cold"

        Probability = 15

        DurationMinutes = 150

        VisibilityPercent = 75

        MovementModifier = 0.92

        CombatModifier = 0.95

    },

    [PSCustomObject]@{

        Id = "weather_004"

        Name = "Storm"

        Category = "Extreme"

        Probability = 15

        DurationMinutes = 45

        VisibilityPercent = 50

        MovementModifier = 0.85

        CombatModifier = 0.90

    }

)

$WeatherSystem |
ConvertTo-Json -Depth 20 |
Set-Content $WeatherFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_075 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_075_BUILD_WEATHER_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WeatherFile = "$Root\Data\Systems\Weather\NSM_WEATHER_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_WEATHER_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_WEATHER_SYSTEM_VALIDATION_V1.json"

$WeatherSystem = Get-Content $WeatherFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $WeatherFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_075"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    WeatherProfileCount = @($WeatherSystem.WeatherProfiles).Count

    File = $WeatherFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_075"

    Status = "SUCCESS"

    WeatherFile = (Test-Path $WeatherFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_075 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_075_BUILD_WEATHER_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$WeatherFile = "$Root\Data\Systems\Weather\NSM_WEATHER_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_WEATHER_SYSTEM_SCHEMA_$Time.json"

Copy-Item $WeatherFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $WeatherFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_075"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $WeatherFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_075_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_075
STATUS  : SUCCESS

FILE
----
$WeatherFile

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
Set-Content "$ReportDir\CMD_075_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_075 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

