# ================================================================================
# NASRIUM PROJECT
# CMD_070_BUILD_QUEST_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Quest System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$QuestDir = "$Root\Data\Systems\Quests"

if (!(Test-Path $QuestDir)) {
    New-Item -ItemType Directory -Path $QuestDir -Force | Out-Null
}

$QuestFile = "$QuestDir\NSM_QUEST_SYSTEM_SCHEMA_V1.json"

$QuestSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_070"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Quests = @()

}

$QuestSystem |
ConvertTo-Json -Depth 20 |
Set-Content $QuestFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_070 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_070_BUILD_QUEST_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Quest Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$QuestFile = "$Root\Data\Systems\Quests\NSM_QUEST_SYSTEM_SCHEMA_V1.json"

$QuestSystem = Get-Content $QuestFile -Raw | ConvertFrom-Json

$QuestSystem.Quests = @(

    [PSCustomObject]@{

        Id = "quest_001"

        Name = "First Steps"

        Category = "Tutorial"

        Description = "Complete the beginner tutorial."

        RequiredLevel = 1

        Repeatable = $false

        RewardXP = 100

        RewardGold = 50

    },

    [PSCustomObject]@{

        Id = "quest_002"

        Name = "Goblin Hunt"

        Category = "Combat"

        Description = "Defeat 20 Goblins."

        RequiredLevel = 5

        Repeatable = $true

        RewardXP = 500

        RewardGold = 250

    },

    [PSCustomObject]@{

        Id = "quest_003"

        Name = "Gathering Supplies"

        Category = "Collection"

        Description = "Collect 30 Herbs."

        RequiredLevel = 3

        Repeatable = $true

        RewardXP = 300

        RewardGold = 150

    },

    [PSCustomObject]@{

        Id = "quest_004"

        Name = "Dragon Slayer"

        Category = "Epic"

        Description = "Defeat the Ancient Dragon."

        RequiredLevel = 50

        Repeatable = $false

        RewardXP = 50000

        RewardGold = 10000

    }

)

$QuestSystem |
ConvertTo-Json -Depth 20 |
Set-Content $QuestFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_070 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_070_BUILD_QUEST_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$QuestFile = "$Root\Data\Systems\Quests\NSM_QUEST_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_QUEST_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_QUEST_SYSTEM_VALIDATION_V1.json"

$QuestSystem = Get-Content $QuestFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $QuestFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_070"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    QuestCount = @($QuestSystem.Quests).Count

    File = $QuestFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_070"

    Status = "SUCCESS"

    QuestFile = (Test-Path $QuestFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_070 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_070_BUILD_QUEST_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$QuestFile = "$Root\Data\Systems\Quests\NSM_QUEST_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_QUEST_SYSTEM_SCHEMA_$Time.json"

Copy-Item $QuestFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $QuestFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_070"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $QuestFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_070_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_070
STATUS  : SUCCESS

FILE
----
$QuestFile

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
Set-Content "$ReportDir\CMD_070_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_070 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

