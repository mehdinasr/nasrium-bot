# ================================================================================
# NASRIUM PROJECT
# CMD_040_BUILD_GLOBAL_CONFIG
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ConfigDir="$Root\Data\Config"

if(!(Test-Path $ConfigDir)){
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

$ConfigFile="$ConfigDir\NSM_GLOBAL_CONFIG_V1.json"

$Config=[ordered]@{

Metadata=[ordered]@{

Module="CMD_040"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

GlobalConfig=[ordered]@{

GameName="NASRIUM"

Version="1.0.0"

Build="ALPHA"

Language="en-US"

TimeZone="UTC"

MaxPlayerLevel=100

MaxHeroLevel=100

MaxEquipmentLevel=20

MaxInventorySlots=500

AutoSaveInterval=300

EnableLogs=$true

EnableBackups=$true

EnableAnalytics=$false

}

}

$Config |
ConvertTo-Json -Depth 20 |
Set-Content $ConfigFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_040 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_040_BUILD_GLOBAL_CONFIG
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ConfigFile="$Root\Data\Config\NSM_GLOBAL_CONFIG_V1.json"

$Config=Get-Content $ConfigFile -Raw | ConvertFrom-Json

$Config.GlobalConfig | Add-Member -NotePropertyName SaveCompression -NotePropertyValue "GZip" -Force
$Config.GlobalConfig | Add-Member -NotePropertyName Encryption -NotePropertyValue "AES256" -Force
$Config.GlobalConfig | Add-Member -NotePropertyName HashAlgorithm -NotePropertyValue "SHA256" -Force
$Config.GlobalConfig | Add-Member -NotePropertyName BackupRetentionDays -NotePropertyValue 30 -Force
$Config.GlobalConfig | Add-Member -NotePropertyName MaxSaveSlots -NotePropertyValue 10 -Force
$Config.GlobalConfig | Add-Member -NotePropertyName ServerTickRate -NotePropertyValue 30 -Force
$Config.GlobalConfig | Add-Member -NotePropertyName AutoSaveEnabled -NotePropertyValue $true -Force
$Config.GlobalConfig | Add-Member -NotePropertyName CloudSyncEnabled -NotePropertyValue $false -Force
$Config.GlobalConfig | Add-Member -NotePropertyName DebugMode -NotePropertyValue $false -Force
$Config.GlobalConfig | Add-Member -NotePropertyName ReleaseChannel -NotePropertyValue "Alpha" -Force

$Config |
ConvertTo-Json -Depth 20 |
Set-Content $ConfigFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_040 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_040_BUILD_GLOBAL_CONFIG
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ConfigFile="$Root\Data\Config\NSM_GLOBAL_CONFIG_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_GLOBAL_CONFIG_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_GLOBAL_CONFIG_VALIDATION_V1.json"

$Config=Get-Content $ConfigFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $ConfigFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_040"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Configuration="Global"

File=$ConfigFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_040"

Status="SUCCESS"

ConfigFile=(Test-Path $ConfigFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_040 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_040_BUILD_GLOBAL_CONFIG
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ConfigFile="$Root\Data\Config\NSM_GLOBAL_CONFIG_V1.json"

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

$BackupFile="$BackupDir\NSM_GLOBAL_CONFIG_$Time.json"

Copy-Item $ConfigFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_040"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ConfigFile

Backup=$BackupFile

SHA256=(Get-FileHash $ConfigFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_040_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_040
STATUS  : SUCCESS

FILE
----
$ConfigFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ConfigFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_040_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_040 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

