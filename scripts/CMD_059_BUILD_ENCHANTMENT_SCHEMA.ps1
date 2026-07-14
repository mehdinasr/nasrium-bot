# ================================================================================
# NASRIUM PROJECT
# CMD_059_BUILD_ENCHANTMENT_SCHEMA
# STEP 001
# ================================================================================
#
# Create Enchantment Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$EnchantDir = "$Root\Data\Systems\Enchantments"

if (!(Test-Path $EnchantDir)) {
    New-Item -ItemType Directory -Path $EnchantDir -Force | Out-Null
}

$EnchantFile = "$EnchantDir\NSM_ENCHANTMENT_SCHEMA_V1.json"

$Enchant = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_059"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Enchantments = @()

}

$Enchant |
ConvertTo-Json -Depth 20 |
Set-Content $EnchantFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_059 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_059_BUILD_ENCHANTMENT_SCHEMA
# STEP 002
# ================================================================================
#
# Enchantment Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$EnchantFile = "$Root\Data\Systems\Enchantments\NSM_ENCHANTMENT_SCHEMA_V1.json"

$Enchant = Get-Content $EnchantFile -Raw | ConvertFrom-Json

$Enchant.Enchantments = @(

    [PSCustomObject]@{

        Id = "enchant_001"

        Name = "Flame Weapon"

        TargetType = "Weapon"

        Attribute = "FireDamage"

        BonusValue = 25

        BonusType = "Flat"

        MaxLevel = 10

        SuccessRate = 95

    },

    [PSCustomObject]@{

        Id = "enchant_002"

        Name = "Guardian Armor"

        TargetType = "Armor"

        Attribute = "Defense"

        BonusValue = 15

        BonusType = "Percent"

        MaxLevel = 10

        SuccessRate = 90

    },

    [PSCustomObject]@{

        Id = "enchant_003"

        Name = "Swift Boots"

        TargetType = "Boots"

        Attribute = "MoveSpeed"

        BonusValue = 8

        BonusType = "Percent"

        MaxLevel = 5

        SuccessRate = 92

    },

    [PSCustomObject]@{

        Id = "enchant_004"

        Name = "Mystic Ring"

        TargetType = "Accessory"

        Attribute = "Mana"

        BonusValue = 120

        BonusType = "Flat"

        MaxLevel = 7

        SuccessRate = 88

    }

)

$Enchant |
ConvertTo-Json -Depth 20 |
Set-Content $EnchantFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_059 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_059_BUILD_ENCHANTMENT_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$EnchantFile = "$Root\Data\Systems\Enchantments\NSM_ENCHANTMENT_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_ENCHANTMENT_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_ENCHANTMENT_VALIDATION_V1.json"

$Enchant = Get-Content $EnchantFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $EnchantFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_059"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    EnchantmentCount = @($Enchant.Enchantments).Count

    File = $EnchantFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_059"

    Status = "SUCCESS"

    EnchantmentFile = (Test-Path $EnchantFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_059 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_059_BUILD_ENCHANTMENT_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$EnchantFile = "$Root\Data\Systems\Enchantments\NSM_ENCHANTMENT_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_ENCHANTMENT_SCHEMA_$Time.json"

Copy-Item $EnchantFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $EnchantFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_059"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $EnchantFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_059_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_059
STATUS  : SUCCESS

FILE
----
$EnchantFile

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
Set-Content "$ReportDir\CMD_059_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_059 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

