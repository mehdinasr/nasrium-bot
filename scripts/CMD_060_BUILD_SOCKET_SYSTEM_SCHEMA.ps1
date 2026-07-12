# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 001
# ================================================================================
#
# Create Socket System Schema
#
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"

$SocketDir = "$Root\Data\Systems\Sockets"

if (!(Test-Path $SocketDir)) {
    New-Item -ItemType Directory -Path $SocketDir -Force | Out-Null
}

$SocketFile = "$SocketDir\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$SocketSystem = [ordered]@{

    Metadata = [ordered]@{

        Module    = "CMD_060"

        Version   = "1.0.0"

        Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    SocketTypes = @()

}

$SocketSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SocketFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_060 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Socket Type Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$SocketFile = "$Root\Data\Systems\Sockets\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$SocketSystem = Get-Content $SocketFile -Raw | ConvertFrom-Json

$SocketSystem.SocketTypes = @(

    [PSCustomObject]@{

        Id = "socket_001"

        Name = "Ruby Socket"

        GemType = "Ruby"

        TargetEquipment = @(
            "Weapon",
            "Armor"
        )

        BonusAttribute = "Attack"

        BonusValue = 15

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_002"

        Name = "Sapphire Socket"

        GemType = "Sapphire"

        TargetEquipment = @(
            "Helmet",
            "Armor"
        )

        BonusAttribute = "Mana"

        BonusValue = 100

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_003"

        Name = "Emerald Socket"

        GemType = "Emerald"

        TargetEquipment = @(
            "Boots",
            "Gloves"
        )

        BonusAttribute = "MoveSpeed"

        BonusValue = 5

        BonusType = "Percent"

        MaxGemLevel = 8

    },

    [PSCustomObject]@{

        Id = "socket_004"

        Name = "Diamond Socket"

        GemType = "Diamond"

        TargetEquipment = @(
            "Accessory",
            "Weapon"
        )

        BonusAttribute = "CriticalChance"

        BonusValue = 3

        BonusType = "Percent"

        MaxGemLevel = 12

    }

)

$SocketSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SocketFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_060 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Socket Type Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$SocketFile = "$Root\Data\Systems\Sockets\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$SocketSystem = Get-Content $SocketFile -Raw | ConvertFrom-Json

$SocketSystem.SocketTypes = @(

    [PSCustomObject]@{

        Id = "socket_001"

        Name = "Ruby Socket"

        GemType = "Ruby"

        TargetEquipment = @(
            "Weapon",
            "Armor"
        )

        BonusAttribute = "Attack"

        BonusValue = 15

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_002"

        Name = "Sapphire Socket"

        GemType = "Sapphire"

        TargetEquipment = @(
            "Helmet",
            "Armor"
        )

        BonusAttribute = "Mana"

        BonusValue = 100

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_003"

        Name = "Emerald Socket"

        GemType = "Emerald"

        TargetEquipment = @(
            "Boots",
            "Gloves"
        )

        BonusAttribute = "MoveSpeed"

        BonusValue = 5

        BonusType = "Percent"

        MaxGemLevel = 8

    },

    [PSCustomObject]@{

        Id = "socket_004"

        Name = "Diamond Socket"

        GemType = "Diamond"

        TargetEquipment = @(
            "Accessory",
            "Weapon"
        )

        BonusAttribute = "CriticalChance"

        BonusValue = 3

        BonusType = "Percent"

        MaxGemLevel = 12

    }

)

$SocketSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SocketFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_060 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 002
# ================================================================================
#
# Socket Type Definitions
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$SocketFile = "$Root\Data\Systems\Sockets\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$SocketSystem = Get-Content $SocketFile -Raw | ConvertFrom-Json

$SocketSystem.SocketTypes = @(

    [PSCustomObject]@{

        Id = "socket_001"

        Name = "Ruby Socket"

        GemType = "Ruby"

        TargetEquipment = @(
            "Weapon",
            "Armor"
        )

        BonusAttribute = "Attack"

        BonusValue = 15

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_002"

        Name = "Sapphire Socket"

        GemType = "Sapphire"

        TargetEquipment = @(
            "Helmet",
            "Armor"
        )

        BonusAttribute = "Mana"

        BonusValue = 100

        BonusType = "Flat"

        MaxGemLevel = 10

    },

    [PSCustomObject]@{

        Id = "socket_003"

        Name = "Emerald Socket"

        GemType = "Emerald"

        TargetEquipment = @(
            "Boots",
            "Gloves"
        )

        BonusAttribute = "MoveSpeed"

        BonusValue = 5

        BonusType = "Percent"

        MaxGemLevel = 8

    },

    [PSCustomObject]@{

        Id = "socket_004"

        Name = "Diamond Socket"

        GemType = "Diamond"

        TargetEquipment = @(
            "Accessory",
            "Weapon"
        )

        BonusAttribute = "CriticalChance"

        BonusValue = 3

        BonusType = "Percent"

        MaxGemLevel = 12

    }

)

$SocketSystem |
ConvertTo-Json -Depth 20 |
Set-Content $SocketFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_060 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 003
# ================================================================================
#
# Metadata & Validation
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$SocketFile = "$Root\Data\Systems\Sockets\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $MetadataDir)) {
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile = "$MetadataDir\NSM_SOCKET_SYSTEM_METADATA_V1.json"

$ValidationFile = "$MetadataDir\NSM_SOCKET_SYSTEM_VALIDATION_V1.json"

$SocketSystem = Get-Content $SocketFile -Raw | ConvertFrom-Json

$Hash = (Get-FileHash $SocketFile -Algorithm SHA256).Hash

$Metadata = [ordered]@{

    Module = "CMD_060"

    Version = "1.0.0"

    Generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    SocketTypeCount = @($SocketSystem.SocketTypes).Count

    File = $SocketFile

    SHA256 = $Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation = [ordered]@{

    Module = "CMD_060"

    Status = "SUCCESS"

    SocketFile = (Test-Path $SocketFile)

    MetadataFile = (Test-Path $MetadataFile)

    SHA256 = $Hash

    ValidationTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_060 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_060_BUILD_SOCKET_SYSTEM_SCHEMA
# STEP 004
# FINAL
# ================================================================================
#
# Backup, History & Report
#
# ================================================================================

$ErrorActionPreference = "Stop"

$Root = "D:\NASRIUM"

$SocketFile = "$Root\Data\Systems\Sockets\NSM_SOCKET_SYSTEM_SCHEMA_V1.json"

$BackupDir = "$Root\Backups"

$HistoryDir = "$Root\Builder\History"

$ReportDir = "$Root\Builder\Reports"

$Time = Get-Date -Format "yyyyMMdd_HHmmss"

foreach($Dir in @($BackupDir, $HistoryDir, $ReportDir)) {
    if (!(Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile = "$BackupDir\NSM_SOCKET_SYSTEM_SCHEMA_$Time.json"

Copy-Item $SocketFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$SHA256 = (Get-FileHash $SocketFile -Algorithm SHA256).Hash

$History = [ordered]@{

    Command = "CMD_060"

    Version = "1.0.0"

    Status = "SUCCESS"

    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    Output = $SocketFile

    Backup = $BackupFile

    SHA256 = $SHA256

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_060_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report = @"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_060
STATUS  : SUCCESS

FILE
----
$SocketFile

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
Set-Content "$ReportDir\CMD_060_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_060 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

