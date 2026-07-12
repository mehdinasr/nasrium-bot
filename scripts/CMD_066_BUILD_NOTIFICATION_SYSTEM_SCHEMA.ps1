# ================================================================================
# NASRIUM PROJECT
# CMD_066_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Notification System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$NotificationDir = "$Root\Data\Systems\Notifications"

if (!(Test-Path $NotificationDir)) {
    New-Item -ItemType Directory -Path $NotificationDir -Force | Out-Null
}

$NotificationFile = "$NotificationDir\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$NotificationSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_066"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    NotificationProfiles = @()

}

$NotificationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NotificationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_066 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_066_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Notification System Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NotificationFile = "$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$NotificationSystem = Get-Content $NotificationFile -Raw | ConvertFrom-Json

$NotificationSystem.NotificationProfiles = @(

    [PSCustomObject]@{

        Id = "notification_profile_001"

        Name = "Default"

        EnableSystemNotifications = $true

        EnableQuestNotifications = $true

        EnableCombatNotifications = $true

        EnableGuildNotifications = $true

        EnableFriendNotifications = $true

        EnableMailNotifications = $true

    },

    [PSCustomObject]@{

        Id = "notification_profile_002"

        Name = "Minimal"

        EnableSystemNotifications = $true

        EnableQuestNotifications = $false

        EnableCombatNotifications = $false

        EnableGuildNotifications = $false

        EnableFriendNotifications = $false

        EnableMailNotifications = $true

    },

    [PSCustomObject]@{

        Id = "notification_profile_003"

        Name = "Combat Focus"

        EnableSystemNotifications = $true

        EnableQuestNotifications = $false

        EnableCombatNotifications = $true

        EnableGuildNotifications = $false

        EnableFriendNotifications = $false

        EnableMailNotifications = $false

    },

    [PSCustomObject]@{

        Id = "notification_profile_004"

        Name = "Social"

        EnableSystemNotifications = $true

        EnableQuestNotifications = $false

        EnableCombatNotifications = $false

        EnableGuildNotifications = $true

        EnableFriendNotifications = $true

        EnableMailNotifications = $true

    }

)

$NotificationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NotificationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_066 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_066_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NotificationFile = "$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_NOTIFICATION_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_NOTIFICATION_SYSTEM_VALIDATION_V1.json"

$NotificationSystem = Get-Content $NotificationFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $NotificationFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_066"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    ProfileCount = @($NotificationSystem.NotificationProfiles).Count

    File = $NotificationFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_066"

    Status = "SUCCESS"

    NotificationFile = (Test-Path $NotificationFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_066 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_066_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$NotificationFile = "$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_NOTIFICATION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $NotificationFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $NotificationFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_066"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $NotificationFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_066_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_066
STATUS  : SUCCESS

FILE
----
$NotificationFile

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
Set-Content "$ReportDir\CMD_066_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_066 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

