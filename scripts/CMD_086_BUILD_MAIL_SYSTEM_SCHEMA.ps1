# ================================================================================
# NASRIUM PROJECT
# CMD_086_BUILD_MAIL_SYSTEM_SCHEMA
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

        Module    = "CMD_086"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    MailTemplates = @()

}

$MailSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_086 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_086_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Populate Mail System
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$MailSystem=Get-Content $MailFile -Raw | ConvertFrom-Json

$MailSystem.MailTemplates=@(

    [PSCustomObject]@{

        Id="mail_001"

        Type="System"

        Subject="Welcome"

        Body="Welcome to NASRIUM."

        HasReward=$false

        ExpireDays=30

        Priority=1

    },

    [PSCustomObject]@{

        Id="mail_002"

        Type="Reward"

        Subject="Daily Reward"

        Body="Your daily reward is ready."

        HasReward=$true

        Reward=[ordered]@{

            Gold=1000

            Gems=10

            XP=100

        }

        ExpireDays=7

        Priority=2

    },

    [PSCustomObject]@{

        Id="mail_003"

        Type="Event"

        Subject="Season Event"

        Body="A new event has started."

        HasReward=$true

        Reward=[ordered]@{

            Gold=5000

            Gems=50

            XP=500

        }

        ExpireDays=14

        Priority=3

    }

)

$MailSystem |
ConvertTo-Json -Depth 20 |
Set-Content $MailFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_086 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_086_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_MAIL_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_MAIL_VALIDATION_V1.json"

$Mail=Get-Content $MailFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $MailFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_086"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    MailCount=@($Mail.MailTemplates).Count

    File=$MailFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_086"

    Status="SUCCESS"

    SchemaExists=(Test-Path $MailFile)

    MetadataExists=(Test-Path $MetadataFile)

    MailCount=@($Mail.MailTemplates).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_086 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_086_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================
#
# Backup + History
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_MAIL_SYSTEM_SCHEMA_$Time.json"

Copy-Item $MailFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_086"

    Module="MAIL_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$MailFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $MailFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_086_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_086_BUILD_MAIL_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================
#
# Report + Finish
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$MailFile="$Root\Data\Systems\Mail\NSM_MAIL_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_086_HISTORY_*.json" |
Sort-Object LastWriteTime |
Select-Object -Last 1).BaseName.Replace("CMD_086_HISTORY_","")

$BackupFile="$BackupDir\NSM_MAIL_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $MailFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_086
MODULE  : MAIL SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$MailFile

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
Set-Content "$ReportDir\CMD_086_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_086 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

