# ================================================================================
# NASRIUM PROJECT
# CMD_043_BUILD_GUILD_SCHEMA
# STEP 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$GuildDir="$Root\Data\Balance\Guilds"

if(!(Test-Path $GuildDir)){
    New-Item -ItemType Directory -Path $GuildDir -Force | Out-Null
}

$GuildFile="$GuildDir\NSM_GUILD_SCHEMA_V1.json"

$Guild=[ordered]@{

Metadata=[ordered]@{

Module="CMD_043"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

Guilds=@()

}

$Guild |
ConvertTo-Json -Depth 20 |
Set-Content $GuildFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_043 STEP-001 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_043_BUILD_GUILD_SCHEMA
# STEP 002
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$GuildFile="$Root\Data\Balance\Guilds\NSM_GUILD_SCHEMA_V1.json"

$Guild=Get-Content $GuildFile -Raw | ConvertFrom-Json

$Guild.Guilds=@(

    [PSCustomObject]@{

        Id="guild_001"

        Name="Novice Guild"

        Level=1

        MaxMembers=20

        CreateCost=1000

        DailyDonationLimit=1000

        MaxGuildLevel=10

        GuildBuff="Attack +2%"

    },

    [PSCustomObject]@{

        Id="guild_002"

        Name="Elite Guild"

        Level=5

        MaxMembers=30

        CreateCost=5000

        DailyDonationLimit=5000

        MaxGuildLevel=20

        GuildBuff="Attack +5%, Defense +5%"

    },

    [PSCustomObject]@{

        Id="guild_003"

        Name="Legend Guild"

        Level=10

        MaxMembers=50

        CreateCost=25000

        DailyDonationLimit=10000

        MaxGuildLevel=50

        GuildBuff="All Stats +10%"

    },

    [PSCustomObject]@{

        Id="guild_004"

        Name="Mythic Guild"

        Level=20

        MaxMembers=100

        CreateCost=100000

        DailyDonationLimit=50000

        MaxGuildLevel=100

        GuildBuff="All Stats +20%"

    }

)

$Guild |
ConvertTo-Json -Depth 20 |
Set-Content $GuildFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_043 STEP-002 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_043_BUILD_GUILD_SCHEMA
# STEP 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$GuildFile="$Root\Data\Balance\Guilds\NSM_GUILD_SCHEMA_V1.json"

$MetadataDir="$Root\Data\Metadata"

if(!(Test-Path $MetadataDir)){
    New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null
}

$MetadataFile="$MetadataDir\NSM_GUILD_METADATA_V1.json"

$ValidationFile="$MetadataDir\NSM_GUILD_VALIDATION_V1.json"

$Guild=Get-Content $GuildFile -Raw | ConvertFrom-Json

$Hash=(Get-FileHash $GuildFile -Algorithm SHA256).Hash

$Metadata=[ordered]@{

Module="CMD_043"

Version="1.0.0"

Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

GuildCount=@($Guild.Guilds).Count

File=$GuildFile

SHA256=$Hash

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

Module="CMD_043"

Status="SUCCESS"

GuildFile=(Test-Path $GuildFile)

MetadataFile=(Test-Path $MetadataFile)

SHA256=$Hash

ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_043 STEP-003 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_043_BUILD_GUILD_SCHEMA
# STEP 004
# FINAL
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$GuildFile="$Root\Data\Balance\Guilds\NSM_GUILD_SCHEMA_V1.json"

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

$BackupFile="$BackupDir\NSM_GUILD_SCHEMA_$Time.json"

Copy-Item $GuildFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_043"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$GuildFile

Backup=$BackupFile

SHA256=(Get-FileHash $GuildFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_043_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_043
STATUS  : SUCCESS

FILE
----
$GuildFile

BACKUP
------
$BackupFile

SHA256
------
$((Get-FileHash $GuildFile -Algorithm SHA256).Hash)

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@

$Report |
Set-Content "$ReportDir\CMD_043_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_043 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0

