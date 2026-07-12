# ================================================================================
# NASRIUM
# CMD_097_TEST_CHAT_SERVICE
# STEP 004 - REVISED (STRICT-MODE SAFE RUNTIME INJECTION)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$SchemaFile = "$Root\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json"
$ModModule = "$Root\Core\Modules\NSM_ChatModerator.psm1"
$ChatModule = "$Root\Core\Modules\NSM_ChatService.psm1"
$TestLogDir = "$Root\Data\Systems\Chat\Logs"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "Starting Integration Tests with Strict-Mode Safe Injection..." -ForegroundColor Cyan

# ۱. گیت منطقی: اعتبارسنجی وجود فایل‌های پیش‌نیاز
if (!(Test-Path $SchemaFile)) { throw "Missing required schema file: $SchemaFile" }
if (!(Test-Path $ModModule)) { throw "Missing required moderator module: $ModModule" }
if (!(Test-Path $ChatModule)) { throw "Missing required chat service module: $ChatModule" }

# ۲. بارگذاری ماژول‌ها در جلسه فعلی (Runtime Import)
Import-Module $ModModule -Force
Import-Module $ChatModule -Force

# ۳. مقداردهی اولیه موتور تعدیل پیام
Initialize-NSMChatModerator -SchemaPath $SchemaFile

# ۴. تزریق فوق‌امن کلمه تستی به حافظه رم با دور زدن محدودیت Strict-Mode
$PropName = "BlockedWords"
if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["blocked_words"]) {
    $PropName = "blocked_words"
}

# اگر ویژگی اصلاً در شیء وجود ندارد، آن را به صورت پویا ایجاد می‌کنیم تا خطا ندهد
if ($null -eq $global:NSM_ChatSchema.PSObject.Properties[$PropName]) {
    $global:NSM_ChatSchema = Add-Member -InputObject $global:NSM_ChatSchema -NotePropertyName $PropName -NotePropertyValue @() -PassThru -Force
}

# دریافت لیست کلمات و افزودن کلمه تستی به صورت کاملاً امن
$CurrentWords = [System.Collections.ArrayList]@()
$ExistingWords = $global:NSM_ChatSchema.$PropName
if ($null -ne $ExistingWords) {
    foreach ($W in $ExistingWords) {
        [void]$CurrentWords.Add($W)
    }
}

if ($CurrentWords -notcontains "test_spam") {
    [void]$CurrentWords.Add("test_spam")
}

# بازنویسی فیلد در حافظه رم با مقدار جدید حاوی کلمه تستی
$global:NSM_ChatSchema.$PropName = $CurrentWords | ForEach-Object { $_ }
$SampleBlockedWord = "test_spam"

# استخراج طول مجاز پیام به صورت ایمن و بدون خطا در Strict Mode
$MaxLen = 100
if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["MaxMessageLength"]) {
    $MaxLen = $global:NSM_ChatSchema.MaxMessageLength
} elseif ($null -ne $global:NSM_ChatSchema.PSObject.Properties["max_message_length"]) {
    $MaxLen = $global:NSM_ChatSchema.max_message_length
}

# ۵. ایجاد کانال تستی
$Channel = New-NSMChatChannel -ChannelName "GlobalTest" -ChannelType "Global"
$ChannelId = $Channel.ChannelId

# ۶. اجرای تست‌کیس‌ها
$TestResults = @()

# --- تست ۱: ارسال پیام مجاز و سالم ---
$Test1Msg = "This is a clean and safe message for NASRIUM system."
$Res1 = Send-NSMChatMessage -ChannelId $ChannelId -UserId "USER_01" -Message $Test1Msg -LogDirPath $TestLogDir
$TestResults += [ordered]@{
    TestCase = "1_APPROVED_MESSAGE"
    Expected = "SUCCESS"
    Actual   = $Res1.Status
    Pass     = ($Res1.Status -eq "SUCCESS")
}

# --- تست ۲: ارسال پیام بسیار طولانی ---
$Test2Msg = "A" * ($MaxLen + 10)
$Res2 = Send-NSMChatMessage -ChannelId $ChannelId -UserId "USER_01" -Message $Test2Msg -LogDirPath $TestLogDir
$TestResults += [ordered]@{
    TestCase = "2_MAX_LENGTH_VIOLATION"
    Expected = "REJECTED"
    Actual   = $Res2.Status
    Pass     = ($Res2.Status -eq "REJECTED" -and $Res2.Reason -eq "MESSAGE_TOO_LONG")
}

# --- تست ۳: ارسال پیام حاوی کلمه ممنوعه تزریق شده به رم ---
$Test3Msg = "Attention! This message contains test_spam which is forbidden."
$Res3 = Send-NSMChatMessage -ChannelId $ChannelId -UserId "USER_01" -Message $Test3Msg -LogDirPath $TestLogDir
$TestResults += [ordered]@{
    TestCase = "3_BLOCKED_WORD_VIOLATION"
    Expected = "REJECTED"
    Actual   = $Res3.Status
    Pass     = ($Res3.Status -eq "REJECTED" -and $Res3.Reason -eq "CONTAIN_BLOCKED_WORDS")
}

# ۷. تحلیل نهایی نتایج تست
$AllPassed = $true
$TestSummary = ""
foreach ($Result in $TestResults) {
    $StatusText = if ($Result.Pass) { "PASS" } else { "FAIL"; $AllPassed = $false }
    $TestSummary += "Test Case: $($Result.TestCase) -> Expected: $($Result.Expected) | Actual: $($Result.Actual) | Result: $StatusText`r`n"
}

# ۸. تولید فایل تاریخچه محلی (Local History)
$History = [ordered]@{
    Command       = "CMD_097"
    Version       = "1.0.0"
    Status        = if ($AllPassed) { "SUCCESS" } else { "FAILED" }
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Results       = $TestResults
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_097_HISTORY_$Time.json" -Encoding UTF8

# ۹. تولید گزارش محلی (Local Report)
$Report = @"
==================================================
NASRIUM BUILD REPORT - INTEGRATION TESTS
==================================================
COMMAND : CMD_097
STATUS  : $(if ($AllPassed) { "SUCCESS" } else { "FAILED" })
DOMAIN  : Chat (Testing Pipeline)

TEST SUMMARY:
--------------------------------------------------
$TestSummary
==================================================
"@
$Report | Set-Content "$ReportDir\CMD_097_REPORT_$Time.txt" -Encoding UTF8

# ۱۰. نمایش نتایج در کنسول
Write-Host ""
if ($AllPassed) {
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "CMD_097 SUCCESS: All Tests Passed (3/3)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host $TestSummary -ForegroundColor Gray
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
} else {
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host "CMD_097 FAILED: Some Integration Tests Failed" -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host $TestSummary -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
