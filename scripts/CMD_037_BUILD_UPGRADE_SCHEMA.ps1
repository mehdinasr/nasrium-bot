# ================================================================================
# NASRIUM PROJECT
# CMD_037_BUILD_UPGRADE_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$UpgradeDir="$Root\Data\Balance\Upgrades"

if(!(Test-Path $UpgradeDir)){
    New-Item -ItemType Directory -Path $UpgradeDir -Force | Out-Null
}

$UpgradeFile="$UpgradeDir\NSM_UPGRADE_SCHEMA_V1.json"

$Upgrade=[ordered]@{

Metadata=[ordered]@{

Module="CMD_037"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Upgrades=@()

}

$Upgrade |
ConvertTo-Json -Depth 20 |
Set-Content $UpgradeFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_037 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_037_BUILD_UPGRADE_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$UpgradeFile="$Root\Data\Balance\Upgrades\NSM_UPGRADE_SCHEMA_V1.json"

$Upgrade=Get-Content $UpgradeFile -Raw | ConvertFrom-Json

$Upgrade.Upgrades=@(

    [PSCustomObject]@{

        Id="upgrade_001"

        Category="Hero"

        Level=1

        CostGold=100

        CostGem=0

        RequiredItem=""

        SuccessRate=100

        AttackBonus=5

        DefenseBonus=2

        HPBonus=20

    },

    [PSCustomObject]@{

        Id="upgrade_002"

        Category="Hero"

        Level=2

        CostGold=250

        CostGem=0

        RequiredItem="item_004"

        SuccessRate=100

        AttackBonus=10

        DefenseBonus=5

        HPBonus=40

    },

    [PSCustomObject]@{

        Id="upgrade_003"

        Category="Equipment"

        Level=1

        CostGold=500

        CostGem=0

        RequiredItem="item_004"

        SuccessRate=95

        AttackBonus=15

        DefenseBonus=10

        HPBonus=50

    },

    [PSCustomObject]@{

        Id="upgrade_004"

        Category="Equipment"

        Level=2

        CostGold=1200

        CostGem=5

        RequiredItem="item_004"

        SuccessRate=85

        AttackBonus=30

        DefenseBonus=20

        HPBonus=100

    }

)

$Upgrade |
ConvertTo-Json -Depth 20 |
Set-Content $UpgradeFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_037 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_037_BUILD_UPGRADE_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$UpgradeFile="$Root\Data\Balance\Upgrades\NSM_UPGRADE_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_UPGRADE_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_UPGRADE_VALIDATION_V1.json"

$Upgrade=Get-Content $UpgradeFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $UpgradeFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_037"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

UpgradeCount=@($Upgrade.Upgrades).Count

File=$UpgradeFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_037"

Status="SUCCESS"

UpgradeFile=(Test-Path $UpgradeFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_037 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_037_BUILD_UPGRADE_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$UpgradeFile="$Root\Data\Balance\Upgrades\NSM_UPGRADE_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_UPGRADE_SCHEMA_$Time.json"

Copy-Item $UpgradeFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_037"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$UpgradeFile

Backup=$BackupFile

SHA256=(Get-FileHash $UpgradeFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_037_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_037
STATUS  : SUCCESS

FILE
----
$UpgradeFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $UpgradeFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_037_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_037 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

