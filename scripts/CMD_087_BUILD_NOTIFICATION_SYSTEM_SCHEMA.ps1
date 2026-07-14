# ================================================================================
# NASRIUM PROJECT
# CMD_087_BUILD_NOTIFICATION_SYSTEM_SCHEMA
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

        Module    = "CMD_087"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Notifications = @()

}

$NotificationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NotificationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_087 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_087_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Notification System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$NotificationFile="$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$NotificationSystem=Get-Content $NotificationFile -Raw | ConvertFrom-Json

$NotificationSystem.Notifications=@(

    [PSCustomObject]@{

        Id="notification_001"

        Type="System"

        Title="Welcome"

        Message="Welcome to NASRIUM."

        Priority="Low"

        AutoExpireHours=168

        Icon="system"

        Active=$true

    },

    [PSCustomObject]@{

        Id="notification_002"

        Type="Construction"

        Title="Building Completed"

        Message="One of your buildings has been completed."

        Priority="Normal"

        AutoExpireHours=72

        Icon="building"

        Active=$true

    },

    [PSCustomObject]@{

        Id="notification_003"

        Type="Research"

        Title="Research Completed"

        Message="Research has finished successfully."

        Priority="Normal"

        AutoExpireHours=72

        Icon="research"

        Active=$true

    },

    [PSCustomObject]@{

        Id="notification_004"

        Type="Battle"

        Title="Battle Report"

        Message="A new battle report is available."

        Priority="High"

        AutoExpireHours=240

        Icon="battle"

        Active=$true

    },

    [PSCustomObject]@{

        Id="notification_005"

        Type="Alliance"

        Title="Alliance Message"

        Message="Your alliance has a new announcement."

        Priority="High"

        AutoExpireHours=168

        Icon="alliance"

        Active=$true

    }

)

$NotificationSystem |
ConvertTo-Json -Depth 20 |
Set-Content $NotificationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_087 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_087_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$NotificationFile="$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_NOTIFICATION_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_NOTIFICATION_VALIDATION_V1.json"

$Notification=Get-Content $NotificationFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $NotificationFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_087"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    NotificationCount=@($Notification.Notifications).Count

    File=$NotificationFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_087"

    Status="SUCCESS"

    SchemaExists=(Test-Path $NotificationFile)

    MetadataExists=(Test-Path $MetadataFile)

    NotificationCount=@($Notification.Notifications).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_087 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_087_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$NotificationFile="$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_NOTIFICATION_SYSTEM_SCHEMA_$Time.json"

Copy-Item $NotificationFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_087"

    Module="NOTIFICATION_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$NotificationFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $NotificationFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_087_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_087_BUILD_NOTIFICATION_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$NotificationFile="$Root\Data\Systems\Notifications\NSM_NOTIFICATION_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_087_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_087_HISTORY_","")

$BackupFile="$BackupDir\NSM_NOTIFICATION_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $NotificationFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_087
MODULE  : NOTIFICATION SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$NotificationFile

BACKUP
------
$BackupFile

SHA256
------
$Hash

DATE
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==========================================================

"@

$Report |
Set-Content "$ReportDir\CMD_087_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_087 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

