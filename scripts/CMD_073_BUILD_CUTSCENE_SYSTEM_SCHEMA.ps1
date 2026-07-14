# ================================================================================
# NASRIUM PROJECT
# CMD_073_BUILD_CUTSCENE_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Cutscene System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$CutsceneDir = "$Root\Data\Systems\Cutscenes"

if (!(Test-Path $CutsceneDir)) {
    New-Item -ItemType Directory -Path $CutsceneDir -Force | Out-Null
}

$CutsceneFile = "$CutsceneDir\NSM_CUTSCENE_SYSTEM_SCHEMA_V1.json"

$CutsceneSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_073"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Cutscenes = @()

}

$CutsceneSystem |
ConvertTo-Json -Depth 20 |
Set-Content $CutsceneFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_073 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_073_BUILD_CUTSCENE_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Cutscene Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CutsceneFile = "$Root\Data\Systems\Cutscenes\NSM_CUTSCENE_SYSTEM_SCHEMA_V1.json"

$CutsceneSystem = Get-Content $CutsceneFile -Raw | ConvertFrom-Json

$CutsceneSystem.Cutscenes = @(

    [PSCustomObject]@{

        Id = "cutscene_001"

        Name = "Game Introduction"

        Category = "Intro"

        Trigger = "FirstLogin"

        Skippable = $true

        DurationSeconds = 90

        VoiceOver = $true

        CinematicMode = $true

    },

    [PSCustomObject]@{

        Id = "cutscene_002"

        Name = "Quest Arrival"

        Category = "Quest"

        Trigger = "QuestAccepted"

        Skippable = $true

        DurationSeconds = 45

        VoiceOver = $false

        CinematicMode = $true

    },

    [PSCustomObject]@{

        Id = "cutscene_003"

        Name = "Boss Encounter"

        Category = "Boss"

        Trigger = "BossSpawn"

        Skippable = $false

        DurationSeconds = 60

        VoiceOver = $true

        CinematicMode = $true

    },

    [PSCustomObject]@{

        Id = "cutscene_004"

        Name = "Ending"

        Category = "Story"

        Trigger = "FinalQuestCompleted"

        Skippable = $false

        DurationSeconds = 180

        VoiceOver = $true

        CinematicMode = $true

    }

)

$CutsceneSystem |
ConvertTo-Json -Depth 20 |
Set-Content $CutsceneFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_073 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_073_BUILD_CUTSCENE_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CutsceneFile = "$Root\Data\Systems\Cutscenes\NSM_CUTSCENE_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_CUTSCENE_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_CUTSCENE_SYSTEM_VALIDATION_V1.json"

$CutsceneSystem = Get-Content $CutsceneFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $CutsceneFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_073"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    CutsceneCount = @($CutsceneSystem.Cutscenes).Count

    File = $CutsceneFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_073"

    Status = "SUCCESS"

    CutsceneFile = (Test-Path $CutsceneFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_073 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_073_BUILD_CUTSCENE_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$CutsceneFile = "$Root\Data\Systems\Cutscenes\NSM_CUTSCENE_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_CUTSCENE_SYSTEM_SCHEMA_$Time.json"

Copy-Item $CutsceneFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $CutsceneFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_073"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $CutsceneFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_073_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_073
STATUS  : SUCCESS

FILE
----
$CutsceneFile

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
Set-Content "$ReportDir\CMD_073_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_073 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

