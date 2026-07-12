# ================================================================================
# NASRIUM PROJECT
# CMD_055_BUILD_AI_STATE_MACHINE_SCHEMA
# STEP 001
# ================================================================================
#
# Create AI State Machine Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$StateMachineDir = "$Root\Data\AI\StateMachines"

if (!(Test-Path $StateMachineDir)) {
    New-Item -ItemType Directory -Path $StateMachineDir -Force | Out-Null
}

$StateMachineFile = "$StateMachineDir\NSM_AI_STATE_MACHINE_SCHEMA_V1.json"

$StateMachine = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_055"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    States = @()

}

$StateMachine |
ConvertTo-Json -Depth 20 |
Set-Content $StateMachineFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_055 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_055_BUILD_AI_STATE_MACHINE_SCHEMA
# STEP 002
# ================================================================================
#
# AI State Machine Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StateMachineFile = "$Root\Data\AI\StateMachines\NSM_AI_STATE_MACHINE_SCHEMA_V1.json"

$StateMachine = Get-Content $StateMachineFile -Raw | ConvertFrom-Json

$StateMachine.States = @(

    [PSCustomObject]@{

        Id = "state_001"

        Name = "Idle"

        CanMove = $false

        CanAttack = $false

        NextStates = @(
            "Patrol",
            "Alert"
        )

    },

    [PSCustomObject]@{

        Id = "state_002"

        Name = "Patrol"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Alert",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_003"

        Name = "Alert"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Chase",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_004"

        Name = "Chase"

        CanMove = $true

        CanAttack = $true

        NextStates = @(
            "Attack",
            "Retreat",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_005"

        Name = "Attack"

        CanMove = $true

        CanAttack = $true

        NextStates = @(
            "Chase",
            "Retreat"
        )

    },

    [PSCustomObject]@{

        Id = "state_006"

        Name = "Retreat"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Idle",
            "Patrol"
        )

    }

)

$StateMachine |
ConvertTo-Json -Depth 20 |
Set-Content $StateMachineFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_055 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_055_BUILD_AI_STATE_MACHINE_SCHEMA
# STEP 002
# ================================================================================
#
# AI State Machine Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StateMachineFile = "$Root\Data\AI\StateMachines\NSM_AI_STATE_MACHINE_SCHEMA_V1.json"

$StateMachine = Get-Content $StateMachineFile -Raw | ConvertFrom-Json

$StateMachine.States = @(

    [PSCustomObject]@{

        Id = "state_001"

        Name = "Idle"

        CanMove = $false

        CanAttack = $false

        NextStates = @(
            "Patrol",
            "Alert"
        )

    },

    [PSCustomObject]@{

        Id = "state_002"

        Name = "Patrol"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Alert",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_003"

        Name = "Alert"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Chase",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_004"

        Name = "Chase"

        CanMove = $true

        CanAttack = $true

        NextStates = @(
            "Attack",
            "Retreat",
            "Idle"
        )

    },

    [PSCustomObject]@{

        Id = "state_005"

        Name = "Attack"

        CanMove = $true

        CanAttack = $true

        NextStates = @(
            "Chase",
            "Retreat"
        )

    },

    [PSCustomObject]@{

        Id = "state_006"

        Name = "Retreat"

        CanMove = $true

        CanAttack = $false

        NextStates = @(
            "Idle",
            "Patrol"
        )

    }

)

$StateMachine |
ConvertTo-Json -Depth 20 |
Set-Content $StateMachineFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_055 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_055_BUILD_AI_STATE_MACHINE_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StateMachineFile = "$Root\Data\AI\StateMachines\NSM_AI_STATE_MACHINE_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_AI_STATE_MACHINE_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_AI_STATE_MACHINE_VALIDATION_V1.json"

$StateMachine = Get-Content $StateMachineFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $StateMachineFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_055"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    StateCount = @($StateMachine.States).Count

    File = $StateMachineFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_055"

    Status = "SUCCESS"

    StateMachineFile = (Test-Path $StateMachineFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_055 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_055_BUILD_AI_STATE_MACHINE_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$StateMachineFile = "$Root\Data\AI\StateMachines\NSM_AI_STATE_MACHINE_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir, $HistoryDir, $ReportDir)){
    if(!(Test-Path $Dir)){
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_AI_STATE_MACHINE_SCHEMA_$Time.json"

Copy-Item $StateMachineFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $StateMachineFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_055"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $StateMachineFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_055_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_055
STATUS  : SUCCESS

FILE
----
$StateMachineFile

BACKUP
------
$BackupFile

SHA256
------
$SHA256

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_055_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_055 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

