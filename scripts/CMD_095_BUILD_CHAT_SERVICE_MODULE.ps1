# ================================================================================
# NASRIUM
# CMD_095_BUILD_CHAT_SERVICE_MODULE
# STEP 001 - FINAL
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$ModuleDir = "$Root\Core\Modules"
$ModuleFile = "$ModuleDir\NSM_ChatService.psm1"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# ۱. ساخت پوشه‌ها در صورت عدم وجود
if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
if (!(Test-Path $HistoryDir)) { New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null }
if (!(Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }

# ۲. پشتیبان‌گیری در صورت وجود ماژول قدیمی (Idempotency)
if (Test-Path $ModuleFile) {
    $BackupFile = "$BackupDir\NSM_ChatService_$Time.psm1.bak"
    Copy-Item $ModuleFile $BackupFile -Force
}

# ۳. تولید بدنه ماژول به صورت آرایه متنی (جلوگیری از خطای سینتکس مفسر)
$ModuleLines = @(
    '# ================================================================================',
    '# NASRIUM CHAT SERVICE MODULE',
    '# ================================================================================',
    'function New-NSMChatChannel {',
    '    [CmdletBinding()]',
    '    param (',
    '        [Parameter(Mandatory=$true)][string]$ChannelName,',
    '        [Parameter(Mandatory=$true)][string]$ChannelType',
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
    '        # ارزیابی پیام توسط ماژول تعدیل چت در صورت در دسترس بودن',
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
    '        }',
    '',
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
    '        if (!(Test-Path $LogDirPath)) {',
    '            New-Item -ItemType Directory -Path $LogDirPath -Force | Out-Null',
    '        }',
    '        ',
    '        $TargetLogFile = Join-Path $LogDirPath "$ChannelId`_History.json"',
    '        $ChannelLogs = @()',
    '        if (Test-Path $TargetLogFile) {',
    '            $ChannelLogs = Get-Content $TargetLogFile -Raw | ConvertFrom-Json',
    '        }',
    '        ',
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

# ۴. تولید فایل تاریخچه محلی (Local History)
$SHA256 = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash

$History = [ordered]@{
    Command       = "CMD_095"
    Version       = "1.0.0"
    Status        = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output        = $ModuleFile
    SHA256        = $SHA256
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_095_HISTORY_$Time.json" -Encoding UTF8

# ۵. تولید گزارش محلی (Local Report)
$Report = @"
==================================================
NASRIUM BUILD REPORT
==================================================
COMMAND : CMD_095
STATUS  : SUCCESS
DOMAIN  : Chat (Module Build)

MODULE CREATED
--------------
$ModuleFile

SHA256 HASH
-----------
$SHA256

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
==================================================
"@
$Report | Set-Content "$ReportDir\CMD_095_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_095 SUCCESS: Module Built Successfully" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
