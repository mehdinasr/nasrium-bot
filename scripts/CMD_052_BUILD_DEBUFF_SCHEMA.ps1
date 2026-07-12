# ================================================================================
# NASRIUM PROJECT
# CMD_052_BUILD_DEBUFF_SCHEMA
# STEP 001
# ================================================================================
#
# Create Debuff Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$DebuffDir = "$Root\Data\Balance\Debuffs"

if (!(Test-Path $DebuffDir)) {
    New-Item -ItemType Directory -Path $DebuffDir -Force | Out-Null
}

$DebuffFile = "$DebuffDir\NSM_DEBUFF_SCHEMA_V1.json"

$Debuff = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_052"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Debuffs = @()

}

$Debuff |
ConvertTo-Json -Depth 20 |
Set-Content $DebuffFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_052 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_052_BUILD_DEBUFF_SCHEMA
# STEP 002
# ================================================================================
#
# Debuff Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DebuffFile = "$Root\Data\Balance\Debuffs\NSM_DEBUFF_SCHEMA_V1.json"

$Debuff = Get-Content $DebuffFile -Raw | ConvertFrom-Json

$Debuff.Debuffs = @(

    [PSCustomObject]@{

        Id = "debuff_001"

        Name = "Burn"

        Category = "DamageOverTime"

        TargetStat = "Health"

        ModifierType = "DamagePerSecond"

        Value = 35

        DurationSeconds = 10

        Stackable = $true

    },

    [PSCustomObject]@{

        Id = "debuff_002"

        Name = "Slow"

        Category = "Movement"

        TargetStat = "MoveSpeed"

        ModifierType = "Percent"

        Value = -40

        DurationSeconds = 8

        Stackable = $false

    },

    [PSCustomObject]@{

        Id = "debuff_003"

        Name = "Silence"

        Category = "Control"

        TargetStat = "SkillCast"

        ModifierType = "Disable"

        Value = 100

        DurationSeconds = 5

        Stackable = $false

    },

    [PSCustomObject]@{

        Id = "debuff_004"

        Name = "Armor Break"

        Category = "Defense"

        TargetStat = "Defense"

        ModifierType = "Percent"

        Value = -25

        DurationSeconds = 15

        Stackable = $true

    }

)

$Debuff |
ConvertTo-Json -Depth 20 |
Set-Content $DebuffFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_052 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_052_BUILD_DEBUFF_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DebuffFile = "$Root\Data\Balance\Debuffs\NSM_DEBUFF_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_DEBUFF_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_DEBUFF_VALIDATION_V1.json"

$Debuff = Get-Content $DebuffFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $DebuffFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_052"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    DebuffCount = @($Debuff.Debuffs).Count

    File = $DebuffFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_052"

    Status = "SUCCESS"

    DebuffFile = (Test-Path $DebuffFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_052 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_052_BUILD_DEBUFF_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$DebuffFile = "$Root\Data\Balance\Debuffs\NSM_DEBUFF_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

if (!(Test-Path $HistoryDir)) {
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
}

if (!(Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_DEBUFF_SCHEMA_$Time.json"

Copy-Item $DebuffFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History = [ordered]@{

    Command = "CMD_052"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $DebuffFile

    Backup = $BackupFile

    SHA256 = (Get-FileHash $DebuffFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_052_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_052
STATUS  : SUCCESS

FILE
----
$DebuffFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $DebuffFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_052_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_052 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

