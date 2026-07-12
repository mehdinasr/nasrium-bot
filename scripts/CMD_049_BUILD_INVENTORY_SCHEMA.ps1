# ================================================================================
# NASRIUM PROJECT
# CMD_049_BUILD_INVENTORY_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$InventoryDir="$Root\Data\Systems\Inventory"

if(!(Test-Path $InventoryDir)){
    New-Item -ItemType Directory -Path $InventoryDir -Force | Out-Null
}

$InventoryFile="$InventoryDir\NSM_INVENTORY_SCHEMA_V1.json"

$Inventory=[ordered]@{

Metadata=[ordered]@{

Module="CMD_049"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

InventoryRules=@()

}

$Inventory |
ConvertTo-Json -Depth 20 |
Set-Content $InventoryFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_049 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_049_BUILD_INVENTORY_SCHEMA
# STEP 002
# ================================================================================
#
# Inventory Rules
#
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$InventoryFile="$Root\Data\Systems\Inventory\NSM_INVENTORY_SCHEMA_V1.json"

$Inventory=Get-Content $InventoryFile -Raw | ConvertFrom-Json

$Inventory.InventoryRules=@(

    [PSCustomObject]@{

        Id="inventory_001"

        Category="Equipment"

        MaxStack=1

        MaxSlots=500

        Tradable=$true

        Sellable=$true

        Destroyable=$true

    },

    [PSCustomObject]@{

        Id="inventory_002"

        Category="Consumable"

        MaxStack=999

        MaxSlots=500

        Tradable=$true

        Sellable=$true

        Destroyable=$true

    },

    [PSCustomObject]@{

        Id="inventory_003"

        Category="Material"

        MaxStack=9999

        MaxSlots=500

        Tradable=$true

        Sellable=$true

        Destroyable=$true

    },

    [PSCustomObject]@{

        Id="inventory_004"

        Category="Quest"

        MaxStack=999

        MaxSlots=500

        Tradable=$false

        Sellable=$false

        Destroyable=$false

    }

)

$Inventory |
ConvertTo-Json -Depth 20 |
Set-Content $InventoryFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_049 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_049_BUILD_INVENTORY_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$InventoryFile="$Root\Data\Systems\Inventory\NSM_INVENTORY_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_INVENTORY_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_INVENTORY_VALIDATION_V1.json"

$Inventory=Get-Content $InventoryFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $InventoryFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_049"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

InventoryRuleCount=@($Inventory.InventoryRules).Count

File=$InventoryFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_049"

Status="SUCCESS"

InventoryFile=(Test-Path $InventoryFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_049 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_049_BUILD_INVENTORY_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$InventoryFile="$Root\Data\Systems\Inventory\NSM_INVENTORY_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_INVENTORY_SCHEMA_$Time.json"

Copy-Item $InventoryFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_049"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$InventoryFile

Backup=$BackupFile

SHA256=(Get-FileHash $InventoryFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_049_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_049
STATUS  : SUCCESS

FILE
----
$InventoryFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $InventoryFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_049_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_049 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

