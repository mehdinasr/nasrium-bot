# ================================================================================
# NASRIUM PROJECT
# CMD_068_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Title System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$TitleDir = "$Root\Data\Systems\Titles"

if (!(Test-Path $TitleDir)) {
    New-Item -ItemType Directory -Path $TitleDir -Force | Out-Null
}

$TitleFile = "$TitleDir\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$TitleSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_068"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Titles = @()

}

$TitleSystem |
ConvertTo-Json -Depth 20 |
Set-Content $TitleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_068 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_068_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Title Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$TitleFile = "$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$TitleSystem = Get-Content $TitleFile -Raw | ConvertFrom-Json

$TitleSystem.Titles = @(

    [PSCustomObject]@{

        Id = "title_001"

        Name = "Novice"

        Category = "Progression"

        Description = "Awarded for beginning the adventure."

        UnlockRequirement = "Reach Level 1"

        AttributeBonus = "Health"

        BonusValue = 50

        Permanent = $true

    },

    [PSCustomObject]@{

        Id = "title_002"

        Name = "Monster Slayer"

        Category = "Combat"

        Description = "Awarded for defeating 1,000 monsters."

        UnlockRequirement = "Kill 1000 Monsters"

        AttributeBonus = "Attack"

        BonusValue = 10

        Permanent = $true

    },

    [PSCustomObject]@{

        Id = "title_003"

        Name = "Master Explorer"

        Category = "Exploration"

        Description = "Awarded for discovering every region."

        UnlockRequirement = "Explore All Regions"

        AttributeBonus = "MovementSpeed"

        BonusValue = 5

        Permanent = $true

    },

    [PSCustomObject]@{

        Id = "title_004"

        Name = "Champion"

        Category = "PvP"

        Description = "Awarded to seasonal arena champions."

        UnlockRequirement = "Rank #1 Arena Season"

        AttributeBonus = "CriticalChance"

        BonusValue = 3

        Permanent = $false

    }

)

$TitleSystem |
ConvertTo-Json -Depth 20 |
Set-Content $TitleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_068 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_068_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$TitleFile = "$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_TITLE_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_TITLE_SYSTEM_VALIDATION_V1.json"

$TitleSystem = Get-Content $TitleFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $TitleFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_068"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    TitleCount = @($TitleSystem.Titles).Count

    File = $TitleFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_068"

    Status = "SUCCESS"

    TitleFile = (Test-Path $TitleFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_068 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_068_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$TitleFile = "$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_TITLE_SYSTEM_SCHEMA_$Time.json"

Copy-Item $TitleFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $TitleFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_068"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $TitleFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_068_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_068
STATUS  : SUCCESS

FILE
----
$TitleFile

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
Set-Content "$ReportDir\CMD_068_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_068 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

