# ================================================================================
# NASRIUM PROJECT
# CMD_058_BUILD_CRAFTING_SCHEMA
# STEP 001
# ================================================================================
#
# Create Crafting Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$CraftingDir = "$Root\Data\Systems\Crafting"

if (!(Test-Path $CraftingDir)) {
    New-Item -ItemType Directory -Path $CraftingDir -Force | Out-Null
}

$CraftingFile = "$CraftingDir\NSM_CRAFTING_SCHEMA_V1.json"

$Crafting = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_058"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Recipes = @()

}

$Crafting |
ConvertTo-Json -Depth 20 |
Set-Content $CraftingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_058 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_058_BUILD_CRAFTING_SCHEMA
# STEP 002
# ================================================================================
#
# Crafting Recipe Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CraftingFile = "$Root\Data\Systems\Crafting\NSM_CRAFTING_SCHEMA_V1.json"

$Crafting = Get-Content $CraftingFile -Raw | ConvertFrom-Json

$Crafting.Recipes = @(

    [PSCustomObject]@{

        Id = "recipe_001"

        Name = "Health Potion"

        ResultItemId = "health_potion"

        ResultQuantity = 1

        CraftTimeSeconds = 5

        RequiredLevel = 1

        Materials = @(
            [PSCustomObject]@{
                ItemId = "red_herb"
                Quantity = 3
            },
            [PSCustomObject]@{
                ItemId = "clear_water"
                Quantity = 1
            }
        )

    },

    [PSCustomObject]@{

        Id = "recipe_002"

        Name = "Iron Sword"

        ResultItemId = "iron_sword"

        ResultQuantity = 1

        CraftTimeSeconds = 30

        RequiredLevel = 10

        Materials = @(
            [PSCustomObject]@{
                ItemId = "iron_ingot"
                Quantity = 10
            },
            [PSCustomObject]@{
                ItemId = "wood_handle"
                Quantity = 1
            }
        )

    },

    [PSCustomObject]@{

        Id = "recipe_003"

        Name = "Epic Armor"

        ResultItemId = "epic_armor"

        ResultQuantity = 1

        CraftTimeSeconds = 120

        RequiredLevel = 40

        Materials = @(
            [PSCustomObject]@{
                ItemId = "epic_material"
                Quantity = 25
            },
            [PSCustomObject]@{
                ItemId = "boss_token"
                Quantity = 10
            }
        )

    }

)

$Crafting |
ConvertTo-Json -Depth 20 |
Set-Content $CraftingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_058 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_058_BUILD_CRAFTING_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CraftingFile = "$Root\Data\Systems\Crafting\NSM_CRAFTING_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_CRAFTING_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_CRAFTING_VALIDATION_V1.json"

$Crafting = Get-Content $CraftingFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $CraftingFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_058"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    RecipeCount = @($Crafting.Recipes).Count

    File = $CraftingFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_058"

    Status = "SUCCESS"

    CraftingFile = (Test-Path $CraftingFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_058 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_058_BUILD_CRAFTING_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CraftingFile = "$Root\Data\Systems\Crafting\NSM_CRAFTING_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_CRAFTING_SCHEMA_$Time.json"

Copy-Item $CraftingFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $CraftingFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_058"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $CraftingFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_058_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_058
STATUS  : SUCCESS

FILE
----
$CraftingFile

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
Set-Content "$ReportDir\CMD_058_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_058 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

