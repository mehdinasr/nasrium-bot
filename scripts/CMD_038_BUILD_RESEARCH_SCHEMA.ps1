# ================================================================================
# NASRIUM PROJECT
# CMD_038_BUILD_RESEARCH_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ResearchDir="$Root\Data\Balance\Research"

if(!(Test-Path $ResearchDir)){
    New-Item -ItemType Directory -Path $ResearchDir -Force | Out-Null
}

$ResearchFile="$ResearchDir\NSM_RESEARCH_SCHEMA_V1.json"

$Research=[ordered]@{

Metadata=[ordered]@{

Module="CMD_038"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Research=@()

}

$Research |
ConvertTo-Json -Depth 20 |
Set-Content $ResearchFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_038 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_038_BUILD_RESEARCH_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResearchFile="$Root\Data\Balance\Research\NSM_RESEARCH_SCHEMA_V1.json"

$Research=Get-Content $ResearchFile -Raw | ConvertFrom-Json

$Research.Research=@(

    [PSCustomObject]@{

        Id="research_001"

        Name="Weapon Mastery I"

        Category="Military"

        Level=1

        ResearchTime=300

        CostGold=1000

        CostResource="resource_002"

        CostAmount=100

        Prerequisite=""

        BonusType="AttackPercent"

        BonusValue=5

    },

    [PSCustomObject]@{

        Id="research_002"

        Name="Armor Engineering I"

        Category="Military"

        Level=1

        ResearchTime=450

        CostGold=1200

        CostResource="resource_002"

        CostAmount=120

        Prerequisite="research_001"

        BonusType="DefensePercent"

        BonusValue=5

    },

    [PSCustomObject]@{

        Id="research_003"

        Name="Resource Production I"

        Category="Economy"

        Level=1

        ResearchTime=600

        CostGold=1500

        CostResource="resource_001"

        CostAmount=500

        Prerequisite=""

        BonusType="ProductionPercent"

        BonusValue=10

    },

    [PSCustomObject]@{

        Id="research_004"

        Name="Advanced Logistics"

        Category="Support"

        Level=1

        ResearchTime=900

        CostGold=2500

        CostResource="resource_003"

        CostAmount=50

        Prerequisite="research_003"

        BonusType="CapacityPercent"

        BonusValue=15

    }

)

$Research |
ConvertTo-Json -Depth 20 |
Set-Content $ResearchFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_038 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_038_BUILD_RESEARCH_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResearchFile="$Root\Data\Balance\Research\NSM_RESEARCH_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_RESEARCH_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_RESEARCH_VALIDATION_V1.json"

$Research=Get-Content $ResearchFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $ResearchFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_038"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

ResearchCount=@($Research.Research).Count

File=$ResearchFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_038"

Status="SUCCESS"

ResearchFile=(Test-Path $ResearchFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_038 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_038_BUILD_RESEARCH_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$ResearchFile="$Root\Data\Balance\Research\NSM_RESEARCH_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_RESEARCH_SCHEMA_$Time.json"

Copy-Item $ResearchFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_038"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ResearchFile

Backup=$BackupFile

SHA256=(Get-FileHash $ResearchFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_038_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_038
STATUS  : SUCCESS

FILE
----
$ResearchFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $ResearchFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_038_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_038 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

