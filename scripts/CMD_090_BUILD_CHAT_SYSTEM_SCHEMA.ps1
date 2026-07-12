# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"


$ChatSystem=Get-Content $ChatFile -Raw | ConvertFrom-Json


$ChatSystem.Channels=@(

    [PSCustomObject]@{

        Id="chat_001"

        Name="Global"

        Scope="World"

        Moderated=$true

        MaxMessageLength=500

        Enabled=$true

    },

    [PSCustomObject]@{

        Id="chat_002"

        Name="Alliance"

        Scope="Alliance"

        Moderated=$true

        MaxMessageLength=1000

        Enabled=$true

    }

)


$ChatSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ChatFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_090 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"


$ChatSystem=Get-Content $ChatFile -Raw | ConvertFrom-Json


$Current=@($ChatSystem.Channels)


$Extra=@(

    [PSCustomObject]@{

        Id="chat_003"

        Name="Private"

        Scope="Player"

        Moderated=$false

        MaxMessageLength=1000

        Enabled=$true

    },

    [PSCustomObject]@{

        Id="chat_004"

        Name="Support"

        Scope="System"

        Moderated=$true

        MaxMessageLength=2000

        Enabled=$true

    }

)


$ChatSystem.Channels=@($Current + $Extra)


$ChatSystem |
ConvertTo-Json -Depth 20 |
Set-Content $ChatFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_090 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 004
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"


if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}


$MetadataFile="$MetadataDir\NSM_CHAT_SYSTEM_METADATA_V1.json"


$ChatSystem=Get-Content $ChatFile -Raw | ConvertFrom-Json


$Hash=(Get-FileHash $ChatFile -Algorithm SHA256).Hash


$Metadata=[ordered]@{

Module="CMD_090"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

ChannelCount=@($ChatSystem.Channels).Count

File=$ChatFile

SHA256=$Hash

}


$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_090 STEP-004 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 005
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

$ValidationDir="$Root\Data\Metadata"

$ValidationFile="$ValidationDir\NSM_CHAT_SYSTEM_VALIDATION_V1.json"


$Hash=(Get-FileHash $ChatFile -Algorithm SHA256).Hash


$Validation=[ordered]@{

Module="CMD_090"

Status="SUCCESS"

ChatFile=(Test-Path $ChatFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_090 STEP-005 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 006
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

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


$BackupFile="$BackupDir\NSM_CHAT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $ChatFile $BackupFile -Force


$History=[ordered]@{

Command="CMD_090"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ChatFile

Backup=$BackupFile

SHA256=(Get-FileHash $ChatFile -Algorithm SHA256).Hash

}


$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_090_HISTORY_$Time.json" -Encoding UTF8


$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_090
STATUS  : SUCCESS

FILE
----
$ChatFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ChatFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_090_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_090 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

# ================================================================================
# NASRIUM PROJECT
# CMD_090_BUILD_CHAT_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ChatFile="$Root\Data\Systems\Chat\NSM_CHAT_SYSTEM_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_CHAT_SYSTEM_SCHEMA_$Time.json"

Copy-Item $ChatFile $BackupFile -Force


#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_090"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ChatFile

Backup=$BackupFile

SHA256=(Get-FileHash $ChatFile -Algorithm SHA256).Hash

}


$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_090_HISTORY_$Time.json" -Encoding UTF8


#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_090
STATUS  : SUCCESS

FILE
----
$ChatFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ChatFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_090_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_090 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

