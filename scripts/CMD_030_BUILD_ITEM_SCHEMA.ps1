# ================================================================================
# NASRIUM PROJECT
# CMD_030_BUILD_ITEM_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ItemDir="$Root\Data\Balance\Items"

if(!(Test-Path $ItemDir)){
    New-Item -ItemType Directory -Path $ItemDir -Force | Out-Null
}

$ItemFile="$ItemDir\NSM_ITEM_SCHEMA_V1.json"

$Item=[ordered]@{

Metadata=[ordered]@{

Module="CMD_030"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Items=@()

}

$Item |
ConvertTo-Json -Depth 20 |
Set-Content $ItemFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_030 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_030_BUILD_ITEM_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ItemFile="$Root\Data\Balance\Items\NSM_ITEM_SCHEMA_V1.json"

$Item=Get-Content $ItemFile -Raw | ConvertFrom-Json

$Item.Items=@(

    [PSCustomObject]@{

        Id="item_001"

        Name="Health Potion"

        Category="Consumable"

        Rarity="Common"

        StackLimit=99

        BuyPrice=50

        SellPrice=25

        Tradable=$true

        Description="Restore Health."

    },

    [PSCustomObject]@{

        Id="item_002"

        Name="Mana Potion"

        Category="Consumable"

        Rarity="Common"

        StackLimit=99

        BuyPrice=60

        SellPrice=30

        Tradable=$true

        Description="Restore Mana."

    },

    [PSCustomObject]@{

        Id="item_003"

        Name="Revive Scroll"

        Category="Support"

        Rarity="Epic"

        StackLimit=10

        BuyPrice=500

        SellPrice=250

        Tradable=$false

        Description="Revives one hero."

    },

    [PSCustomObject]@{

        Id="item_004"

        Name="Enhancement Stone"

        Category="Upgrade"

        Rarity="Rare"

        StackLimit=999

        BuyPrice=200

        SellPrice=100

        Tradable=$true

        Description="Used for equipment upgrades."

    }

)

$Item |
ConvertTo-Json -Depth 20 |
Set-Content $ItemFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_030 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_030_BUILD_ITEM_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ItemFile="$Root\Data\Balance\Items\NSM_ITEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_ITEM_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_ITEM_VALIDATION_V1.json"

$Item=Get-Content $ItemFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $ItemFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_030"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

ItemCount=@($Item.Items).Count

File=$ItemFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_030"

Status="SUCCESS"

ItemFile=(Test-Path $ItemFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_030 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_030_BUILD_ITEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ItemFile="$Root\Data\Balance\Items\NSM_ITEM_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_ITEM_SCHEMA_$Time.json"

Copy-Item $ItemFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_030"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ItemFile

Backup=$BackupFile

SHA256=(Get-FileHash $ItemFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_030_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_030
STATUS  : SUCCESS

FILE
----
$ItemFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ItemFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_030_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_030 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

