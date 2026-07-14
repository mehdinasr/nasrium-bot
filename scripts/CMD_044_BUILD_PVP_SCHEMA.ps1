# ================================================================================
# NASRIUM PROJECT
# CMD_044_BUILD_PVP_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$PvPDir="$Root\Data\Balance\PvP"

if(!(Test-Path $PvPDir)){
    New-Item -ItemType Directory -Path $PvPDir -Force | Out-Null
}

$PvPFile="$PvPDir\NSM_PVP_SCHEMA_V1.json"

$PvP=[ordered]@{

Metadata=[ordered]@{

Module="CMD_044"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

PvP=@()

}

$PvP |
ConvertTo-Json -Depth 20 |
Set-Content $PvPFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_044 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_044_BUILD_PVP_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$PvPFile="$Root\Data\Balance\PvP\NSM_PVP_SCHEMA_V1.json"

$PvP=Get-Content $PvPFile -Raw | ConvertFrom-Json

$PvP.PvP=@(

    [PSCustomObject]@{

        Id="pvp_001"

        League="Bronze"

        MinRating=0

        MaxRating=999

        DailyEntries=5

        SeasonReward=[PSCustomObject]@{

            Gold=500

            Gems=10

            ArenaToken=50

        }

    },

    [PSCustomObject]@{

        Id="pvp_002"

        League="Silver"

        MinRating=1000

        MaxRating=1999

        DailyEntries=5

        SeasonReward=[PSCustomObject]@{

            Gold=2000

            Gems=30

            ArenaToken=150

        }

    },

    [PSCustomObject]@{

        Id="pvp_003"

        League="Gold"

        MinRating=2000

        MaxRating=2999

        DailyEntries=5

        SeasonReward=[PSCustomObject]@{

            Gold=5000

            Gems=75

            ArenaToken=300

        }

    },

    [PSCustomObject]@{

        Id="pvp_004"

        League="Legend"

        MinRating=3000

        MaxRating=999999

        DailyEntries=5

        SeasonReward=[PSCustomObject]@{

            Gold=20000

            Gems=250

            ArenaToken=1000

        }

    }

)

$PvP |
ConvertTo-Json -Depth 20 |
Set-Content $PvPFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_044 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_044_BUILD_PVP_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$PvPFile="$Root\Data\Balance\PvP\NSM_PVP_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_PVP_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_PVP_VALIDATION_V1.json"

$PvP=Get-Content $PvPFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $PvPFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_044"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

LeagueCount=@($PvP.PvP).Count

File=$PvPFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_044"

Status="SUCCESS"

PvPFile=(Test-Path $PvPFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_044 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_044_BUILD_PVP_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$PvPFile="$Root\Data\Balance\PvP\NSM_PVP_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_PVP_SCHEMA_$Time.json"

Copy-Item $PvPFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_044"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$PvPFile

Backup=$BackupFile

SHA256=(Get-FileHash $PvPFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_044_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_044
STATUS  : SUCCESS

FILE
----
$PvPFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $PvPFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_044_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_044 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

