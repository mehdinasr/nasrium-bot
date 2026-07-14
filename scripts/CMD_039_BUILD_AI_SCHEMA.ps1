# ================================================================================
# NASRIUM PROJECT
# CMD_039_BUILD_AI_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$AIDir="$Root\Data\Balance\AI"

if(!(Test-Path $AIDir)){
    New-Item -ItemType Directory -Path $AIDir -Force | Out-Null
}

$AIFile="$AIDir\NSM_AI_SCHEMA_V1.json"

$AI=[ordered]@{

Metadata=[ordered]@{

Module="CMD_039"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

AIProfiles=@()

}

$AI |
ConvertTo-Json -Depth 20 |
Set-Content $AIFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_039 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_039_BUILD_AI_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AIFile="$Root\Data\Balance\AI\NSM_AI_SCHEMA_V1.json"

$AI=Get-Content $AIFile -Raw | ConvertFrom-Json

$AI.AIProfiles=@(

    [PSCustomObject]@{

        Id="ai_001"

        Name="Aggressive"

        Priority="NearestEnemy"

        AttackWeight=90

        DefenseWeight=20

        SkillUsage=80

        RetreatThreshold=10

        TargetSelection="LowestHP"

        Description="Always attacks the weakest enemy."

    },

    [PSCustomObject]@{

        Id="ai_002"

        Name="Balanced"

        Priority="OptimalTarget"

        AttackWeight=70

        DefenseWeight=60

        SkillUsage=65

        RetreatThreshold=20

        TargetSelection="Nearest"

        Description="Balanced offensive and defensive behavior."

    },

    [PSCustomObject]@{

        Id="ai_003"

        Name="Caster"

        Priority="Backline"

        AttackWeight=85

        DefenseWeight=30

        SkillUsage=100

        RetreatThreshold=15

        TargetSelection="HighestThreat"

        Description="Prioritizes skill casting."

    },

    [PSCustomObject]@{

        Id="ai_004"

        Name="Boss"

        Priority="AllTargets"

        AttackWeight=100

        DefenseWeight=100

        SkillUsage=100

        RetreatThreshold=0

        TargetSelection="Random"

        Description="Boss combat behavior."

    }

)

$AI |
ConvertTo-Json -Depth 20 |
Set-Content $AIFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_039 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_039_BUILD_AI_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AIFile="$Root\Data\Balance\AI\NSM_AI_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_AI_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_AI_VALIDATION_V1.json"

$AI=Get-Content $AIFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $AIFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_039"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

AIProfileCount=@($AI.AIProfiles).Count

File=$AIFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_039"

Status="SUCCESS"

AIFile=(Test-Path $AIFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_039 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_039_BUILD_AI_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$AIFile="$Root\Data\Balance\AI\NSM_AI_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_AI_SCHEMA_$Time.json"

Copy-Item $AIFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_039"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$AIFile

Backup=$BackupFile

SHA256=(Get-FileHash $AIFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_039_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_039
STATUS  : SUCCESS

FILE
----
$AIFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $AIFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_039_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_039 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

