# ================================================================================
# NASRIUM PROJECT
# CMD_035_BUILD_ECONOMY_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$EconomyDir="$Root\Data\Balance\Economy"

if(!(Test-Path $EconomyDir)){
    New-Item -ItemType Directory -Path $EconomyDir -Force | Out-Null
}

$EconomyFile="$EconomyDir\NSM_ECONOMY_SCHEMA_V1.json"

$Economy=[ordered]@{

Metadata=[ordered]@{

Module="CMD_035"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Economy=@()

}

$Economy |
ConvertTo-Json -Depth 20 |
Set-Content $EconomyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_035 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_035_BUILD_ECONOMY_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EconomyFile="$Root\Data\Balance\Economy\NSM_ECONOMY_SCHEMA_V1.json"

$Economy=Get-Content $EconomyFile -Raw | ConvertFrom-Json

$Economy.Economy=@(

    [PSCustomObject]@{

        Id="economy_001"

        Name="Gold"

        Category="SoftCurrency"

        StartingValue=1000

        MaxValue=999999999

        DailyLimit=100000

        Tradable=$true

        Description="Primary game currency."

    },

    [PSCustomObject]@{

        Id="economy_002"

        Name="Gem"

        Category="PremiumCurrency"

        StartingValue=100

        MaxValue=999999

        DailyLimit=999999

        Tradable=$false

        Description="Premium currency."

    },

    [PSCustomObject]@{

        Id="economy_003"

        Name="Energy"

        Category="Gameplay"

        StartingValue=100

        MaxValue=100

        DailyLimit=9999

        RegenerationPerMinute=1

        Tradable=$false

        Description="Required to enter stages."

    },

    [PSCustomObject]@{

        Id="economy_004"

        Name="ArenaToken"

        Category="PvP"

        StartingValue=10

        MaxValue=9999

        DailyLimit=500

        Tradable=$false

        Description="Arena participation currency."

    }

)

$Economy |
ConvertTo-Json -Depth 20 |
Set-Content $EconomyFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_035 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_035_BUILD_ECONOMY_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EconomyFile="$Root\Data\Balance\Economy\NSM_ECONOMY_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_ECONOMY_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_ECONOMY_VALIDATION_V1.json"

$Economy=Get-Content $EconomyFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $EconomyFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_035"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

EconomyCount=@($Economy.Economy).Count

File=$EconomyFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_035"

Status="SUCCESS"

EconomyFile=(Test-Path $EconomyFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_035 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_035_BUILD_ECONOMY_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$EconomyFile="$Root\Data\Balance\Economy\NSM_ECONOMY_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_ECONOMY_SCHEMA_$Time.json"

Copy-Item $EconomyFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_035"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$EconomyFile

Backup=$BackupFile

SHA256=(Get-FileHash $EconomyFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_035_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_035
STATUS  : SUCCESS

FILE
----
$EconomyFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $EconomyFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_035_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_035 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

