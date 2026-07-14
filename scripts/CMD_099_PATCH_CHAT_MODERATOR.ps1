# ================================================================================
# NASRIUM
# CMD_099_PATCH_CHAT_MODERATOR
# STEP 002 - FINAL REVISED (UNICODE COMPATIBLE MATCHING)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$ModuleDir = "$Root\Core\Modules"
$ModuleFile = "$ModuleDir\NSM_ChatModerator.psm1"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$StateFile = "$Root\Core\Knowledge\PROJECT_STATE.json"
$MasterHistoryFile = "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# ۱. پشتیبان‌گیری
if (Test-Path $ModuleFile) {
    Copy-Item $ModuleFile "$BackupDir\NSM_ChatModerator_UnicodeBroken_$Time.psm1.bak" -Force
}

# ۲. ایجاد سورس‌کد ماژول با پشتیبانی کامل از کاراکترهای فارسی و یونیکد
$ModuleLines = @(
    '# ================================================================================',
    '# NASRIUM CHAT MODERATOR MODULE (PATCHED v1.2 - UNICODE COMPATIBLE)',
    '# ================================================================================',
    'function Initialize-NSMChatModerator {',
    '    [CmdletBinding()]',
    '    param ([Parameter(Mandatory=$true)][string]$SchemaPath)',
    '    process {',
    '        if (!(Test-Path $SchemaPath)) {',
    '            throw "Schema file not found: $SchemaPath"',
    '        }',
    '        $global:NSM_ChatSchema = Get-Content $SchemaPath -Raw | ConvertFrom-Json',
    '        Write-Verbose "NASRIUM Chat Moderator initialized successfully with Unicode Patch v1.2."',
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
    '',
    '        # تحلیل طول پیام',
    '        $MaxLen = 100',
    '        if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["MaxMessageLength"]) {',
    '            $MaxLen = $global:NSM_ChatSchema.MaxMessageLength',
    '        } elseif ($null -ne $global:NSM_ChatSchema.PSObject.Properties["max_message_length"]) {',
    '            $MaxLen = $global:NSM_ChatSchema.max_message_length',
    '        }',
    '',
    '        # استخراج کلمات ممنوعه',
    '        $Words = @()',
    '        if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["BlockedWords"]) {',
    '            $Words = $global:NSM_ChatSchema.BlockedWords',
    '        } elseif ($null -ne $global:NSM_ChatSchema.PSObject.Properties["blocked_words"]) {',
    '            $Words = $global:NSM_ChatSchema.blocked_words',
    '        }',
    '',
    '        $Result = [ordered]@{',
    '            IsValid = $true',
    '            Reason  = "APPROVED"',
    '            Message = $Message',
    '        }',
    '',
    '        # بررسی طول پیام',
    '        if ($Message.Length -gt $MaxLen) {',
    '            $Result.IsValid = $false',
    '            $Result.Reason = "MESSAGE_TOO_LONG"',
    '            return [PSCustomObject]$Result',
    '        }',
    '',
    '        # بررسی کلمات ممنوعه (پشتیبانی کامل از کاراکترهای یونیکد و فارسی بدون وابستگی به \b)',
    '        foreach ($Word in $Words) {',
    '            if ($null -ne $Word -and $Word.Trim() -ne "") {',
    '                # استفاده از متد بومی حاوی بودن رشته بدون حساسیت به حروف کوچک و بزرگ و سازگار با یونیکد',
    '                if ($Message.ToLower().Contains($Word.ToLower())) {',
    '                    $Result.IsValid = $false',
    '                    $Result.Reason = "CONTAIN_BLOCKED_WORDS"',
                    '                    return [PSCustomObject]$Result',
    '                }',
    '            }',
    '        }',
    '',
    '        return [PSCustomObject]$Result',
    '    }',
    '}',
    '',
    'Export-ModuleMember -Function Initialize-NSMChatModerator, Test-NSMChatMessage'
)

$ModuleCode = $ModuleLines -join "`r`n"
$ModuleCode | Set-Content $ModuleFile -Encoding UTF8 -Force

# ۳. تولید فایل تاریخچه محلی (Local History)
$SHA256 = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash
$History = [ordered]@{
    Command       = "CMD_099"
    Version       = "1.2.0"
    Status        = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output        = $ModuleFile
    SHA256        = $SHA256
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_099_HISTORY_$Time.json" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_099 UNICODE HOTFIX APPLIED" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
