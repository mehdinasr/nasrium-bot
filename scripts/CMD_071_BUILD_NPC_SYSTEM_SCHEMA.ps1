# ================================================================================
# NASRIUM PROJECT
# CMD_071_BUILD_NPC_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create NPC System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$NpcDir = "$Root\Data\Systems\NPC"

if (!(Test-Path $NpcDir)) {
    New-Item -ItemType Directory -Path $NpcDir -Force | Out-Null
}

$NpcFile = "$NpcDir\NSM_NPC_SYSTEM_SCHEMA_V1.json"

$NpcSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_071"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    NPCProfiles = @()

}

$NpcSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NpcFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_071 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_071_BUILD_NPC_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# NPC Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NpcFile = "$Root\Data\Systems\NPC\NSM_NPC_SYSTEM_SCHEMA_V1.json"

$NpcSystem = Get-Content $NpcFile -Raw | ConvertFrom-Json

$NpcSystem.NPCProfiles = @(

    [PSCustomObject]@{

        Id = "npc_001"

        Name = "Village Merchant"

        Category = "Merchant"

        Level = 1

        IsQuestGiver = $false

        IsVendor = $true

        IsTrainer = $false

        RespawnTimeSeconds = 0

    },

    [PSCustomObject]@{

        Id = "npc_002"

        Name = "Captain Roland"

        Category = "Quest"

        Level = 10

        IsQuestGiver = $true

        IsVendor = $false

        IsTrainer = $false

        RespawnTimeSeconds = 0

    },

    [PSCustomObject]@{

        Id = "npc_003"

        Name = "Master Blacksmith"

        Category = "Trainer"

        Level = 25

        IsQuestGiver = $false

        IsVendor = $true

        IsTrainer = $true

        RespawnTimeSeconds = 0

    },

    [PSCustomObject]@{

        Id = "npc_004"

        Name = "Ancient Guardian"

        Category = "Boss"

        Level = 80

        IsQuestGiver = $false

        IsVendor = $false

        IsTrainer = $false

        RespawnTimeSeconds = 7200

    }

)

$NpcSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NpcFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_071 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_071_BUILD_NPC_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NpcFile = "$Root\Data\Systems\NPC\NSM_NPC_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_NPC_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_NPC_SYSTEM_VALIDATION_V1.json"

$NpcSystem = Get-Content $NpcFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $NpcFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_071"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    NPCCount = @($NpcSystem.NPCProfiles).Count

    File = $NpcFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_071"

    Status = "SUCCESS"

    NPCFile = (Test-Path $NpcFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_071 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_071_BUILD_NPC_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NpcFile = "$Root\Data\Systems\NPC\NSM_NPC_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_NPC_SYSTEM_SCHEMA_$Time.json"

Copy-Item $NpcFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $NpcFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_071"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $NpcFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_071_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_071
STATUS  : SUCCESS

FILE
----
$NpcFile

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
Set-Content "$ReportDir\CMD_071_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_071 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

