# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Achievement System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$AchievementDir = "$Root\Data\Systems\Achievements"

if (!(Test-Path $AchievementDir)) {
    New-Item -ItemType Directory -Path $AchievementDir -Force | Out-Null
}

$AchievementFile = "$AchievementDir\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$AchievementSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_082"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Achievements = @()

}

$AchievementSystem |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_082 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Achievement System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$AchievementSystem=Get-Content $AchievementFile -Raw | ConvertFrom-Json

$AchievementSystem.Achievements=@(

    [PSCustomObject]@{

        Id="achievement_001"

        Name="First Blood"

        Category="Battle"

        Tier="Bronze"

        MaxLevel=1

        Target=1

        Reward=@{

            Gold=100

            Gems=5

            XP=25

        }

        Hidden=$false

    },

    [PSCustomObject]@{

        Id="achievement_002"

        Name="Builder"

        Category="Construction"

        Tier="Silver"

        MaxLevel=5

        Target=50

        Reward=@{

            Gold=500

            Gems=20

            XP=100

        }

        Hidden=$false

    },

    [PSCustomObject]@{

        Id="achievement_003"

        Name="Conqueror"

        Category="Battle"

        Tier="Gold"

        MaxLevel=10

        Target=500

        Reward=@{

            Gold=2500

            Gems=100

            XP=500

        }

        Hidden=$false

    }

)

$AchievementSystem |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_082 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_ACHIEVEMENT_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_ACHIEVEMENT_VALIDATION_V1.json"

$Achievement=Get-Content $AchievementFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_082"

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

    Module="CMD_082"

    Status="SUCCESS"

    SchemaExists=(Test-Path $AchievementFile)

    MetadataExists=(Test-Path $MetadataFile)

    AchievementCount=@($Achievement.Achievements).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_082 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $AchievementFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_082"

    Module="ACHIEVEMENT_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$AchievementFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_082_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $AchievementFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_082"

    Module="ACHIEVEMENT_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$AchievementFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_082_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_082_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AchievementFile="$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_082_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_082_HISTORY_","")

$BackupFile="$BackupDir\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $AchievementFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_082
MODULE  : ACHIEVEMENT SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$AchievementFile

BACKUP
------
$BackupFile

SHA256
------
$Hash

DATE
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==========================================================

"@

$Report |
Set-Content "$ReportDir\CMD_082_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_082 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

