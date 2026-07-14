# ================================================================================
# NASRIUM PROJECT
# CMD_047_BUILD_RANKING_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$RankingDir="$Root\Data\Systems\Ranking"

if(!(Test-Path $RankingDir)){
    New-Item -ItemType Directory -Path $RankingDir -Force | Out-Null
}

$RankingFile="$RankingDir\NSM_RANKING_SCHEMA_V1.json"

$Ranking=[ordered]@{

Metadata=[ordered]@{

Module="CMD_047"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Rankings=@()

}

$Ranking |
ConvertTo-Json -Depth 20 |
Set-Content $RankingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_047 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_047_BUILD_RANKING_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RankingFile="$Root\Data\Systems\Ranking\NSM_RANKING_SCHEMA_V1.json"

$Ranking=Get-Content $RankingFile -Raw | ConvertFrom-Json

$Ranking.Rankings=@(

    [PSCustomObject]@{

        Id="ranking_001"

        Name="Player Level"

        Category="Progress"

        SortOrder="Descending"

        ResetPeriod="Never"

        MaxEntries=100

        RewardEnabled=$false

    },

    [PSCustomObject]@{

        Id="ranking_002"

        Name="Arena"

        Category="PvP"

        SortOrder="Descending"

        ResetPeriod="Weekly"

        MaxEntries=100

        RewardEnabled=$true

    },

    [PSCustomObject]@{

        Id="ranking_003"

        Name="Guild"

        Category="Guild"

        SortOrder="Descending"

        ResetPeriod="Monthly"

        MaxEntries=100

        RewardEnabled=$true

    },

    [PSCustomObject]@{

        Id="ranking_004"

        Name="Tower"

        Category="PvE"

        SortOrder="Descending"

        ResetPeriod="Season"

        MaxEntries=100

        RewardEnabled=$true

    }

)

$Ranking |
ConvertTo-Json -Depth 20 |
Set-Content $RankingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_047 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_047_BUILD_RANKING_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RankingFile="$Root\Data\Systems\Ranking\NSM_RANKING_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_RANKING_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_RANKING_VALIDATION_V1.json"

$Ranking=Get-Content $RankingFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $RankingFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_047"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

RankingCount=@($Ranking.Rankings).Count

File=$RankingFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_047"

Status="SUCCESS"

RankingFile=(Test-Path $RankingFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_047 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_047_BUILD_RANKING_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RankingFile="$Root\Data\Systems\Ranking\NSM_RANKING_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_RANKING_SCHEMA_$Time.json"

Copy-Item $RankingFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_047"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$RankingFile

Backup=$BackupFile

SHA256=(Get-FileHash $RankingFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_047_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_047
STATUS  : SUCCESS

FILE
----
$RankingFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $RankingFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_047_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_047 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

