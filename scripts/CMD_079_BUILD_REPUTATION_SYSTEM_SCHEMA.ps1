# ================================================================================
# NASRIUM PROJECT
# CMD_079_BUILD_REPUTATION_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Reputation System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$ReputationDir = "$Root\Data\Systems\Reputation"

if (!(Test-Path $ReputationDir)) {
    New-Item -ItemType Directory -Path $ReputationDir -Force | Out-Null
}

$ReputationFile = "$Root\Data\Systems\Reputation\NSM_REPUTATION_SYSTEM_SCHEMA_V1.json"

$ReputationSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_079"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    ReputationLevels = @()

}

$ReputationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ReputationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_079 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_079_BUILD_REPUTATION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Reputation Level Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ReputationFile = "$Root\Data\Systems\Reputation\NSM_REPUTATION_SYSTEM_SCHEMA_V1.json"

$ReputationSystem = Get-Content $ReputationFile -Raw | ConvertFrom-Json

$ReputationSystem.ReputationLevels = @(

    [PSCustomObject]@{

        Id = "rep_001"

        Name = "Hated"

        MinimumPoints = -10000

        MaximumPoints = -5001

        TradeAllowed = $false

        QuestAccess = $false

    },

    [PSCustomObject]@{

        Id = "rep_002"

        Name = "Neutral"

        MinimumPoints = -5000

        MaximumPoints = 4999

        TradeAllowed = $true

        QuestAccess = $true

    },

    [PSCustomObject]@{

        Id = "rep_003"

        Name = "Friendly"

        MinimumPoints = 5000

        MaximumPoints = 8999

        TradeAllowed = $true

        QuestAccess = $true

    },

    [PSCustomObject]@{

        Id = "rep_004"

        Name = "Exalted"

        MinimumPoints = 9000

        MaximumPoints = 10000

        TradeAllowed = $true

        QuestAccess = $true

    }

)

$ReputationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ReputationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_079 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_079_BUILD_REPUTATION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ReputationFile = "$Root\Data\Systems\Reputation\NSM_REPUTATION_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_REPUTATION_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_REPUTATION_SYSTEM_VALIDATION_V1.json"

$ReputationSystem = Get-Content $ReputationFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $ReputationFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_079"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    ReputationLevelCount = @($ReputationSystem.ReputationLevels).Count

    File = $ReputationFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_079"

    Status = "SUCCESS"

    ReputationFile = (Test-Path $ReputationFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_079 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_079_BUILD_REPUTATION_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ReputationFile = "$Root\Data\Systems\Reputation\NSM_REPUTATION_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_REPUTATION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $ReputationFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $ReputationFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_079"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $ReputationFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_079_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_079
STATUS  : SUCCESS

FILE
----
$ReputationFile

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
Set-Content "$ReportDir\CMD_079_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_079 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

