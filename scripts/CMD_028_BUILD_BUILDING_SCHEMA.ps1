# ================================================================================
# NASRIUM PROJECT
# CMD_028_BUILD_BUILDING_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$BuildingDir="$Root\Data\Balance\Buildings"

if(!(Test-Path $BuildingDir)){
    New-Item -ItemType Directory -Path $BuildingDir -Force | Out-Null
}

$BuildingFile="$BuildingDir\NSM_BUILDING_SCHEMA_V1.json"

$Building=[ordered]@{

Metadata=[ordered]@{

Module="CMD_028"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Buildings=@()

}

$Building |
ConvertTo-Json -Depth 20 |
Set-Content $BuildingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_028 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_028_BUILD_BUILDING_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuildingFile="$Root\Data\Balance\Buildings\NSM_BUILDING_SCHEMA_V1.json"

$Building=Get-Content $BuildingFile -Raw | ConvertFrom-Json

$Building.Buildings=@(

    [PSCustomObject]@{

        Id="building_001"

        Name="Town Hall"

        Category="Core"

        MaxLevel=20

        BaseHP=5000

        HpMultiplier=1.25

        BuildCost=0

        CostMultiplier=1.00

        BuildTime=0

        UnlockLevel=1

    },

    [PSCustomObject]@{

        Id="building_002"

        Name="Gold Mine"

        Category="Resource"

        MaxLevel=20

        BaseHP=900

        HpMultiplier=1.18

        BuildCost=150

        CostMultiplier=1.55

        BuildTime=60

        UnlockLevel=1

    },

    [PSCustomObject]@{

        Id="building_003"

        Name="Elixir Collector"

        Category="Resource"

        MaxLevel=20

        BaseHP=900

        HpMultiplier=1.18

        BuildCost=150

        CostMultiplier=1.55

        BuildTime=60

        UnlockLevel=1

    }

)

$Building |
ConvertTo-Json -Depth 20 |
Set-Content $BuildingFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_028 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_028_BUILD_BUILDING_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuildingFile="$Root\Data\Balance\Buildings\NSM_BUILDING_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_BUILDING_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_BUILDING_VALIDATION_V1.json"

$Building=Get-Content $BuildingFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $BuildingFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_028"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

BuildingCount=@($Building.Buildings).Count

File=$BuildingFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_028"

Status="SUCCESS"

BuildingFile=(Test-Path $BuildingFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_028 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_028_BUILD_BUILDING_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BuildingFile="$Root\Data\Balance\Buildings\NSM_BUILDING_SCHEMA_V1.json"

$BackupDir="$Root\Backups"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile="$BackupDir\NSM_BUILDING_SCHEMA_$Time.json"

Copy-Item $BuildingFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_028"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$BuildingFile

Backup=$BackupFile

SHA256=(Get-FileHash $BuildingFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_028_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_028
STATUS  : SUCCESS

FILE
----
$BuildingFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $BuildingFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_028_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_028 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

