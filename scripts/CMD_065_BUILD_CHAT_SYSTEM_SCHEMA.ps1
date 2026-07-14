# ================================================================================
# NASRIUM PROJECT
# CMD_065_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Chat System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$ChatDir = "$Root\Data\Systems\Chat"

if (!(Test-Path $ChatDir)) {
    New-Item -ItemType Directory -Path $ChatDir -Force | Out-Null
}

$ChatFile = "$ChatDir\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

$ChatSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_065"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    ChatProfiles = @()

}

$ChatSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ChatFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_065 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_065_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Chat System Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ChatFile = "$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

$ChatSystem = Get-Content $ChatFile -Raw | ConvertFrom-Json

$ChatSystem.ChatProfiles = @(

    [PSCustomObject]@{

        Id = "chat_profile_001"

        Name = "Global"

        Channel = "Global"

        MaxMessageLength = 256

        CooldownSeconds = 3

        AllowLinks = $false

        AllowPrivateMessages = $true

        Moderated = $true

    },

    [PSCustomObject]@{

        Id = "chat_profile_002"

        Name = "Guild"

        Channel = "Guild"

        MaxMessageLength = 512

        CooldownSeconds = 1

        AllowLinks = $true

        AllowPrivateMessages = $true

        Moderated = $true

    },

    [PSCustomObject]@{

        Id = "chat_profile_003"

        Name = "Party"

        Channel = "Party"

        MaxMessageLength = 512

        CooldownSeconds = 0

        AllowLinks = $true

        AllowPrivateMessages = $true

        Moderated = $false

    },

    [PSCustomObject]@{

        Id = "chat_profile_004"

        Name = "Administrator"

        Channel = "Admin"

        MaxMessageLength = 2048

        CooldownSeconds = 0

        AllowLinks = $true

        AllowPrivateMessages = $true

        Moderated = $false

    }

)

$ChatSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ChatFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_065 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_065_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ChatFile = "$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_CHAT_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_CHAT_SYSTEM_VALIDATION_V1.json"

$ChatSystem = Get-Content $ChatFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $ChatFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_065"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    ProfileCount = @($ChatSystem.ChatProfiles).Count

    File = $ChatFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_065"

    Status = "SUCCESS"

    ChatFile = (Test-Path $ChatFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_065 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_065_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$ChatFile = "$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_CHAT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $ChatFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $ChatFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_065"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $ChatFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_065_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_065
STATUS  : SUCCESS

FILE
----
$ChatFile

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
Set-Content "$ReportDir\CMD_065_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_065 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

