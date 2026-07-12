# ================================================================================
# NASRIUM PROJECT
# CMD_063_BUILD_FRIEND_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Friend System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$FriendDir = "$Root\Data\Systems\Friends"

if (!(Test-Path $FriendDir)) {
    New-Item -ItemType Directory -Path $FriendDir -Force | Out-Null
}

$FriendFile = "$FriendDir\NSM_FRIEND_SYSTEM_SCHEMA_V1.json"

$FriendSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_063"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    FriendProfiles = @()

}

$FriendSystem |
ConvertTo-Json -Depth 20 |
Set-Content $FriendFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_063 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_063_BUILD_FRIEND_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Friend System Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FriendFile = "$Root\Data\Systems\Friends\NSM_FRIEND_SYSTEM_SCHEMA_V1.json"

$FriendSystem = Get-Content $FriendFile -Raw | ConvertFrom-Json

$FriendSystem.FriendProfiles = @(

    [PSCustomObject]@{

        Id = "friend_profile_001"

        Name = "Default"

        MaxFriends = 100

        AllowFriendRequests = $true

        AllowPrivateMessages = $true

        ShowOnlineStatus = $true

        AllowPartyInvites = $true

        AllowGuildInvites = $true

    },

    [PSCustomObject]@{

        Id = "friend_profile_002"

        Name = "Private"

        MaxFriends = 50

        AllowFriendRequests = $false

        AllowPrivateMessages = $false

        ShowOnlineStatus = $false

        AllowPartyInvites = $false

        AllowGuildInvites = $false

    },

    [PSCustomObject]@{

        Id = "friend_profile_003"

        Name = "Friends Only"

        MaxFriends = 150

        AllowFriendRequests = $true

        AllowPrivateMessages = $true

        ShowOnlineStatus = $true

        AllowPartyInvites = $true

        AllowGuildInvites = $false

    },

    [PSCustomObject]@{

        Id = "friend_profile_004"

        Name = "Streamer"

        MaxFriends = 500

        AllowFriendRequests = $false

        AllowPrivateMessages = $false

        ShowOnlineStatus = $true

        AllowPartyInvites = $false

        AllowGuildInvites = $false

    }

)

$FriendSystem |
ConvertTo-Json -Depth 20 |
Set-Content $FriendFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_063 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_063_BUILD_FRIEND_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FriendFile = "$Root\Data\Systems\Friends\NSM_FRIEND_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_FRIEND_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_FRIEND_SYSTEM_VALIDATION_V1.json"

$FriendSystem = Get-Content $FriendFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $FriendFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_063"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    ProfileCount = @($FriendSystem.FriendProfiles).Count

    File = $FriendFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_063"

    Status = "SUCCESS"

    FriendFile = (Test-Path $FriendFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_063 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_063_BUILD_FRIEND_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$FriendFile = "$Root\Data\Systems\Friends\NSM_FRIEND_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_FRIEND_SYSTEM_SCHEMA_$Time.json"

Copy-Item $FriendFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $FriendFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_063"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $FriendFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_063_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_063
STATUS  : SUCCESS

FILE
----
$FriendFile

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
Set-Content "$ReportDir\CMD_063_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_063 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

