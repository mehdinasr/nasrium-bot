# ================================================================================
# NASRIUM PROJECT
# CMD_081_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Title System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$TitleDir = "$Root\Data\Systems\Titles"

if (!(Test-Path $TitleDir)) {
    New-Item -ItemType Directory -Path $TitleDir -Force | Out-Null
}

$TitleFile = "$TitleDir\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$TitleSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_081"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Titles = @()

}

$TitleSystem |
ConvertTo-Json -Depth 20 |
Set-Content $TitleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_081 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_081_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$TitleFile="$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$TitleSystem=Get-Content $TitleFile -Raw | ConvertFrom-Json

$TitleSystem.Titles=@(

    [PSCustomObject]@{

        Id="title_001"

        Name="Village Chief"

        Rank=1

        UnlockLevel=1

        Category="Leadership"

        Permanent=$true

        Bonuses=[ordered]@{

            GoldProductionPercent=2

            FoodProductionPercent=2

            TroopAttackPercent=0

            TroopDefensePercent=0

            BuilderSpeedPercent=0

        }

        Description="Beginning leadership title."

    },

    [PSCustomObject]@{

        Id="title_002"

        Name="Baron"

        Rank=2

        UnlockLevel=10

        Category="Leadership"

        Permanent=$true

        Bonuses=[ordered]@{

            GoldProductionPercent=5

            FoodProductionPercent=5

            TroopAttackPercent=2

            TroopDefensePercent=2

            BuilderSpeedPercent=3

        }

        Description="Regional ruler."

    },

    [PSCustomObject]@{

        Id="title_003"

        Name="Duke"

        Rank=3

        UnlockLevel=20

        Category="Military"

        Permanent=$true

        Bonuses=[ordered]@{

            GoldProductionPercent=8

            FoodProductionPercent=8

            TroopAttackPercent=5

            TroopDefensePercent=5

            BuilderSpeedPercent=5

        }

        Description="Military commander."

    },

    [PSCustomObject]@{

        Id="title_004"

        Name="King"

        Rank=4

        UnlockLevel=30

        Category="Royal"

        Permanent=$true

        Bonuses=[ordered]@{

            GoldProductionPercent=12

            FoodProductionPercent=12

            TroopAttackPercent=10

            TroopDefensePercent=10

            BuilderSpeedPercent=8

        }

        Description="Supreme ruler."

    }

)

$TitleSystem |
ConvertTo-Json -Depth 20 |
Set-Content $TitleFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_081 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_081_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata + Validation
#
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$TitleFile="$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_TITLE_METADATA_V1.json"
$ValidationFile="$MetadataDir\NSM_TITLE_VALIDATION_V1.json"

$TitleSystem=Get-Content $TitleFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $TitleFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

    Module="CMD_081"

    Version="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    TitleCount=@($TitleSystem.Titles).Count

    File=$TitleFile

    SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_081"

    Status="SUCCESS"

    SchemaExists=(Test-Path $TitleFile)

    MetadataExists=(Test-Path $MetadataFile)

    TitleCount=@($TitleSystem.Titles).Count

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_081 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_081_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 1
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$TitleFile="$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

foreach($Dir in @($BackupDir,$HistoryDir,$ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

$BackupFile="$BackupDir\NSM_TITLE_SYSTEM_SCHEMA_$Time.json"

Copy-Item $TitleFile $BackupFile -Force

$History=[ordered]@{

    Command="CMD_081"

    Module="TITLE_SYSTEM"

    Version="1.0.0"

    Status="SUCCESS"

    ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output=$TitleFile

    Backup=$BackupFile

    SHA256=(Get-FileHash $TitleFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_081_HISTORY_$Time.json" -Encoding UTF8

# ================================================================================
# NASRIUM PROJECT
# CMD_081_BUILD_TITLE_SYSTEM_SCHEMA
# STEP 004 (FINAL) - PART 2
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$TitleFile="$Root\Data\Systems\Titles\NSM_TITLE_SYSTEM_SCHEMA_V1.json"

$BackupDir="$Root\Backups"
$HistoryDir="$Root\Builder\History"
$ReportDir="$Root\Builder\Reports"

$Time=(Get-ChildItem "$HistoryDir\CMD_081_HISTORY_*.json" | Sort-Object LastWriteTime | Select-Object -Last 1).BaseName.Replace("CMD_081_HISTORY_","")

$BackupFile="$BackupDir\NSM_TITLE_SYSTEM_SCHEMA_$Time.json"

$Hash=(Get-FileHash $TitleFile -Algorithm SHA256).Hash

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

COMMAND : CMD_081
MODULE  : TITLE SYSTEM
VERSION : 1.0.0
STATUS  : SUCCESS

OUTPUT
------
$TitleFile

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
Set-Content "$ReportDir\CMD_081_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_081 BUILD COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Exit 0

