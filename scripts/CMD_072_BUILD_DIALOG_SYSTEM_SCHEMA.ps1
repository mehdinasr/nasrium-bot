# ================================================================================
# NASRIUM PROJECT
# CMD_072_BUILD_DIALOG_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Dialog System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$DialogDir = "$Root\Data\Systems\Dialogs"

if (!(Test-Path $DialogDir)) {
    New-Item -ItemType Directory -Path $DialogDir -Force | Out-Null
}

$DialogFile = "$DialogDir\NSM_DIALOG_SYSTEM_SCHEMA_V1.json"

$DialogSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_072"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    DialogProfiles = @()

}

$DialogSystem |
ConvertTo-Json -Depth 20 |
Set-Content $DialogFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_072 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_072_BUILD_DIALOG_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Dialog Profile Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DialogFile = "$Root\Data\Systems\Dialogs\NSM_DIALOG_SYSTEM_SCHEMA_V1.json"

$DialogSystem = Get-Content $DialogFile -Raw | ConvertFrom-Json

$DialogSystem.DialogProfiles = @(

    [PSCustomObject]@{

        Id = "dialog_001"

        Name = "Greeting"

        Category = "General"

        AllowChoices = $false

        MaxResponses = 1

        Skippable = $true

        VoiceEnabled = $false

        AutoAdvance = $true

    },

    [PSCustomObject]@{

        Id = "dialog_002"

        Name = "Quest"

        Category = "Quest"

        AllowChoices = $true

        MaxResponses = 4

        Skippable = $true

        VoiceEnabled = $true

        AutoAdvance = $false

    },

    [PSCustomObject]@{

        Id = "dialog_003"

        Name = "Merchant"

        Category = "Shop"

        AllowChoices = $true

        MaxResponses = 8

        Skippable = $true

        VoiceEnabled = $false

        AutoAdvance = $false

    },

    [PSCustomObject]@{

        Id = "dialog_004"

        Name = "Cinematic"

        Category = "Story"

        AllowChoices = $false

        MaxResponses = 1

        Skippable = $false

        VoiceEnabled = $true

        AutoAdvance = $true

    }

)

$DialogSystem |
ConvertTo-Json -Depth 20 |
Set-Content $DialogFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_072 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_072_BUILD_DIALOG_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DialogFile = "$Root\Data\Systems\Dialogs\NSM_DIALOG_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_DIALOG_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_DIALOG_SYSTEM_VALIDATION_V1.json"

$DialogSystem = Get-Content $DialogFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $DialogFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_072"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    DialogProfileCount = @($DialogSystem.DialogProfiles).Count

    File = $DialogFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_072"

    Status = "SUCCESS"

    DialogFile = (Test-Path $DialogFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_072 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_072_BUILD_DIALOG_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DialogFile = "$Root\Data\Systems\Dialogs\NSM_DIALOG_SYSTEM_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_DIALOG_SYSTEM_SCHEMA_$Time.json"

Copy-Item $DialogFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $DialogFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_072"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $DialogFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_072_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_072
STATUS  : SUCCESS

FILE
----
$DialogFile

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
Set-Content "$ReportDir\CMD_072_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_072 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

