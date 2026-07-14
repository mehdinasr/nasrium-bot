# ================================================================================
# NASRIUM PROJECT
# CMD_064_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Mail System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$MailDir = "$Root\Data\Systems\Mail"

if (!(Test-Path $MailDir)) {
    New-Item -ItemType Directory -Path $MailDir -Force | Out-Null
}

$MailFile = "$MailDir\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$MailSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_064"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    MailProfiles = @()

}

$MailSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_064 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_064_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Mail System Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$MailFile = "$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$MailSystem = Get-Content $MailFile -Raw | ConvertFrom-Json

$MailSystem.MailProfiles = @(

    [PSCustomObject]@{

        Id = "mail_profile_001"

        Name = "Standard"

        MaxInboxMessages = 100

        MaxAttachments = 5

        AttachmentSizeLimitMB = 25

        MailRetentionDays = 30

        AllowPlayerMail = $true

        AllowSystemMail = $true

    },

    [PSCustomObject]@{

        Id = "mail_profile_002"

        Name = "Premium"

        MaxInboxMessages = 500

        MaxAttachments = 10

        AttachmentSizeLimitMB = 50

        MailRetentionDays = 90

        AllowPlayerMail = $true

        AllowSystemMail = $true

    },

    [PSCustomObject]@{

        Id = "mail_profile_003"

        Name = "Restricted"

        MaxInboxMessages = 50

        MaxAttachments = 2

        AttachmentSizeLimitMB = 10

        MailRetentionDays = 15

        AllowPlayerMail = $false

        AllowSystemMail = $true

    },

    [PSCustomObject]@{

        Id = "mail_profile_004"

        Name = "Administrator"

        MaxInboxMessages = 1000

        MaxAttachments = 20

        AttachmentSizeLimitMB = 100

        MailRetentionDays = 365

        AllowPlayerMail = $true

        AllowSystemMail = $true

    }

)

$MailSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_064 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_064_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$MailFile = "$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_MAIL_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_MAIL_SYSTEM_VALIDATION_V1.json"

$MailSystem = Get-Content $MailFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $MailFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_064"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    ProfileCount = @($MailSystem.MailProfiles).Count

    File = $MailFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_064"

    Status = "SUCCESS"

    MailFile = (Test-Path $MailFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_064 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_064_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$MailFile = "$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_MAIL_SYSTEM_SCHEMA_$Time.json"

Copy-Item $MailFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $MailFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_064"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $MailFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_064_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_064
STATUS  : SUCCESS

FILE
----
$MailFile

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
Set-Content "$ReportDir\CMD_064_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_064 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

