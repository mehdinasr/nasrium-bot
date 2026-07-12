# ================================================================================
# NASRIUM PROJECT
# CMD_054_BUILD_AI_BEHAVIOR_SCHEMA
# STEP 001
# ================================================================================
#
# Create AI Behavior Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$AIDir = "$Root\Data\AI"

if (!(Test-Path $AIDir)) {
    New-Item -ItemType Directory -Path $AIDir -Force | Out-Null
}

$AIFile = "$AIDir\NSM_AI_BEHAVIOR_SCHEMA_V1.json"

$AI = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_054"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Behaviors = @()

}

$AI |
ConvertTo-Json -Depth 20 |
Set-Content $AIFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_054 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_054_BUILD_AI_BEHAVIOR_SCHEMA
# STEP 002
# ================================================================================
#
# AI Behavior Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AIFile = "$Root\Data\AI\NSM_AI_BEHAVIOR_SCHEMA_V1.json"

$AI = Get-Content $AIFile -Raw | ConvertFrom-Json

$AI.Behaviors = @(

    [PSCustomObject]@{

        Id = "ai_001"

        Name = "Aggressive"

        DetectionRange = 15

        AttackRange = 2

        ChaseRange = 25

        RetreatHealthPercent = 0

        PriorityTarget = "NearestEnemy"

        SkillUsage = "Always"

    },

    [PSCustomObject]@{

        Id = "ai_002"

        Name = "Defensive"

        DetectionRange = 12

        AttackRange = 2

        ChaseRange = 10

        RetreatHealthPercent = 25

        PriorityTarget = "NearestEnemy"

        SkillUsage = "WhenAvailable"

    },

    [PSCustomObject]@{

        Id = "ai_003"

        Name = "Ranged"

        DetectionRange = 20

        AttackRange = 10

        ChaseRange = 18

        RetreatHealthPercent = 15

        PriorityTarget = "LowestHealthEnemy"

        SkillUsage = "KeepDistance"

    },

    [PSCustomObject]@{

        Id = "ai_004"

        Name = "Support"

        DetectionRange = 18

        AttackRange = 8

        ChaseRange = 8

        RetreatHealthPercent = 40

        PriorityTarget = "LowestHealthAlly"

        SkillUsage = "HealFirst"

    }

)

$AI |
ConvertTo-Json -Depth 20 |
Set-Content $AIFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_054 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_054_BUILD_AI_BEHAVIOR_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AIFile = "$Root\Data\AI\NSM_AI_BEHAVIOR_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_AI_BEHAVIOR_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_AI_BEHAVIOR_VALIDATION_V1.json"

$AI = Get-Content $AIFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $AIFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_054"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    BehaviorCount = @($AI.Behaviors).Count

    File = $AIFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_054"

    Status = "SUCCESS"

    AIFile = (Test-Path $AIFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_054 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_054_BUILD_AI_BEHAVIOR_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$AIFile = "$Root\Data\AI\NSM_AI_BEHAVIOR_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_AI_BEHAVIOR_SCHEMA_$Time.json"

Copy-Item $AIFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $AIFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_054"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $AIFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_054_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_054
STATUS  : SUCCESS

FILE
----
$AIFile

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
Set-Content "$ReportDir\CMD_054_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_054 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

