# ================================================================================
# NASRIUM PROJECT
# CMD_089_BUILD_LEADERBOARD_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Leaderboard System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$LeaderboardDir = "$Root\Data\Systems\Leaderboards"

if (!(Test-Path $LeaderboardDir)) {
    New-Item -ItemType Directory -Path $LeaderboardDir -Force | Out-Null
}

$LeaderboardFile = "$LeaderboardDir\NSM_LEADERBOARD_SYSTEM_SCHEMA_V1.json"

$LeaderboardSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_089"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Leaderboards = @()

}

$LeaderboardSystem |
ConvertTo-Json -Depth 20 |
Set-Content $LeaderboardFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_089 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_089_BUILD_LEADERBOARD_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Leaderboard System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$LeaderboardFile="$Root\Data\Systems\Leaderboards\NSM_LEADERBOARD_SYSTEM_SCHEMA_V1.json"

$LeaderboardSystem=Get-Content $LeaderboardFile -Raw | ConvertFrom-Json

$LeaderboardSystem.Leaderboards=@(

    [PSCustomObject]@{

        Id="leaderboard_001"

        Name="Player Power"

        Category="Player"

        Reset="Never"

        RewardEnabled=$false

        Active=$true

    },

    [PSCustomObject]@{

        Id="leaderboard_002"

        Name="Alliance Power"

        Category="Alliance"

        Reset="Weekly"

        RewardEnabled=$true

        Active=$true

    },

    [PSCustomObject]@{

        Id="leaderboard_003"

        Name="Battle Ranking"

        Category="Battle"

        Reset="Daily"

        RewardEnabled=$true

        Active=$true

    },

    [PSCustomObject]@{

        Id="leaderboard_004"

        Name="Resource Ranking"

        Category="Economy"

        Reset="Weekly"

        RewardEnabled=$true

        Active=$true

    },

    [PSCustomObject]@{

        Id="leaderboard_005"

        Name="Season Ranking"

        Category="Season"

        Reset="Season"

        RewardEnabled=$true

        Active=$true

    }

)

$LeaderboardSystem |
ConvertTo-Json -Depth 20 |
Set-Content $LeaderboardFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_089 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_089_BUILD_LEADERBOARD_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$LeaderboardFile="$Root\Data\Systems\Leaderboards\NSM_LEADERBOARD_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_LEADERBOARD_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_LEADERBOARD_VALIDATION_V1.json"

$Leaderboard=Get-Content $LeaderboardFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $LeaderboardFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_089"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    LeaderboardCount=@($Leaderboard.Leaderboards).Count

    File=$LeaderboardFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_089"

    Status="SUCCESS"

    SchemaExists=(Test-Path $LeaderboardFile)

    MetadataExists=(Test-Path $MetadataFile)

    LeaderboardCount=@($Leaderboard.Leaderboards).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_089 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_089_BUILD_LEADERBOARD_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$LeaderboardFile="$Root\Data\Systems\Leaderboards\NSM_LEADERBOARD_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_LEADERBOARD_SYSTEM_SCHEMA_$Time.json"

Copy-Item $LeaderboardFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_089"

    Module="LEADERBOARD_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$LeaderboardFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $LeaderboardFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_089_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_089_BUILD_LEADERBOARD_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$LeaderboardFile="$Root\Data\Systems\Leaderboards\NSM_LEADERBOARD_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_089_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_089_HISTORY_","")

$BackupFile="$BackupDir\NSM_LEADERBOARD_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $LeaderboardFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_089
MODULE  : LEADERBOARD SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$LeaderboardFile

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
Set-Content "$ReportDir\CMD_089_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_089 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

