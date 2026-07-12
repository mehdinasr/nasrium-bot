# ================================================================================
# NASRIUM PROJECT
# MODULE : CMD_025D_TROOP_BALANCE
# STEP   : 001
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

@(
"$Root",
"$Root\Builder",
"$Root\Builder\Reports",
"$Root\Builder\History",
"$Root\Builder\Templates",
"$Root\Config",
"$Root\Data",
"$Root\Data\Balance",
"$Root\Data\Balance\Troops",
"$Root\Data\Metadata",
"$Root\Logs",
"$Root\Backups",
"$Root\Runtime",
"$Root\Tests",
"$Root\Documentation",
"$Root\Scripts",
"$Root\Tools"
) | ForEach-Object{
    if(!(Test-Path $_)){
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

Write-Host ""
Write-Host "CMD_025D STEP-001 SUCCESS" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# MODULE : CMD_025D_TROOP_BALANCE
# STEP   : 002
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$FormulaFile="$Root\Data\Balance\Troops\NSM_TROOP_FORMULA_V1.json"

$Formula=[ordered]@{

    Metadata=[ordered]@{

        Module="CMD_025D"
        Version="1.0.0"
        Builder="4.0.0"
        Schema="1.0.0"
        Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Troops=[ordered]@{

        Warrior=[ordered]@{

            MaxLevel=8
            BaseHP=45
            HpMultiplier=1.35
            BaseDamage=8
            DamageMultiplier=1.30
            BaseCost=50
            CostMultiplier=1.60
            BaseTrainingTime=20
            TrainingMultiplier=1.10

        }

        Archer=[ordered]@{

            MaxLevel=8
            BaseHP=30
            HpMultiplier=1.28
            BaseDamage=11
            DamageMultiplier=1.25
            BaseCost=60
            CostMultiplier=1.70
            BaseTrainingTime=25
            TrainingMultiplier=1.10

        }

        Giant=[ordered]@{

            MaxLevel=6
            BaseHP=300
            HpMultiplier=1.40
            BaseDamage=15
            DamageMultiplier=1.20
            BaseCost=250
            CostMultiplier=1.90
            BaseTrainingTime=120
            TrainingMultiplier=1.15

        }

    }

}

$Formula | ConvertTo-Json -Depth 20 | Set-Content $FormulaFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_025D STEP-002 SUCCESS" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# MODULE : CMD_025D_TROOP_BALANCE
# STEP   : 003
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$FormulaFile    ="$Root\Data\Balance\Troops\NSM_TROOP_FORMULA_V1.json"
$BalanceFile    ="$Root\Data\Balance\Troops\NSM_TROOP_BALANCE_V1.json"

$Formula = Get-Content $FormulaFile -Raw | ConvertFrom-Json

$Balance=[ordered]@{

    Metadata=[ordered]@{

        Module="CMD_025D"
        Version="1.0.0"
        Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }

    Troops=[ordered]@{}

}

foreach($Troop in $Formula.Troops.PSObject.Properties){

    $Name=$Troop.Name
    $T=$Troop.Value

    $Levels=@()

    for($L=1;$L -le $T.MaxLevel;$L++){

        $Levels+=[ordered]@{

            Level=$L

            TrainingCostGold=[math]::Round($T.BaseCost*[math]::Pow($T.CostMultiplier,$L-1))

            TrainingTimeSec=[math]::Round($T.BaseTrainingTime*[math]::Pow($T.TrainingMultiplier,$L-1))

            DamagePerSecond=[math]::Round($T.BaseDamage*[math]::Pow($T.DamageMultiplier,$L-1))

            HitPoints=[math]::Round($T.BaseHP*[math]::Pow($T.HpMultiplier,$L-1))

        }

    }

    $Balance.Troops[$Name]=[ordered]@{

        MaxLevel=$T.MaxLevel

        Levels=$Levels

    }

}

$Balance | ConvertTo-Json -Depth 100 | Set-Content $BalanceFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_025D STEP-003 SUCCESS" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# MODULE : CMD_025D_TROOP_BALANCE
# STEP   : 004
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BalanceFile="$Root\Data\Balance\Troops\NSM_TROOP_BALANCE_V1.json"
$MetadataFile="$Root\Data\Metadata\NSM_TROOP_METADATA_V1.json"
$ValidationFile="$Root\Data\Metadata\NSM_TROOP_VALIDATION_V1.json"

$Hash=(Get-FileHash $BalanceFile -Algorithm SHA256).Hash

$Balance=Get-Content $BalanceFile -Raw | ConvertFrom-Json

$Metadata=[ordered]@{

    Module="CMD_025D"

    Version="1.0.0"

    BuilderVersion="4.0.0"

    SchemaVersion="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    File="NSM_TROOP_BALANCE_V1.json"

    SHA256=$Hash

    TroopCount=@($Balance.Troops.PSObject.Properties).Count

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_025D"

    Status="SUCCESS"

    BalanceFile=(Test-Path $BalanceFile)

    MetadataFile=(Test-Path $MetadataFile)

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_025D STEP-004 SUCCESS" -ForegroundColor Green
# ================================================================================
# NASRIUM PROJECT
# MODULE : CMD_025D_TROOP_BALANCE
# STEP   : 004
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BalanceFile="$Root\Data\Balance\Troops\NSM_TROOP_BALANCE_V1.json"
$MetadataFile="$Root\Data\Metadata\NSM_TROOP_METADATA_V1.json"
$ValidationFile="$Root\Data\Metadata\NSM_TROOP_VALIDATION_V1.json"

$Hash=(Get-FileHash $BalanceFile -Algorithm SHA256).Hash

$Balance=Get-Content $BalanceFile -Raw | ConvertFrom-Json

$Metadata=[ordered]@{

    Module="CMD_025D"

    Version="1.0.0"

    BuilderVersion="4.0.0"

    SchemaVersion="1.0.0"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    File="NSM_TROOP_BALANCE_V1.json"

    SHA256=$Hash

    TroopCount=@($Balance.Troops.PSObject.Properties).Count

}

$Metadata |
ConvertTo-Json -Depth 20 |
Set-Content $MetadataFile -Encoding UTF8

$Validation=[ordered]@{

    Module="CMD_025D"

    Status="SUCCESS"

    BalanceFile=(Test-Path $BalanceFile)

    MetadataFile=(Test-Path $MetadataFile)

    SHA256=$Hash

    ValidationTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}

$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_025D STEP-004 SUCCESS" -ForegroundColor Green


# ================================================================================
# CMD_025D
# STEP 005
# FINALIZE
# PART 1
# ================================================================================

$ErrorActionPreference="Stop"

$Root="D:\NASRIUM"

$BalanceFile="$Root\Data\Balance\Troops\NSM_TROOP_BALANCE_V1.json"

$BackupDir="$Root\Backups"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"

$Time=Get-Date -Format "yyyyMMdd_HHmmss"

#------------------------------------------------------------------------------
# Backup
#------------------------------------------------------------------------------

$BackupFile="$BackupDir\NSM_TROOP_BALANCE_$Time.json"

Copy-Item $BalanceFile $BackupFile -Force

#------------------------------------------------------------------------------
# History
#------------------------------------------------------------------------------

$History=[ordered]@{

Command="CMD_025D"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$BalanceFile

Backup=$BackupFile

SHA256=(Get-FileHash $BalanceFile -Algorithm SHA256).Hash

}

$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_025D_HISTORY_$Time.json" -Encoding UTF8

#------------------------------------------------------------------------------
# Report
#------------------------------------------------------------------------------

$Report=@"

==========================================================
NASRIUM BUILD REPORT
==========================================================

Command       : CMD_025D
Version       : 1.0.0
Status        : SUCCESS
ExecutionTime : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Balance File
------------
$BalanceFile

Backup File
-----------
$BackupFile

SHA256
------
$((Get-FileHash $BalanceFile -Algorithm SHA256).Hash)

==========================================================

"@

$Report |
Set-Content "$ReportDir\CMD_025D_REPORT_$Time.txt" -Encoding UTF8

#------------------------------------------------------------------------------
# Finish
#------------------------------------------------------------------------------

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "CMD_025D SUCCESS" -ForegroundColor Green
Write-Host "Balance  : $BalanceFile" -ForegroundColor Yellow
Write-Host "Backup   : $BackupFile" -ForegroundColor Yellow
Write-Host "History  : $HistoryDir\CMD_025D_HISTORY_$Time.json" -ForegroundColor Yellow
Write-Host "Report   : $ReportDir\CMD_025D_REPORT_$Time.txt" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Green

Exit 0

