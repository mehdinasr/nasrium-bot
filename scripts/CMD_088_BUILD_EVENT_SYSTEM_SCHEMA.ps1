# ================================================================================
# NASRIUM PROJECT
# CMD_088_BUILD_EVENT_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Event System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$EventDir = "$Root\Data\Systems\Events"

if (!(Test-Path $EventDir)) {
    New-Item -ItemType Directory -Path $EventDir -Force | Out-Null
}

$EventFile = "$EventDir\NSM_EVENT_SYSTEM_SCHEMA_V1.json"

$EventSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_088"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Events = @()

}

$EventSystem |
ConvertTo-Json -Depth 20 |
Set-Content $EventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_088 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_088_BUILD_EVENT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Event System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SYSTEM_SCHEMA_V1.json"

$EventSystem=Get-Content $EventFile -Raw | ConvertFrom-Json

$EventSystem.Events=@(

    [PSCustomObject]@{

        Id="event_001"

        Name="Kingdom Growth"

        Category="Progression"

        DurationDays=7

        Repeatable=$true

        Rewards=[ordered]@{

            Gold=10000

            Gems=100

            XP=1000

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="event_002"

        Name="War of Kingdoms"

        Category="Battle"

        DurationDays=14

        Repeatable=$true

        Rewards=[ordered]@{

            Gold=25000

            Gems=250

            XP=2500

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="event_003"

        Name="Resource Festival"

        Category="Economy"

        DurationDays=5

        Repeatable=$true

        Rewards=[ordered]@{

            Gold=15000

            Gems=150

            XP=1500

        }

        Active=$false

    },

    [PSCustomObject]@{

        Id="event_004"

        Name="Alliance Challenge"

        Category="Alliance"

        DurationDays=10

        Repeatable=$true

        Rewards=[ordered]@{

            Gold=30000

            Gems=300

            XP=3000

        }

        Active=$false

    }

)

$EventSystem |
ConvertTo-Json -Depth 20 |
Set-Content $EventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_088 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_088_BUILD_EVENT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_EVENT_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_EVENT_VALIDATION_V1.json"

$Event=Get-Content $EventFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $EventFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_088"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    EventCount=@($Event.Events).Count

    File=$EventFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_088"

    Status="SUCCESS"

    SchemaExists=(Test-Path $EventFile)

    MetadataExists=(Test-Path $MetadataFile)

    EventCount=@($Event.Events).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_088 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_088_BUILD_EVENT_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_EVENT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $EventFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_088"

    Module="EVENT_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$EventFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $EventFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_088_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_088_BUILD_EVENT_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_088_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_088_HISTORY_","")

$BackupFile="$BackupDir\NSM_EVENT_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $EventFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_088
MODULE  : EVENT SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$EventFile

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
Set-Content "$ReportDir\CMD_088_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_088 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

