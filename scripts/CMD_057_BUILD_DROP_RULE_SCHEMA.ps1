# ================================================================================
# NASRIUM PROJECT
# CMD_057_BUILD_DROP_RULE_SCHEMA
# STEP 001
# ================================================================================
#
# Create Drop Rule Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$DropRuleDir = "$Root\Data\Balance\DropRules"

if (!(Test-Path $DropRuleDir)) {
    New-Item -ItemType Directory -Path $DropRuleDir -Force | Out-Null
}

$DropRuleFile = "$DropRuleDir\NSM_DROP_RULE_SCHEMA_V1.json"

$DropRule = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_057"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    DropRules = @()

}

$DropRule |
ConvertTo-Json -Depth 20 |
Set-Content $DropRuleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_057 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_057_BUILD_DROP_RULE_SCHEMA
# STEP 002
# ================================================================================
#
# Drop Rule Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DropRuleFile = "$Root\Data\Balance\DropRules\NSM_DROP_RULE_SCHEMA_V1.json"

$DropRule = Get-Content $DropRuleFile -Raw | ConvertFrom-Json

$DropRule.DropRules = @(

    [PSCustomObject]@{

        Id = "drop_rule_001"

        Name = "Standard Monster"

        LootTableId = "loot_001"

        MinimumPlayerLevel = 1

        MaximumPlayerLevel = 999

        PartyEligible = $true

        RequiresQuest = $false

        DropMultiplier = 1.0

    },

    [PSCustomObject]@{

        Id = "drop_rule_002"

        Name = "Elite Monster"

        LootTableId = "loot_002"

        MinimumPlayerLevel = 20

        MaximumPlayerLevel = 999

        PartyEligible = $true

        RequiresQuest = $false

        DropMultiplier = 1.5

    },

    [PSCustomObject]@{

        Id = "drop_rule_003"

        Name = "World Boss"

        LootTableId = "loot_003"

        MinimumPlayerLevel = 50

        MaximumPlayerLevel = 999

        PartyEligible = $true

        RequiresQuest = $false

        DropMultiplier = 2.0

    },

    [PSCustomObject]@{

        Id = "drop_rule_004"

        Name = "Quest Reward"

        LootTableId = "loot_001"

        MinimumPlayerLevel = 1

        MaximumPlayerLevel = 999

        PartyEligible = $false

        RequiresQuest = $true

        DropMultiplier = 1.0

    }

)

$DropRule |
ConvertTo-Json -Depth 20 |
Set-Content $DropRuleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_057 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_057_BUILD_DROP_RULE_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DropRuleFile = "$Root\Data\Balance\DropRules\NSM_DROP_RULE_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_DROP_RULE_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_DROP_RULE_VALIDATION_V1.json"

$DropRule = Get-Content $DropRuleFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $DropRuleFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_057"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    DropRuleCount = @($DropRule.DropRules).Count

    File = $DropRuleFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_057"

    Status = "SUCCESS"

    DropRuleFile = (Test-Path $DropRuleFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_057 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_057_BUILD_DROP_RULE_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DropRuleFile = "$Root\Data\Balance\DropRules\NSM_DROP_RULE_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_DROP_RULE_SCHEMA_$Time.json"

Copy-Item $DropRuleFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $DropRuleFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_057"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $DropRuleFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_057_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_057
STATUS  : SUCCESS

FILE
----
$DropRuleFile

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
Set-Content "$ReportDir\CMD_057_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_057 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

