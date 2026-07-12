# ================================================================================
# NASRIUM PROJECT
# CMD_056_BUILD_LOOT_TABLE_SCHEMA
# STEP 001
# ================================================================================
#
# Create Loot Table Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$LootDir = "$Root\Data\Balance\LootTables"

if (!(Test-Path $LootDir)) {
    New-Item -ItemType Directory -Path $LootDir -Force | Out-Null
}

$LootFile = "$LootDir\NSM_LOOT_TABLE_SCHEMA_V1.json"

$Loot = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_056"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    LootTables = @()

}

$Loot |
ConvertTo-Json -Depth 20 |
Set-Content $LootFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_056 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_056_BUILD_LOOT_TABLE_SCHEMA
# STEP 002
# ================================================================================
#
# Loot Table Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$LootFile = "$Root\Data\Balance\LootTables\NSM_LOOT_TABLE_SCHEMA_V1.json"

$Loot = Get-Content $LootFile -Raw | ConvertFrom-Json

$Loot.LootTables = @(

    [PSCustomObject]@{

        Id = "loot_001"

        Name = "Common Monster"

        Drops = @(
            [PSCustomObject]@{
                ItemId = "gold_coin"
                Chance = 75.0
                MinQuantity = 10
                MaxQuantity = 50
            },
            [PSCustomObject]@{
                ItemId = "health_potion"
                Chance = 15.0
                MinQuantity = 1
                MaxQuantity = 2
            }
        )

    },

    [PSCustomObject]@{

        Id = "loot_002"

        Name = "Elite Monster"

        Drops = @(
            [PSCustomObject]@{
                ItemId = "gold_coin"
                Chance = 100.0
                MinQuantity = 100
                MaxQuantity = 250
            },
            [PSCustomObject]@{
                ItemId = "rare_equipment"
                Chance = 12.5
                MinQuantity = 1
                MaxQuantity = 1
            },
            [PSCustomObject]@{
                ItemId = "epic_material"
                Chance = 5.0
                MinQuantity = 1
                MaxQuantity = 3
            }
        )

    },

    [PSCustomObject]@{

        Id = "loot_003"

        Name = "World Boss"

        Drops = @(
            [PSCustomObject]@{
                ItemId = "legendary_weapon"
                Chance = 2.0
                MinQuantity = 1
                MaxQuantity = 1
            },
            [PSCustomObject]@{
                ItemId = "boss_token"
                Chance = 100.0
                MinQuantity = 10
                MaxQuantity = 20
            },
            [PSCustomObject]@{
                ItemId = "gold_coin"
                Chance = 100.0
                MinQuantity = 5000
                MaxQuantity = 10000
            }
        )

    }

)

$Loot |
ConvertTo-Json -Depth 20 |
Set-Content $LootFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_056 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_056_BUILD_LOOT_TABLE_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$LootFile = "$Root\Data\Balance\LootTables\NSM_LOOT_TABLE_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_LOOT_TABLE_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_LOOT_TABLE_VALIDATION_V1.json"

$Loot = Get-Content $LootFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $LootFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_056"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    LootTableCount = @($Loot.LootTables).Count

    File = $LootFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_056"

    Status = "SUCCESS"

    LootFile = (Test-Path $LootFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_056 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_056_BUILD_LOOT_TABLE_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$LootFile = "$Root\Data\Balance\LootTables\NSM_LOOT_TABLE_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir, $HistoryDir, $ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_LOOT_TABLE_SCHEMA_$Time.json"

Copy-Item $LootFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $LootFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_056"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $LootFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_056_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_056
STATUS  : SUCCESS

FILE
----
$LootFile

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
Set-Content "$ReportDir\CMD_056_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_056 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

