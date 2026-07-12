# ================================================================================
# NASRIUM PROJECT
# CMD_085_BUILD_SEASON_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Season System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$SeasonDir = "$Root\Data\Systems\Seasons"

if (!(Test-Path $SeasonDir)) {
    New-Item -ItemType Directory -Path $SeasonDir -Force | Out-Null
}

$SeasonFile = "$SeasonDir\NSM_SEASON_SYSTEM_SCHEMA_V1.json"

$SeasonSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_085"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Seasons = @()

}

$SeasonSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SeasonFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_085 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_085_BUILD_SEASON_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Season System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$SeasonFile="$Root\Data\Systems\Seasons\NSM_SEASON_SYSTEM_SCHEMA_V1.json"

$SeasonSystem=Get-Content $SeasonFile -Raw | ConvertFrom-Json

$SeasonSystem.Seasons=@(

    [PSCustomObject]@{

        Id="season_001"

        Name="Spring"

        Order=1

        DurationDays=90

        Theme="Growth"

        Rewards=[ordered]@{

            Gold=50000

            Gems=500

            XP=5000

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="season_002"

        Name="Summer"

        Order=2

        DurationDays=90

        Theme="War"

        Rewards=[ordered]@{

            Gold=75000

            Gems=750

            XP=7500

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="season_003"

        Name="Autumn"

        Order=3

        DurationDays=90

        Theme="Harvest"

        Rewards=[ordered]@{

            Gold=100000

            Gems=1000

            XP=10000

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="season_004"

        Name="Winter"

        Order=4

        DurationDays=90

        Theme="Survival"

        Rewards=[ordered]@{

            Gold=125000

            Gems=1250

            XP=12500

        }

        Active=$false

    }

)

$SeasonSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SeasonFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_085 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_085_BUILD_SEASON_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$SeasonFile="$Root\Data\Systems\Seasons\NSM_SEASON_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_SEASON_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_SEASON_VALIDATION_V1.json"

$Season=Get-Content $SeasonFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $SeasonFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_085"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    SeasonCount=@($Season.Seasons).Count

    File=$SeasonFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_085"

    Status="SUCCESS"

    SchemaExists=(Test-Path $SeasonFile)

    MetadataExists=(Test-Path $MetadataFile)

    SeasonCount=@($Season.Seasons).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_085 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_085_BUILD_SEASON_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$SeasonFile="$Root\Data\Systems\Seasons\NSM_SEASON_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_SEASON_SYSTEM_SCHEMA_$Time.json"

Copy-Item $SeasonFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_085"

    Module="SEASON_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$SeasonFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $SeasonFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_085_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_085_BUILD_SEASON_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$SeasonFile="$Root\Data\Systems\Seasons\NSM_SEASON_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_085_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_085_HISTORY_","")

$BackupFile="$BackupDir\NSM_SEASON_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $SeasonFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_085
MODULE  : SEASON SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$SeasonFile

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
Set-Content "$ReportDir\CMD_085_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_085 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

