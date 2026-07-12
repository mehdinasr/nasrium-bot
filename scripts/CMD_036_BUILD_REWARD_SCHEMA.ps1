# ================================================================================
# NASRIUM PROJECT
# CMD_036_BUILD_REWARD_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$RewardDir="$Root\Data\Balance\Rewards"

if(!(Test-Path $RewardDir)){
    New-Item -ItemType Directory -Path $RewardDir -Force | Out-Null
}

$RewardFile="$RewardDir\NSM_REWARD_SCHEMA_V1.json"

$Reward=[ordered]@{

Metadata=[ordered]@{

Module="CMD_036"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Rewards=@()

}

$Reward |
ConvertTo-Json -Depth 20 |
Set-Content $RewardFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_036 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_036_BUILD_REWARD_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RewardFile="$Root\Data\Balance\Rewards\NSM_REWARD_SCHEMA_V1.json"

$Reward=Get-Content $RewardFile -Raw | ConvertFrom-Json

$Reward.Rewards=@(

    [PSCustomObject]@{

        Id="reward_001"

        Name="Stage Clear"

        Category="Stage"

        Gold=100

        Experience=50

        Gems=0

        Energy=0

        Items=@(

            [PSCustomObject]@{

                ItemId="item_001"

                Quantity=2

                DropChance=100

            }

        )

    },

    [PSCustomObject]@{

        Id="reward_002"

        Name="Elite Victory"

        Category="Elite"

        Gold=500

        Experience=250

        Gems=5

        Energy=0

        Items=@(

            [PSCustomObject]@{

                ItemId="item_004"

                Quantity=1

                DropChance=50

            }

        )

    },

    [PSCustomObject]@{

        Id="reward_003"

        Name="Boss Reward"

        Category="Boss"

        Gold=5000

        Experience=2000

        Gems=50

        Energy=0

        Items=@(

            [PSCustomObject]@{

                ItemId="item_003"

                Quantity=1

                DropChance=100

            }

        )

    },

    [PSCustomObject]@{

        Id="reward_004"

        Name="Daily Login"

        Category="Daily"

        Gold=300

        Experience=100

        Gems=2

        Energy=20

        Items=@()

    }

)

$Reward |
ConvertTo-Json -Depth 20 |
Set-Content $RewardFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_036 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_036_BUILD_REWARD_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RewardFile="$Root\Data\Balance\Rewards\NSM_REWARD_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_REWARD_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_REWARD_VALIDATION_V1.json"

$Reward=Get-Content $RewardFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $RewardFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_036"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

RewardCount=@($Reward.Rewards).Count

File=$RewardFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_036"

Status="SUCCESS"

RewardFile=(Test-Path $RewardFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_036 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_036_BUILD_REWARD_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$RewardFile="$Root\Data\Balance\Rewards\NSM_REWARD_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_REWARD_SCHEMA_$Time.json"

Copy-Item $RewardFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_036"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$RewardFile

Backup=$BackupFile

SHA256=(Get-FileHash $RewardFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_036_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_036
STATUS  : SUCCESS

FILE
----
$RewardFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $RewardFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_036_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_036 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

