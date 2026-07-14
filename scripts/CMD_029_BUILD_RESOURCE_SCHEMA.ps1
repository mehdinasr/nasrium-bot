# ================================================================================
# NASRIUM PROJECT
# CMD_029_BUILD_RESOURCE_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ResourceDir="$Root\Data\Balance\Resources"

if(!(Test-Path $ResourceDir)){
    New-Item -ItemType Directory -Path $ResourceDir -Force | Out-Null
}

$ResourceFile="$ResourceDir\NSM_RESOURCE_SCHEMA_V1.json"

$Resource=[ordered]@{

Metadata=[ordered]@{

Module="CMD_029"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Resources=@()

}

$Resource |
ConvertTo-Json -Depth 20 |
Set-Content $ResourceFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_029 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_029_BUILD_RESOURCE_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResourceFile="$Root\Data\Balance\Resources\NSM_RESOURCE_SCHEMA_V1.json"

$Resource=Get-Content $ResourceFile -Raw | ConvertFrom-Json

$Resource.Resources=@(

    [PSCustomObject]@{

        Id="resource_001"

        Name="Gold"

        Category="Currency"

        MaxStorage=999999999

        DefaultValue=0

        Premium=$false

        Tradable=$true

        Description="Primary economic resource."

    },

    [PSCustomObject]@{

        Id="resource_002"

        Name="Elixir"

        Category="Currency"

        MaxStorage=999999999

        DefaultValue=0

        Premium=$false

        Tradable=$true

        Description="Research and upgrade resource."

    },

    [PSCustomObject]@{

        Id="resource_003"

        Name="Dark Crystal"

        Category="Rare"

        MaxStorage=99999999

        DefaultValue=0

        Premium=$false

        Tradable=$false

        Description="Rare strategic resource."

    },

    [PSCustomObject]@{

        Id="resource_004"

        Name="Gem"

        Category="Premium"

        MaxStorage=999999

        DefaultValue=0

        Premium=$true

        Tradable=$false

        Description="Premium currency."

    }

)

$Resource |
ConvertTo-Json -Depth 20 |
Set-Content $ResourceFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_029 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_029_BUILD_RESOURCE_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResourceFile="$Root\Data\Balance\Resources\NSM_RESOURCE_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_RESOURCE_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_RESOURCE_VALIDATION_V1.json"

$Resource=Get-Content $ResourceFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $ResourceFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_029"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

ResourceCount=@($Resource.Resources).Count

File=$ResourceFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_029"

Status="SUCCESS"

ResourceFile=(Test-Path $ResourceFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_029 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_029_BUILD_RESOURCE_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResourceFile="$Root\Data\Balance\Resources\NSM_RESOURCE_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_RESOURCE_SCHEMA_$Time.json"

Copy-Item $ResourceFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_029"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ResourceFile

Backup=$BackupFile

SHA256=(Get-FileHash $ResourceFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_029_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_029
STATUS  : SUCCESS

FILE
----
$ResourceFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ResourceFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_029_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_029 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

