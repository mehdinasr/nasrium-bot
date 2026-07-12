# ================================================================================
# NASRIUM PROJECT
# CMD_091_BUILD_CHAT_MODERATION_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModerationFile="$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"


$Moderation=Get-Content $ModerationFile -Raw | ConvertFrom-Json


$Settings=[ordered]@{

Enabled=$true

AutoFilter=$true

LogViolations=$true

WarningLimit=3

BanAfterLimit=$false

}


$Moderation.Settings=$Settings


$Moderation |
ConvertTo-Json -Depth 20 |
Set-Content $ModerationFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_091 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_091_BUILD_CHAT_MODERATION_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModerationFile="$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"


$Moderation=Get-Content $ModerationFile -Raw | ConvertFrom-Json


$Rules=@(

    [PSCustomObject]@{

        Id="rule_001"

        Name="BadWordFilter"

        Type="Text"

        Enabled=$true

        Action="Warning"

    },

    [PSCustomObject]@{

        Id="rule_002"

        Name="SpamProtection"

        Type="Frequency"

        Enabled=$true

        Action="Limit"

    }

)


$Moderation.Rules=$Rules


$Moderation |
ConvertTo-Json -Depth 20 |
Set-Content $ModerationFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_091 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_091_BUILD_CHAT_MODERATION_SCHEMA
# STEP 004
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModerationFile="$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"


$Moderation=Get-Content $ModerationFile -Raw | ConvertFrom-Json


$Hash=(Get-FileHash $ModerationFile -Algorithm SHA256).Hash


$Metadata=[ordered]@{

Module="CMD_091"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

RuleCount=@($Moderation.Rules).Count

File=$ModerationFile

SHA256=$Hash

}


$MetadataDir="$Root\Data\Metadata"


if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}


$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content "$MetadataDir\NSM_CHAT_MODERATION_METADATA_V1.json" -Encoding UTF8


Write-Host ""
Write-Host "CMD_091 STEP-004 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_091_BUILD_CHAT_MODERATION_SCHEMA
# STEP 005
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModerationFile="$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"

$ValidationDir="$Root\Data\Metadata"

$ValidationFile="$ValidationDir\NSM_CHAT_MODERATION_VALIDATION_V1.json"


$Hash=(Get-FileHash $ModerationFile -Algorithm SHA256).Hash


$Validation=[ordered]@{

Module="CMD_091"

Status="SUCCESS"

ModerationFile=(Test-Path $ModerationFile)

MetadataFolder=(Test-Path $ValidationDir)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_091 STEP-005 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_091_BUILD_CHAT_MODERATION_SCHEMA
# STEP 006
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModerationFile="$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"

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


$BackupFile="$BackupDir\NSM_CHAT_MODERATION_SCHEMA_$Time.json"


Copy-Item $ModerationFile $BackupFile -Force


$History=[ordered]@{

Command="CMD_091"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ModerationFile

Backup=$BackupFile

SHA256=(Get-FileHash $ModerationFile -Algorithm SHA256).Hash

}


$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_091_HISTORY_$Time.json" -Encoding UTF8


$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_091
STATUS  : SUCCESS

FILE
----
$ModerationFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ModerationFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_091_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_091 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

