# ================================================================================
# NASRIUM PROJECT
# CMD_093_BUILD_CHAT_MODERATION_ENGINE
# STEP 003 - REVISED (STRICT PROPERTY VALIDATION)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$SchemaFile = "$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"
$ModuleDir = "$Root\Core\Modules"
$ModuleFile = "$ModuleDir\NSM_ChatModerator.psm1"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$StateFile = "$Root\Core\Knowledge\PROJECT_STATE.json"
$MasterHistoryFile = "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# . ساخت پوشه‌ها در صورت عدم وجود
if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
if (!(Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
if (!(Test-Path $HistoryDir)) { New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null }
if (!(Test-Path $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }

# . ایجاد پشتیبان در صورت وجود فایل ماژول قدیمی (Idempotency)
if (Test-Path $ModuleFile) {
    $BackupFile = "$BackupDir\NSM_ChatModerator_$Time.psm1.bak"
    Copy-Item $ModuleFile $BackupFile -Force
}

# . ایجاد سورس‌کد ماژول با آرایه‌ای از رشته‌ها جهت جلوگیری از تداخل مفسر
$ModuleLines = @(
    '# ================================================================================',
    '# NASRIUM CHAT MODERATOR MODULE',
    '# ================================================================================',
    'function Initialize-NSMChatModerator {',
    '    [CmdletBinding()]',
    '    param ([Parameter(Mandatory=$true)][string]$SchemaPath)',
    '    process {',
    '        if (!(Test-Path $SchemaPath)) {',
    '            throw "Schema file not found: $SchemaPath"',
    '        }',
    '        $global:NSM_ChatSchema = Get-Content $SchemaPath -Raw | ConvertFrom-Json',
    '        Write-Verbose "NASRIUM Chat Moderator initialized successfully."',
    '    }',
    '}',
    '',
    'function Test-NSMChatMessage {',
    '    [CmdletBinding()]',
    '    param (',
    '        [Parameter(Mandatory=$true)][string]$Message,',
    '        [Parameter(Mandatory=$true)][string]$UserId',
    '    )',
    '    process {',
    '        if (!$global:NSM_ChatSchema) {',
    '            throw "Moderator engine is not initialized. Run Initialize-NSMChatModerator first."',
    '        }',
    '        $Result = [ordered]@{',
    '            IsValid = $true',
    '            Reason  = "APPROVED"',
    '            Message = $Message',
    '        }',
    '        if ($Message.Length -gt $global:NSM_ChatSchema.MaxMessageLength) {',
    '            $Result.IsValid = $false',
    '            $Result.Reason = "MESSAGE_TOO_LONG"',
    '            return [PSCustomObject]$Result',
    '        }',
    '        foreach ($Word in $global:NSM_ChatSchema.BlockedWords) {',
    '            if ($Message -match "\b$([regex]::Escape($Word))\b" -or $Message -like "*$Word*") {',
    '                $Result.IsValid = $false',
    '                $Result.Reason = "CONTAIN_BLOCKED_WORDS"',
    '                return [PSCustomObject]$Result',
    '            }',
    '        }',
    '        return [PSCustomObject]$Result',
    '    }',
    '}',
    '',
    'Export-ModuleMember -Function Initialize-NSMChatModerator, Test-NSMChatMessage'
)

$ModuleCode = $ModuleLines -join "`r`n"
$ModuleCode | Set-Content $ModuleFile -Encoding UTF8 -Force

# . آپدیت خودکار STATE پروژه (SDPA Compliant)
if (Test-Path $StateFile) {
    $State = Get-Content $StateFile -Raw | ConvertFrom-Json
    $State.LastCommand = "CMD_093_BUILD_CHAT_MODERATION_ENGINE"
    $State.LastCommandStatus = "SUCCESS"
    $State.LastCommandTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $State.NextCommand = "CMD_094"
    $State.ProgressPercent = 15
    
    if ($State.InProgressModules -contains "Chat Moderation Engine") {
        $State.InProgressModules = $State.InProgressModules | Where-Object { $_ -ne "Chat Moderation Engine" }
    }
    if (!($State.CompletedModules -contains "Chat Moderation Engine")) {
        $State.CompletedModules += "Chat Moderation Engine"
    }

    $State | ConvertTo-Json -Depth 20 | Set-Content $StateFile -Encoding UTF8 -Force
}

# . آپدیت تاریخچه جامع MASTER_HISTORY با اعتبارسنجی ساختار
if (Test-Path $MasterHistoryFile) {
    $MasterHistory = Get-Content $MasterHistoryFile -Raw | ConvertFrom-Json
    
    # بازسازی کلید Commands در صورت عدم وجود به دلیل خطای قبلی دیسک فیزیکی
    if ($null -eq $MasterHistory.PSObject.Properties['Commands'] -or $null -eq $MasterHistory.Commands) {
        $MasterHistory = Add-Member -InputObject $MasterHistory -NotePropertyName "Commands" -NotePropertyValue @() -PassThru -Force
    }

    $NewCommand = [ordered]@{
        CMD = "CMD_093"
        Name = "BUILD_CHAT_MODERATION_ENGINE"
        Domain = "Chat"
        Category = "Security"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "پیاده‌سازی ماژول عملیاتی موتور تعدیل چت و سیستم فیلترینگ پیام‌ها بر اساس مدل JSON"
    }

    # اضافه کردن به صورت امن
    $CommandsList = [System.Collections.ArrayList]@($MasterHistory.Commands)
    [void]$CommandsList.Add($NewCommand)
    $MasterHistory.Commands = $CommandsList

    $MasterHistory | ConvertTo-Json -Depth 20 | Set-Content $MasterHistoryFile -Encoding UTF8 -Force
}

# . تولید فایل History محلی و گزارش نهایی (Report)
$SHA256 = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash

$History = [ordered]@{
    Command = "CMD_093"
    Version = "1.0.0"
    Status = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output = $ModuleFile
    SHA256 = $SHA256
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_093_HISTORY_$Time.json" -Encoding UTF8

$Report = @"
==================================================
NASRIUM BUILD REPORT
==================================================
COMMAND : CMD_093
STATUS  : SUCCESS
DOMAIN  : Chat (Security Engine)

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
$Report | Set-Content "$ReportDir\CMD_093_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_093 SUCCESS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Exit 0
