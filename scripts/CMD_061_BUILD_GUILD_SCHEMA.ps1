# ================================================================================
# NASRIUM PROJECT
# CMD_061_BUILD_GUILD_SCHEMA
# STEP 001
# ================================================================================
#
# Create Guild Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$GuildDir = "$Root\Data\Systems\Guilds"

if (!(Test-Path $GuildDir)) {
    New-Item -ItemType Directory -Path $GuildDir -Force | Out-Null
}

$GuildFile = "$GuildDir\NSM_GUILD_SCHEMA_V1.json"

$Guild = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_061"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Guilds = @()

}

$Guild |
ConvertTo-Json -Depth 20 |
Set-Content $GuildFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_061 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_061_BUILD_GUILD_SCHEMA
# STEP 002
# ================================================================================
#
# Guild Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$GuildFile = "$Root\Data\Systems\Guilds\NSM_GUILD_SCHEMA_V1.json"

$Guild = Get-Content $GuildFile -Raw | ConvertFrom-Json

$Guild.Guilds = @(

    [PSCustomObject]@{

        Id = "guild_001"

        Name = "Warriors"

        MaxMembers = 100

        MaxLevel = 20

        StartingLevel = 1

        DailyContributionLimit = 1000

        StorageSlots = 100

        FriendlyFire = $false

    },

    [PSCustomObject]@{

        Id = "guild_002"

        Name = "Mages"

        MaxMembers = 80

        MaxLevel = 20

        StartingLevel = 1

        DailyContributionLimit = 1000

        StorageSlots = 120

        FriendlyFire = $false

    },

    [PSCustomObject]@{

        Id = "guild_003"

        Name = "Hunters"

        MaxMembers = 60

        MaxLevel = 20

        StartingLevel = 1

        DailyContributionLimit = 1000

        StorageSlots = 80

        FriendlyFire = $false

    },

    [PSCustomObject]@{

        Id = "guild_004"

        Name = "Merchants"

        MaxMembers = 50

        MaxLevel = 20

        StartingLevel = 1

        DailyContributionLimit = 1500

        StorageSlots = 150

        FriendlyFire = $false

    }

)

$Guild |
ConvertTo-Json -Depth 20 |
Set-Content $GuildFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_061 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_061_BUILD_GUILD_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$GuildFile = "$Root\Data\Systems\Guilds\NSM_GUILD_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_GUILD_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_GUILD_VALIDATION_V1.json"

$Guild = Get-Content $GuildFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $GuildFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_061"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    GuildCount = @($Guild.Guilds).Count

    File = $GuildFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_061"

    Status = "SUCCESS"

    GuildFile = (Test-Path $GuildFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_061 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_061_BUILD_GUILD_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$GuildFile = "$Root\Data\Systems\Guilds\NSM_GUILD_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_GUILD_SCHEMA_$Time.json"

Copy-Item $GuildFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $GuildFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_061"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $GuildFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_061_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_061
STATUS  : SUCCESS

FILE
----
$GuildFile

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
Set-Content "$ReportDir\CMD_061_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_061 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

# ================================================================================
# NASRIUM PROJECT
# CMD_061_BUILD_GUILD_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$GuildFile = "$Root\Data\Systems\Guilds\NSM_GUILD_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_GUILD_SCHEMA_$Time.json"

Copy-Item $GuildFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $GuildFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_061"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $GuildFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_061_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_061
STATUS  : SUCCESS

FILE
----
$GuildFile

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
Set-Content "$ReportDir\CMD_061_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_061 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

