# ================================================================================
# NASRIUM PROJECT
# CMD_041_BUILD_QUEST_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$QuestDir="$Root\Data\Balance\Quests"

if(!(Test-Path $QuestDir)){
    New-Item -ItemType Directory -Path $QuestDir -Force | Out-Null
}

$QuestFile="$QuestDir\NSM_QUEST_SCHEMA_V1.json"

$Quest=[ordered]@{

Metadata=[ordered]@{

Module="CMD_041"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Quests=@()

}

$Quest |
ConvertTo-Json -Depth 20 |
Set-Content $QuestFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_041 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_041_BUILD_QUEST_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$QuestFile="$Root\Data\Balance\Quests\NSM_QUEST_SCHEMA_V1.json"

$Quest=Get-Content $QuestFile -Raw | ConvertFrom-Json

$Quest.Quests=@(

    [PSCustomObject]@{

        Id="quest_001"

        Name="First Victory"

        Category="Main"

        Description="Clear Stage 1."

        RequiredLevel=1

        ObjectiveType="StageClear"

        ObjectiveTarget="stage_001"

        ObjectiveValue=1

        Rewards=[PSCustomObject]@{

            Gold=100

            Experience=50

            Gems=5

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="quest_002"

        Name="Hero Training"

        Category="Daily"

        Description="Upgrade one hero."

        RequiredLevel=2

        ObjectiveType="HeroUpgrade"

        ObjectiveTarget="Any"

        ObjectiveValue=1

        Rewards=[PSCustomObject]@{

            Gold=300

            Experience=100

            Gems=2

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="quest_003"

        Name="Treasure Hunter"

        Category="Weekly"

        Description="Collect 1000 Gold."

        RequiredLevel=5

        ObjectiveType="CollectGold"

        ObjectiveTarget="Gold"

        ObjectiveValue=1000

        Rewards=[PSCustomObject]@{

            Gold=1000

            Experience=500

            Gems=20

            Items=@(

                [PSCustomObject]@{

                    ItemId="item_003"

                    Quantity=1

                }

            )

        }

    },

    [PSCustomObject]@{

        Id="quest_004"

        Name="Dragon Slayer"

        Category="Main"

        Description="Defeat the Ancient Dragon."

        RequiredLevel=10

        ObjectiveType="BossKill"

        ObjectiveTarget="enemy_004"

        ObjectiveValue=1

        Rewards=[PSCustomObject]@{

            Gold=5000

            Experience=3000

            Gems=100

            Items=@(

                [PSCustomObject]@{

                    ItemId="item_004"

                    Quantity=2

                }

            )

        }

    }

)

$Quest |
ConvertTo-Json -Depth 20 |
Set-Content $QuestFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_041 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_041_BUILD_QUEST_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$QuestFile="$Root\Data\Balance\Quests\NSM_QUEST_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_QUEST_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_QUEST_VALIDATION_V1.json"

$Quest=Get-Content $QuestFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $QuestFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_041"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

QuestCount=@($Quest.Quests).Count

File=$QuestFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_041"

Status="SUCCESS"

QuestFile=(Test-Path $QuestFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_041 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_041_BUILD_QUEST_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$QuestFile="$Root\Data\Balance\Quests\NSM_QUEST_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_QUEST_SCHEMA_$Time.json"

Copy-Item $QuestFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_041"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$QuestFile

Backup=$BackupFile

SHA256=(Get-FileHash $QuestFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_041_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_041
STATUS  : SUCCESS

FILE
----
$QuestFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $QuestFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_041_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_041 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

