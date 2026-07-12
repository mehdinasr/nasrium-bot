# ================================================================================
# NASRIUM PROJECT
# CMD_046_BUILD_EVENT_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EventDir="$Root\Data\Systems\Events"

if(!(Test-Path $EventDir)){
    New-Item -ItemType Directory -Path $EventDir -Force | Out-Null
}

$EventFile="$EventDir\NSM_EVENT_SCHEMA_V1.json"

$Event=[ordered]@{

Metadata=[ordered]@{

Module="CMD_046"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Events=@()

}

$Event |
ConvertTo-Json -Depth 20 |
Set-Content $EventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_046 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_046_BUILD_EVENT_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SCHEMA_V1.json"

$Event=Get-Content $EventFile -Raw | ConvertFrom-Json

$Event.Events=@(

    [PSCustomObject]@{

        Id="event_001"

        Name="Daily Login"

        Category="Daily"

        DurationHours=24

        Repeatable=$true

        Rewards=[PSCustomObject]@{

            Gold=500

            Gems=10

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="event_002"

        Name="Weekend Boost"

        Category="Weekend"

        DurationHours=48

        Repeatable=$true

        Rewards=[PSCustomObject]@{

            Gold=5000

            Gems=50

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="event_003"

        Name="World Boss"

        Category="Raid"

        DurationHours=12

        Repeatable=$true

        Rewards=[PSCustomObject]@{

            Gold=10000

            Gems=100

            Items=@(

                [PSCustomObject]@{

                    ItemId="item_005"

                    Quantity=1

                }

            )

        }

    },

    [PSCustomObject]@{

        Id="event_004"

        Name="Season Festival"

        Category="Seasonal"

        DurationHours=168

        Repeatable=$false

        Rewards=[PSCustomObject]@{

            Gold=25000

            Gems=300

            Items=@(

                [PSCustomObject]@{

                    ItemId="item_010"

                    Quantity=3

                }

            )

        }

    }

)

$Event |
ConvertTo-Json -Depth 20 |
Set-Content $EventFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_046 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_046_BUILD_EVENT_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_EVENT_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_EVENT_VALIDATION_V1.json"

$Event=Get-Content $EventFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $EventFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_046"

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

Module="CMD_046"

Status="SUCCESS"

EventFile=(Test-Path $EventFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_046 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_046_BUILD_EVENT_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EventFile="$Root\Data\Systems\Events\NSM_EVENT_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_EVENT_SCHEMA_$Time.json"

Copy-Item $EventFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_046"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$EventFile

Backup=$BackupFile

SHA256=(Get-FileHash $EventFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_046_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_046
STATUS  : SUCCESS

FILE
----
$EventFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $EventFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_046_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_046 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

