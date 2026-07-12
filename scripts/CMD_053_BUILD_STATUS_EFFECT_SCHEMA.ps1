# ================================================================================
# NASRIUM PROJECT
# CMD_053_BUILD_STATUS_EFFECT_SCHEMA
# STEP 001
# ================================================================================
#
# Create Status Effect Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$StatusDir = "$Root\Data\Balance\StatusEffects"

if (!(Test-Path $StatusDir)) {
    New-Item -ItemType Directory -Path $StatusDir -Force | Out-Null
}

$StatusFile = "$StatusDir\NSM_STATUS_EFFECT_SCHEMA_V1.json"

$Status = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_053"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    StatusEffects = @()

}

$Status |
ConvertTo-Json -Depth 20 |
Set-Content $StatusFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_053 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_053_BUILD_STATUS_EFFECT_SCHEMA
# STEP 002
# ================================================================================
#
# Status Effect Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StatusFile = "$Root\Data\Balance\StatusEffects\NSM_STATUS_EFFECT_SCHEMA_V1.json"

$Status = Get-Content $StatusFile -Raw | ConvertFrom-Json

$Status.StatusEffects = @(

    [PSCustomObject]@{

        Id = "status_001"

        Name = "Stun"

        Category = "CrowdControl"

        BlocksMovement = $true

        BlocksAttack = $true

        BlocksSkill = $true

        DurationSeconds = 3

        Stackable = $false

    },

    [PSCustomObject]@{

        Id = "status_002"

        Name = "Knockback"

        Category = "Movement"

        BlocksMovement = $false

        BlocksAttack = $false

        BlocksSkill = $false

        DurationSeconds = 1

        Stackable = $false

    },

    [PSCustomObject]@{

        Id = "status_003"

        Name = "Invincible"

        Category = "Protection"

        BlocksMovement = $false

        BlocksAttack = $false

        BlocksSkill = $false

        DurationSeconds = 5

        Stackable = $false

    },

    [PSCustomObject]@{

        Id = "status_004"

        Name = "Invisible"

        Category = "Stealth"

        BlocksMovement = $false

        BlocksAttack = $false

        BlocksSkill = $false

        DurationSeconds = 10

        Stackable = $false

    }

)

$Status |
ConvertTo-Json -Depth 20 |
Set-Content $StatusFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_053 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_053_BUILD_STATUS_EFFECT_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StatusFile = "$Root\Data\Balance\StatusEffects\NSM_STATUS_EFFECT_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_STATUS_EFFECT_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_STATUS_EFFECT_VALIDATION_V1.json"

$Status = Get-Content $StatusFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $StatusFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_053"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    StatusEffectCount = @($Status.StatusEffects).Count

    File = $StatusFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_053"

    Status = "SUCCESS"

    StatusFile = (Test-Path $StatusFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_053 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_053_BUILD_STATUS_EFFECT_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StatusFile = "$Root\Data\Balance\StatusEffects\NSM_STATUS_EFFECT_SCHEMA_V1.json"

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

$BackupFile = "$BackupDir\NSM_STATUS_EFFECT_SCHEMA_$Time.json"

Copy-Item $StatusFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History = [ordered]@{

    Command = "CMD_053"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $StatusFile

    Backup = $BackupFile

    SHA256 = (Get-FileHash $StatusFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_053_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_053
STATUS  : SUCCESS

FILE
----
$StatusFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $StatusFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_053_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_053 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

