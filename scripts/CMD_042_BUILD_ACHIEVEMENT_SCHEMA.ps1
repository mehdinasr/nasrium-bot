# ================================================================================
# NASRIUM PROJECT
# CMD_042_BUILD_ACHIEVEMENT_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementDir="$Root\Data\Balance\Achievements"

if(!(Test-Path $AchievementDir)){
    New-Item -ItemType Directory -Path $AchievementDir -Force | Out-Null
}

$AchievementFile="$AchievementDir\NSM_ACHIEVEMENT_SCHEMA_V1.json"

$Achievement=[ordered]@{

Metadata=[ordered]@{

Module="CMD_042"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Achievements=@()

}

$Achievement |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_042 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_042_BUILD_ACHIEVEMENT_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Balance\Achievements\NSM_ACHIEVEMENT_SCHEMA_V1.json"

$Achievement=Get-Content $AchievementFile -Raw | ConvertFrom-Json

$Achievement.Achievements=@(

    [PSCustomObject]@{

        Id="achievement_001"

        Name="First Blood"

        Category="Battle"

        Description="Defeat your first enemy."

        TargetType="EnemyKill"

        TargetValue=1

        Hidden=$false

        Rewards=[PSCustomObject]@{

            Gold=100

            Gems=5

            Title="Beginner"

        }

    },

    [PSCustomObject]@{

        Id="achievement_002"

        Name="Hero Collector"

        Category="Collection"

        Description="Recruit 10 heroes."

        TargetType="HeroOwned"

        TargetValue=10

        Hidden=$false

        Rewards=[PSCustomObject]@{

            Gold=1000

            Gems=25

            Title="Collector"

        }

    },

    [PSCustomObject]@{

        Id="achievement_003"

        Name="Dragon Slayer"

        Category="Boss"

        Description="Defeat the Ancient Dragon."

        TargetType="BossKill"

        TargetValue=1

        Hidden=$false

        Rewards=[PSCustomObject]@{

            Gold=5000

            Gems=100

            Title="Dragon Slayer"

        }

    },

    [PSCustomObject]@{

        Id="achievement_004"

        Name="Legend"

        Category="Progress"

        Description="Reach player level 100."

        TargetType="PlayerLevel"

        TargetValue=100

        Hidden=$true

        Rewards=[PSCustomObject]@{

            Gold=100000

            Gems=1000

            Title="Legend"

        }

    }

)

$Achievement |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_042 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_042_BUILD_ACHIEVEMENT_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Balance\Achievements\NSM_ACHIEVEMENT_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_ACHIEVEMENT_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_ACHIEVEMENT_VALIDATION_V1.json"

$Achievement=Get-Content $AchievementFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_042"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

AchievementCount=@($Achievement.Achievements).Count

File=$AchievementFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_042"

Status="SUCCESS"

AchievementFile=(Test-Path $AchievementFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_042 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_042_BUILD_ACHIEVEMENT_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Balance\Achievements\NSM_ACHIEVEMENT_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_ACHIEVEMENT_SCHEMA_$Time.json"

Copy-Item $AchievementFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_042"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$AchievementFile

Backup=$BackupFile

SHA256=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_042_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_042
STATUS  : SUCCESS

FILE
----
$AchievementFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $AchievementFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_042_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_042 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

