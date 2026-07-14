# ================================================================================
# NASRIUM PROJECT
# CMD_094_BUILD_CHAT_CORE_SERVICE
# STEP 001 - FINAL
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$ModuleDir = "$Root\Core\Modules"
$ModuleFile = "$ModuleDir\NSM_ChatService.psm1"
$ChatLogDir = "$Root\Data\Systems\Chat\Logs"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$StateFile = "$Root\Core\Knowledge\PROJECT_STATE.json"
$MasterHistoryFile = "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# ۱. ساخت پوشه‌ها در صورت عدم وجود
if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
if (!(Test-Path $ChatLogDir)) { New-Item -ItemType Directory -Path $ChatLogDir -Force | Out-Null }
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
if (!(Test-Path $HistoryDir)) { New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null }
if (!(Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }

# ۲. ایجاد پشتیبان در صورت وجود فایل ماژول قدیمی (Idempotency)
if (Test-Path $ModuleFile) {
    $BackupFile = "$BackupDir\NSM_ChatService_$Time.psm1.bak"
    Copy-Item $ModuleFile $BackupFile -Force
}

# ۳. ایجاد سورس‌کد ماژول سرویس چت (Chat Service Module)
$ModuleLines = @(
    '# ================================================================================',
    '# NASRIUM CHAT SERVICE MODULE',
    '# ================================================================================',
    'function New-NSMChatChannel {',
    '    [CmdletBinding()]',
    '    param (',
    '        [Parameter(Mandatory=$true)][string]$ChannelName,',
    '        [Parameter(Mandatory=$true)][string]$ChannelType # Global, Clan, System',
    '    )',
    '    process {',
    '        if ($null -eq $global:NSM_ChatChannels) {',
    '            $global:NSM_ChatChannels = @{}',
    '        }',
    '        $ChannelId = "CH_" + (Get-Date -Format "yyyyMMdd") + "_" + $ChannelName.ToUpper()',
    '        $global:NSM_ChatChannels[$ChannelId] = [ordered]@{',
    '            ChannelId   = $ChannelId',
    '            ChannelName = $ChannelName',
    '            ChannelType = $ChannelType',
    '            CreatedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
    '            Active      = $true',
    '        }',
    '        return [PSCustomObject]$global:NSM_ChatChannels[$ChannelId]',
    '    }',
    '}',
    '',
    'function Send-NSMChatMessage {',
    '    [CmdletBinding()]',
    '    param (',
    '        [Parameter(Mandatory=$true)][string]$ChannelId,',
    '        [Parameter(Mandatory=$true)][string]$UserId,',
    '        [Parameter(Mandatory=$true)][string]$Message,',
    '        [Parameter(Mandatory=$true)][string]$LogDirPath',
    '    )',
    '    process {',
    '        # ۱. ابتدا بررسی فعال بودن موتور تعدیل پیام‌ها',
    '        if (Get-Command Test-NSMChatMessage -ErrorAction SilentlyContinue) {',
    '            $ModerationResult = Test-NSMChatMessage -Message $Message -UserId $UserId',
    '            if (-not $ModerationResult.IsValid) {',
    '                return [PSCustomObject]@{',
    '                    Status     = "REJECTED"',
    '                    Reason     = $ModerationResult.Reason',
    '                    Message    = $Message',
    '                    Timestamp  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
    '                    AuditHash  = $null',
    '                }',
    '            }',
    '        } else {',
    '            Write-Warning "Chat Moderator Module not loaded. Bypassing moderation check (Not Recommended)."',
    '        }',
    '',
    '        # ۲. تولید پکیج پیام تایید شده',
    '        $MsgId = [Guid]::NewGuid().ToString()',
    '        $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
    '        $Payload = [ordered]@{',
    '            MessageId = $MsgId',
    '            ChannelId = $ChannelId',
    '            UserId    = $UserId',
    '            Message   = $Message',
    '            Timestamp = $Timestamp',
    '        }',
    '        ',
    '        # ۳. ذخیره‌سازی پیام در قالب لاگ فیزیکی کانال (Storage Engine)',
    '        $TargetLogFile = Join-Path $LogDirPath "$ChannelId`_History.json"',
    '        $ChannelLogs = @()',
    '        if (Test-Path $TargetLogFile) {',
    '            $ChannelLogs = Get-Content $TargetLogFile -Raw | ConvertFrom-Json',
    '        }',
    '        $ChannelLogsList = [System.Collections.ArrayList]@($ChannelLogs)',
    '        [void]$ChannelLogsList.Add($Payload)',
    '        $ChannelLogsList | ConvertTo-Json -Depth 20 | Set-Content $TargetLogFile -Encoding UTF8 -Force',
    '',
    '        return [PSCustomObject]@{',
    '            Status     = "SUCCESS"',
    '            Reason     = "APPROVED"',
    '            Message    = $Message',
    '            Timestamp  = $Timestamp',
    '            AuditHash  = (Get-FileHash $TargetLogFile -Algorithm SHA256).Hash',
    '        }',
    '    }',
    '}',
    '',
    'Export-ModuleMember -Function New-NSMChatChannel, Send-NSMChatMessage'
)

$ModuleCode = $ModuleLines -join "`r`n"
$ModuleCode | Set-Content $ModuleFile -Encoding UTF8 -Force

# ۴. آپدیت خودکار STATE پروژه (SDPA Compliant)
if (Test-Path $StateFile) {
    $State = Get-Content $StateFile -Raw | ConvertFrom-Json
    $State.LastCommand = "CMD_094_BUILD_CHAT_CORE_SERVICE"
    $State.LastCommandStatus = "SUCCESS"
    $State.LastCommandTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $State.NextCommand = "CMD_095"
    $State.ProgressPercent = 18
    
    if ($State.InProgressModules -contains "Chat System") {
        $State.InProgressModules = $State.InProgressModules | Where-Object { $_ -ne "Chat System" }
    }
    if (!($State.CompletedModules -contains "Chat System")) {
        $State.CompletedModules += "Chat System"
    }

    $State | ConvertTo-Json -Depth 20 | Set-Content $StateFile -Encoding UTF8 -Force
}

# ۵. آپدیت تاریخچه جامع MASTER_HISTORY (SDPA Compliant)
if (Test-Path $MasterHistoryFile) {
    $MasterHistory = Get-Content $MasterHistoryFile -Raw | ConvertFrom-Json
    
    if ($null -eq $MasterHistory.PSObject.Properties['Commands'] -or $null -eq $MasterHistory.Commands) {
        $MasterHistory = Add-Member -InputObject $MasterHistory -NotePropertyName "Commands" -NotePropertyValue @() -PassThru -Force
    }

    $NewCommand = [ordered]@{
        CMD = "CMD_094"
        Name = "BUILD_CHAT_CORE_SERVICE"
        Domain = "Chat"
        Category = "CoreService"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "توسعه ماژول مدیریت سرویس چت، ایجاد کانال‌های ارتباطی تفکیک شده و سیستم ذخیره‌سازی لاگ‌های فیزیکی پیام‌ها"
    }

    $CommandsList = [System.Collections.ArrayList]@($MasterHistory.Commands)
    [void]$CommandsList.Add($NewCommand)
    $MasterHistory.Commands = $CommandsList

    $MasterHistory | ConvertTo-Json -Depth 20 | Set-Content $MasterHistoryFile -Encoding UTF8 -Force
}

# ۶. تولید فایل History محلی و گزارش نهایی (Report)
$SHA256 = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash

$History = [ordered]@{
    Command = "CMD_094"
    Version = "1.0.0"
    Status = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output = $ModuleFile
    SHA256 = $SHA256
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_094_HISTORY_$Time.json" -Encoding UTF8

$Report = @"
==================================================
NASRIUM BUILD REPORT
==================================================
COMMAND : CMD_094
STATUS  : SUCCESS
DOMAIN  : Chat (Core Service)

MODULE CREATED
--------------
$ModuleFile

STORAGE DIRECTORY
-----------------
$ChatLogDir

SHA256 HASH
-----------
$SHA256

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
==================================================
"@
$Report | Set-Content "$ReportDir\CMD_094_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_094 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0
