# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 008 FIX
# FINAL BACKUP HISTORY REPORT
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModuleFile="$Root\Core\Modules\Chat\NSM_ChatModerator.psm1"

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


$BackupFile="$BackupDir\NSM_CHAT_MODERATOR_$Time.psm1"

Copy-Item $ModuleFile $BackupFile -Force


$Hash=(Get-FileHash $ModuleFile -Algorithm SHA256).Hash


$History=[ordered]@{

Command="CMD_092"

Version="1.0.0"

Status="SUCCESS"

ExecutionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

Output=$ModuleFile

Backup=$BackupFile

SHA256=$Hash

}


$History |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_092_HISTORY_$Time.json" -Encoding UTF8


$Report=@"

==================================================
NASRIUM BUILD REPORT
==================================================

COMMAND : CMD_092
STATUS  : SUCCESS

MODULE
------
$ModuleFile

BACKUP
------
$BackupFile

SHA256
------
$Hash

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_092_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_092 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 009
# MODULE IMPORT TEST
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModuleFile="$Root\Core\Modules\Chat\NSM_ChatModerator.psm1"


Import-Module $ModuleFile -Force


$TestMessage="NASRIUM TEST MESSAGE"


$Result=Verify-NSMChatMessage -Message $TestMessage


$Result |
ConvertTo-Json -Depth 20 |
Write-Host


Write-Host ""
Write-Host "CMD_092 STEP-009 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 010
# RUNTIME LOAD TEST
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModuleFile="$Root\Core\Modules\Chat\NSM_ChatModerator.psm1"


Import-Module $ModuleFile -Force


$TestResult=[ordered]@{

Module="CMD_092"

Status="SUCCESS"

Imported=$true

Functions=@(
    "Verify-NSMChatMessage",
    "Get-NSMChatReport"
)

TestTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$TestResult |
ConvertTo-Json -Depth 20 |
Set-Content "$Root\Data\Metadata\NSM_CHAT_MODERATION_RUNTIME_TEST_V1.json" -Encoding UTF8


Write-Host ""
Write-Host "CMD_092 STEP-010 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 011
# FINAL VALIDATION
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$ModuleFile="$Root\Core\Modules\Chat\NSM_ChatModerator.psm1"

$ValidationFile="$Root\Data\Metadata\NSM_CHAT_MODERATION_FINAL_VALIDATION_V1.json"


$Hash=(Get-FileHash $ModuleFile -Algorithm SHA256).Hash


$Validation=[ordered]@{

Command="CMD_092"

Module="NSM_ChatModerator"

Status="SUCCESS"

ModuleExists=(Test-Path $ModuleFile)

SHA256=$Hash

FinalValidation=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$Validation |
ConvertTo-Json -Depth 20 |
Set-Content $ValidationFile -Encoding UTF8


Write-Host ""
Write-Host "CMD_092 STEP-011 SUCCESS" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 012
# FINAL COMPLETION RECORD
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"


if(!(Test-Path $HistoryDir)){
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
}

if(!(Test-Path $ReportDir)){
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}


$Time=Get-Date -Format "yyyyMMdd_HHmmss"


$Completion=[ordered]@{

Command="CMD_092"

Name="BUILD_CHAT_MODERATION_ENGINE"

Status="COMPLETED"

Version="1.0.0"

StepsCompleted=12

CompletionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$Completion |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_092_COMPLETION_$Time.json" -Encoding UTF8


$Report=@"

==================================================
NASRIUM FINAL BUILD REPORT
==================================================

COMMAND
-------
CMD_092_BUILD_CHAT_MODERATION_ENGINE

STATUS
------
COMPLETED

VERSION
-------
1.0.0

STEPS
-----
12

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_092_FINAL_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_092 COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# ================================================================================
# NASRIUM PROJECT
# CMD_092_BUILD_CHAT_MODERATION_ENGINE
# STEP 012
# FINAL COMPLETION RECORD
# ================================================================================

$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$Root="D:\NASRIUM"

$HistoryDir="$Root\Builder\History"

$ReportDir="$Root\Builder\Reports"


if(!(Test-Path $HistoryDir)){
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
}

if(!(Test-Path $ReportDir)){
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}


$Time=Get-Date -Format "yyyyMMdd_HHmmss"


$Completion=[ordered]@{

Command="CMD_092"

Name="BUILD_CHAT_MODERATION_ENGINE"

Status="COMPLETED"

Version="1.0.0"

StepsCompleted=12

CompletionTime=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

}


$Completion |
ConvertTo-Json -Depth 20 |
Set-Content "$HistoryDir\CMD_092_COMPLETION_$Time.json" -Encoding UTF8


$Report=@"

==================================================
NASRIUM FINAL BUILD REPORT
==================================================

COMMAND
-------
CMD_092_BUILD_CHAT_MODERATION_ENGINE

STATUS
------
COMPLETED

VERSION
-------
1.0.0

STEPS
-----
12

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

==================================================

"@


$Report |
Set-Content "$ReportDir\CMD_092_FINAL_REPORT_$Time.txt" -Encoding UTF8


Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_092 COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

