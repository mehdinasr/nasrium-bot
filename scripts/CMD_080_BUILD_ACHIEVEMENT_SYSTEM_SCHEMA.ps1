# ================================================================================
# NASRIUM PROJECT
# CMD_080_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
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

        Module    = "CMD_080"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Achievements = @()

}

$AchievementSystem |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_080 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_080_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Achievement Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AchievementFile = "$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$AchievementSystem = Get-Content $AchievementFile -Raw | ConvertFrom-Json

$AchievementSystem.Achievements = @(

    [PSCustomObject]@{

        Id = "achievement_001"

        Name = "First Steps"

        Category = "Progress"

        Description = "Complete the tutorial."

        Points = 10

        Hidden = $false

        Repeatable = $false

    },

    [PSCustomObject]@{

        Id = "achievement_002"

        Name = "Monster Hunter"

        Category = "Combat"

        Description = "Defeat 100 enemies."

        Points = 50

        Hidden = $false

        Repeatable = $false

    },

    [PSCustomObject]@{

        Id = "achievement_003"

        Name = "Master Explorer"

        Category = "Exploration"

        Description = "Discover all regions."

        Points = 100

        Hidden = $false

        Repeatable = $false

    },

    [PSCustomObject]@{

        Id = "achievement_004"

        Name = "Secret Legend"

        Category = "Hidden"

        Description = "Unlock the hidden ending."

        Points = 250

        Hidden = $true

        Repeatable = $false

    }

)

$AchievementSystem |
ConvertTo-Json -Depth 20 |
Set-Content $AchievementFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_080 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_080_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AchievementFile = "$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_ACHIEVEMENT_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_ACHIEVEMENT_SYSTEM_VALIDATION_V1.json"

$AchievementSystem = Get-Content $AchievementFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $AchievementFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_080"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    AchievementCount = @($AchievementSystem.Achievements).Count

    File = $AchievementFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_080"

    Status = "SUCCESS"

    AchievementFile = (Test-Path $AchievementFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_080 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_080_BUILD_ACHIEVEMENT_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AchievementFile = "$Root\Data\Systems\Achievements\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir, $HistoryDir, $ReportDir)) {
    if (!(Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_ACHIEVEMENT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $AchievementFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $AchievementFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_080"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $AchievementFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_080_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_080
STATUS  : SUCCESS

FILE
----
$AchievementFile

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
Set-Content "$ReportDir\CMD_080_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_080 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

