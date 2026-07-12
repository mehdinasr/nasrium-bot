# ================================================================================
# NASRIUM PROJECT
# CMD_031_BUILD_EQUIPMENT_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EquipmentDir="$Root\Data\Balance\Equipment"

if(!(Test-Path $EquipmentDir)){
    New-Item -ItemType Directory -Path $EquipmentDir -Force | Out-Null
}

$EquipmentFile="$EquipmentDir\NSM_EQUIPMENT_SCHEMA_V1.json"

$Equipment=[ordered]@{

Metadata=[ordered]@{

Module="CMD_031"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Equipment=@()

}

$Equipment |
ConvertTo-Json -Depth 20 |
Set-Content $EquipmentFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_031 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_031_BUILD_EQUIPMENT_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EquipmentFile="$Root\Data\Balance\Equipment\NSM_EQUIPMENT_SCHEMA_V1.json"

$Equipment=Get-Content $EquipmentFile -Raw | ConvertFrom-Json

$Equipment.Equipment=@(

    [PSCustomObject]@{

        Id="equipment_001"

        Name="Iron Sword"

        Category="Weapon"

        Slot="MainHand"

        Rarity="Common"

        Level=1

        Attack=15

        Defense=0

        HP=0

        CriticalRate=0

        Durability=100

        UpgradeLevel=0

        MaxUpgradeLevel=10

        SellPrice=100

        Tradable=$true

        Description="Basic melee weapon."

    },

    [PSCustomObject]@{

        Id="equipment_002"

        Name="Steel Shield"

        Category="Armor"

        Slot="OffHand"

        Rarity="Common"

        Level=1

        Attack=0

        Defense=18

        HP=100

        CriticalRate=0

        Durability=120

        UpgradeLevel=0

        MaxUpgradeLevel=10

        SellPrice=120

        Tradable=$true

        Description="Basic defensive shield."

    },

    [PSCustomObject]@{

        Id="equipment_003"

        Name="Hunter Bow"

        Category="Weapon"

        Slot="MainHand"

        Rarity="Rare"

        Level=5

        Attack=35

        Defense=0

        HP=0

        CriticalRate=5

        Durability=90

        UpgradeLevel=0

        MaxUpgradeLevel=15

        SellPrice=450

        Tradable=$true

        Description="Long range weapon."

    },

    [PSCustomObject]@{

        Id="equipment_004"

        Name="Wizard Staff"

        Category="Weapon"

        Slot="MainHand"

        Rarity="Epic"

        Level=10

        Attack=60

        Defense=5

        HP=50

        CriticalRate=8

        Durability=80

        UpgradeLevel=0

        MaxUpgradeLevel=20

        SellPrice=1200

        Tradable=$false

        Description="Magic staff."

    }

)

$Equipment |
ConvertTo-Json -Depth 20 |
Set-Content $EquipmentFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_031 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_031_BUILD_EQUIPMENT_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EquipmentFile="$Root\Data\Balance\Equipment\NSM_EQUIPMENT_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_EQUIPMENT_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_EQUIPMENT_VALIDATION_V1.json"

$Equipment=Get-Content $EquipmentFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $EquipmentFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_031"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

EquipmentCount=@($Equipment.Equipment).Count

File=$EquipmentFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_031"

Status="SUCCESS"

EquipmentFile=(Test-Path $EquipmentFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_031 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_031_BUILD_EQUIPMENT_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EquipmentFile="$Root\Data\Balance\Equipment\NSM_EQUIPMENT_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_EQUIPMENT_SCHEMA_$Time.json"

Copy-Item $EquipmentFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_031"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$EquipmentFile

Backup=$BackupFile

SHA256=(Get-FileHash $EquipmentFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_031_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_031
STATUS  : SUCCESS

FILE
----
$EquipmentFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $EquipmentFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_031_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_031 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

