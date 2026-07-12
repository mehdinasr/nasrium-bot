# ================================================================================
# NASRIUM PROJECT
# CMD_048_BUILD_SHOP_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ShopDir="$Root\Data\Systems\Shop"

if(!(Test-Path $ShopDir)){
    New-Item -ItemType Directory -Path $ShopDir -Force | Out-Null
}

$ShopFile="$ShopDir\NSM_SHOP_SCHEMA_V1.json"

$Shop=[ordered]@{

Metadata=[ordered]@{

Module="CMD_048"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

ShopItems=@()

}

$Shop |
ConvertTo-Json -Depth 20 |
Set-Content $ShopFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_048 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_048_BUILD_SHOP_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ShopFile="$Root\Data\Systems\Shop\NSM_SHOP_SCHEMA_V1.json"

$Shop=Get-Content $ShopFile -Raw | ConvertFrom-Json

$Shop.ShopItems=@(

    [PSCustomObject]@{

        Id="shop_001"

        Name="Small Gold Pack"

        Category="Currency"

        Currency="Gem"

        Price=10

        Quantity=1000

        DailyLimit=10

        Enabled=$true

    },

    [PSCustomObject]@{

        Id="shop_002"

        Name="Hero Summon Ticket"

        Category="Ticket"

        Currency="Gem"

        Price=300

        Quantity=1

        DailyLimit=5

        Enabled=$true

    },

    [PSCustomObject]@{

        Id="shop_003"

        Name="Epic Equipment Chest"

        Category="Chest"

        Currency="Gem"

        Price=1000

        Quantity=1

        DailyLimit=2

        Enabled=$true

    },

    [PSCustomObject]@{

        Id="shop_004"

        Name="Energy Potion"

        Category="Consumable"

        Currency="Gold"

        Price=5000

        Quantity=1

        DailyLimit=20

        Enabled=$true

    }

)

$Shop |
ConvertTo-Json -Depth 20 |
Set-Content $ShopFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_048 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_048_BUILD_SHOP_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ShopFile="$Root\Data\Systems\Shop\NSM_SHOP_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_SHOP_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_SHOP_VALIDATION_V1.json"

$Shop=Get-Content $ShopFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $ShopFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_048"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

ShopItemCount=@($Shop.ShopItems).Count

File=$ShopFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_048"

Status="SUCCESS"

ShopFile=(Test-Path $ShopFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_048 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_048_BUILD_SHOP_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ShopFile="$Root\Data\Systems\Shop\NSM_SHOP_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_SHOP_SCHEMA_$Time.json"

Copy-Item $ShopFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_048"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ShopFile

Backup=$BackupFile

SHA256=(Get-FileHash $ShopFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_048_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_048
STATUS  : SUCCESS

FILE
----
$ShopFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ShopFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_048_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_048 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

