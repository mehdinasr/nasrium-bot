# ================================================================================
# NASRIUM PROJECT
# CMD_078_BUILD_FACTION_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Faction System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$FactionDir = "$Root\Data\Systems\Factions"

if (!(Test-Path $FactionDir)) {
    New-Item -ItemType Directory -Path $FactionDir -Force | Out-Null
}

$FactionFile = "$FactionDir\NSM_FACTION_SYSTEM_SCHEMA_V1.json"

$FactionSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_078"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Factions = @()

}

$FactionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $FactionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_078 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_078_BUILD_FACTION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Faction Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FactionFile = "$Root\Data\Systems\Factions\NSM_FACTION_SYSTEM_SCHEMA_V1.json"

$FactionSystem = Get-Content $FactionFile -Raw | ConvertFrom-Json

$FactionSystem.Factions = @(

    [PSCustomObject]@{

        Id = "faction_001"

        Name = "Kingdom Alliance"

        Category = "Kingdom"

        Alignment = "Good"

        DefaultReputation = 0

        MaxReputation = 10000

        CanJoin = $true

        IsHostile = $false

    },

    [PSCustomObject]@{

        Id = "faction_002"

        Name = "Shadow Syndicate"

        Category = "Guild"

        Alignment = "Neutral"

        DefaultReputation = 0

        MaxReputation = 10000

        CanJoin = $true

        IsHostile = $false

    },

    [PSCustomObject]@{

        Id = "faction_003"

        Name = "Crimson Legion"

        Category = "Military"

        Alignment = "Evil"

        DefaultReputation = -500

        MaxReputation = 10000

        CanJoin = $false

        IsHostile = $true

    },

    [PSCustomObject]@{

        Id = "faction_004"

        Name = "Ancient Guardians"

        Category = "Ancient"

        Alignment = "Neutral"

        DefaultReputation = 100

        MaxReputation = 10000

        CanJoin = $false

        IsHostile = $false

    }

)

$FactionSystem |
ConvertTo-Json -Depth 20 |
Set-Content $FactionFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_078 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_078_BUILD_FACTION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FactionFile = "$Root\Data\Systems\Factions\NSM_FACTION_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_FACTION_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_FACTION_SYSTEM_VALIDATION_V1.json"

$FactionSystem = Get-Content $FactionFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $FactionFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_078"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    FactionCount = @($FactionSystem.Factions).Count

    File = $FactionFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_078"

    Status = "SUCCESS"

    FactionFile = (Test-Path $FactionFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_078 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_078_BUILD_FACTION_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FactionFile = "$Root\Data\Systems\Factions\NSM_FACTION_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_FACTION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $FactionFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $FactionFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_078"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $FactionFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_078_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_078
STATUS  : SUCCESS

FILE
----
$FactionFile

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
Set-Content "$ReportDir\CMD_078_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_078 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

