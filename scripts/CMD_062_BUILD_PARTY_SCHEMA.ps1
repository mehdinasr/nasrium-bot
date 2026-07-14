# ================================================================================
# NASRIUM PROJECT
# CMD_062_BUILD_PARTY_SCHEMA
# STEP 001
# ================================================================================
#
# Create Party Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$PartyDir = "$Root\Data\Systems\Party"

if (!(Test-Path $PartyDir)) {
    New-Item -ItemType Directory -Path $PartyDir -Force | Out-Null
}

$PartyFile = "$PartyDir\NSM_PARTY_SCHEMA_V1.json"

$Party = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_062"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Parties = @()

}

$Party |
ConvertTo-Json -Depth 20 |
Set-Content $PartyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_062 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_062_BUILD_PARTY_SCHEMA
# STEP 002
# ================================================================================
#
# Party Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$PartyFile = "$Root\Data\Systems\Party\NSM_PARTY_SCHEMA_V1.json"

$Party = Get-Content $PartyFile -Raw | ConvertFrom-Json

$Party.Parties = @(

    [PSCustomObject]@{

        Id = "party_001"

        Name = "Standard Party"

        MaxMembers = 5

        LeaderRequired = $true

        SharedExperience = $true

        SharedLoot = $false

        FriendlyFire = $false

        AutoDisbandOnEmpty = $true

    },

    [PSCustomObject]@{

        Id = "party_002"

        Name = "Raid Group"

        MaxMembers = 20

        LeaderRequired = $true

        SharedExperience = $true

        SharedLoot = $true

        FriendlyFire = $false

        AutoDisbandOnEmpty = $true

    },

    [PSCustomObject]@{

        Id = "party_003"

        Name = "Arena Team"

        MaxMembers = 3

        LeaderRequired = $true

        SharedExperience = $false

        SharedLoot = $false

        FriendlyFire = $false

        AutoDisbandOnEmpty = $true

    },

    [PSCustomObject]@{

        Id = "party_004"

        Name = "Expedition"

        MaxMembers = 10

        LeaderRequired = $true

        SharedExperience = $true

        SharedLoot = $true

        FriendlyFire = $false

        AutoDisbandOnEmpty = $true

    }

)

$Party |
ConvertTo-Json -Depth 20 |
Set-Content $PartyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_062 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_062_BUILD_PARTY_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$PartyFile = "$Root\Data\Systems\Party\NSM_PARTY_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_PARTY_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_PARTY_VALIDATION_V1.json"

$Party = Get-Content $PartyFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $PartyFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_062"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    PartyCount = @($Party.Parties).Count

    File = $PartyFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_062"

    Status = "SUCCESS"

    PartyFile = (Test-Path $PartyFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_062 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_062_BUILD_PARTY_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$PartyFile = "$Root\Data\Systems\Party\NSM_PARTY_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_PARTY_SCHEMA_$Time.json"

Copy-Item $PartyFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $PartyFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_062"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $PartyFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_062_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_062
STATUS  : SUCCESS

FILE
----
$PartyFile

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
Set-Content "$ReportDir\CMD_062_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_062 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

