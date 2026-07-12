# ================================================================================
# NASRIUM PROJECT
# CMD_032_BUILD_BUFF_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$BuffDir="$Root\Data\Balance\Buffs"

if(!(Test-Path $BuffDir)){
    New-Item -ItemType Directory -Path $BuffDir -Force | Out-Null
}

$BuffFile="$BuffDir\NSM_BUFF_SCHEMA_V1.json"

$Buff=[ordered]@{

Metadata=[ordered]@{

Module="CMD_032"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Buffs=@()

}

$Buff |
ConvertTo-Json -Depth 20 |
Set-Content $BuffFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_032 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_032_BUILD_BUFF_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuffFile="$Root\Data\Balance\Buffs\NSM_BUFF_SCHEMA_V1.json"

$Buff=Get-Content $BuffFile -Raw | ConvertFrom-Json

$Buff.Buffs=@(

    [PSCustomObject]@{

        Id="buff_001"

        Name="Attack Boost"

        Category="Buff"

        Target="Self"

        Duration=30

        Stackable=$true

        MaxStacks=5

        EffectType="AttackPercent"

        EffectValue=10

        Icon="buff_attack"

        Description="Increase attack power by 10%."

    },

    [PSCustomObject]@{

        Id="buff_002"

        Name="Defense Aura"

        Category="Buff"

        Target="Ally"

        Duration=45

        Stackable=$false

        MaxStacks=1

        EffectType="DefensePercent"

        EffectValue=15

        Icon="buff_defense"

        Description="Increase defense by 15%."

    },

    [PSCustomObject]@{

        Id="buff_003"

        Name="Poison"

        Category="Debuff"

        Target="Enemy"

        Duration=20

        Stackable=$true

        MaxStacks=3

        EffectType="DamageOverTime"

        EffectValue=25

        Icon="debuff_poison"

        Description="Deals poison damage over time."

    },

    [PSCustomObject]@{

        Id="buff_004"

        Name="Stun"

        Category="Debuff"

        Target="Enemy"

        Duration=3

        Stackable=$false

        MaxStacks=1

        EffectType="Disable"

        EffectValue=100

        Icon="debuff_stun"

        Description="Disables target actions."

    }

)

$Buff |
ConvertTo-Json -Depth 20 |
Set-Content $BuffFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_032 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_032_BUILD_BUFF_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuffFile="$Root\Data\Balance\Buffs\NSM_BUFF_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_BUFF_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_BUFF_VALIDATION_V1.json"

$Buff=Get-Content $BuffFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $BuffFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_032"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

BuffCount=@($Buff.Buffs).Count

File=$BuffFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_032"

Status="SUCCESS"

BuffFile=(Test-Path $BuffFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_032 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_032_BUILD_BUFF_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuffFile="$Root\Data\Balance\Buffs\NSM_BUFF_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_BUFF_SCHEMA_$Time.json"

Copy-Item $BuffFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_032"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$BuffFile

Backup=$BackupFile

SHA256=(Get-FileHash $BuffFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_032_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_032
STATUS  : SUCCESS

FILE
----
$BuffFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $BuffFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_032_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_032 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

