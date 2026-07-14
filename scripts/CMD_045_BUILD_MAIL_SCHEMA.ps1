# ================================================================================
# NASRIUM PROJECT
# CMD_045_BUILD_MAIL_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MailDir="$Root\Data\Systems\Mail"

if(!(Test-Path $MailDir)){
    New-Item -ItemType Directory -Path $MailDir -Force | Out-Null
}

$MailFile="$MailDir\NSM_MAIL_SCHEMA_V1.json"

$Mail=[ordered]@{

Metadata=[ordered]@{

Module="CMD_045"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Mail=@()

}

$Mail |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_045 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_045_BUILD_MAIL_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SCHEMA_V1.json"

$Mail=Get-Content $MailFile -Raw | ConvertFrom-Json

$Mail.Mail=@(

    [PSCustomObject]@{

        Id="mail_001"

        Category="System"

        Subject="Welcome to NASRIUM"

        ExpireDays=30

        HasAttachment=$true

        Attachment=[PSCustomObject]@{

            Gold=1000

            Gems=50

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="mail_002"

        Category="DailyReward"

        Subject="Daily Login Reward"

        ExpireDays=7

        HasAttachment=$true

        Attachment=[PSCustomObject]@{

            Gold=500

            Gems=5

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="mail_003"

        Category="Compensation"

        Subject="Maintenance Compensation"

        ExpireDays=14

        HasAttachment=$true

        Attachment=[PSCustomObject]@{

            Gold=5000

            Gems=100

            Items=@()

        }

    },

    [PSCustomObject]@{

        Id="mail_004"

        Category="Notification"

        Subject="Guild Invitation"

        ExpireDays=15

        HasAttachment=$false

        Attachment=$null

    }

)

$Mail |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_045 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_045_BUILD_MAIL_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_MAIL_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_MAIL_VALIDATION_V1.json"

$Mail=Get-Content $MailFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $MailFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_045"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

MailCount=@($Mail.Mail).Count

File=$MailFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_045"

Status="SUCCESS"

MailFile=(Test-Path $MailFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_045 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_045_BUILD_MAIL_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SCHEMA_V1.json"

$BackupDir="$Root\Backups"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

if(!(Test-Path $BackupDir)){
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

if(!(Test-Path $HistoryDir)){
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
}

if(!(Test-Path $ReportDir)){
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile="$BackupDir\NSM_MAIL_SCHEMA_$Time.json"

Copy-Item $MailFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_045"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$MailFile

Backup=$BackupFile

SHA256=(Get-FileHash $MailFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_045_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_045
STATUS  : SUCCESS

FILE
----
$MailFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $MailFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_045_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_045 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

