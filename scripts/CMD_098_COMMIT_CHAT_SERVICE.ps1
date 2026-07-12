# ================================================================================
# NASRIUM
# CMD_098_COMMIT_CHAT_SERVICE
# STEP 001 - FINAL
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$StateFile = "$Root\Core\Knowledge\PROJECT_STATE.json"
$MasterHistoryFile = "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "Committing Chat Service Pipeline..." -ForegroundColor Cyan

# ۱. گیت منطقی: مطمئن شویم که تست‌های یکپارچگی در مرحله قبل با موفقیت ثبت شده‌اند
$LastTestHistory = Get-ChildItem -Path $HistoryDir -Filter "CMD_097_HISTORY_*.json" | 
                   Sort-Object LastWriteTime -Descending | 
                   Select-Object -First 1

if ($null -eq $LastTestHistory) {
    throw "Gate Violation: No test history found for CMD_097. Run tests first."
}

$TestData = Get-Content $LastTestHistory.FullName -Raw | ConvertFrom-Json
if ($TestData.Status -ne "SUCCESS") {
    throw "Gate Violation: Integration tests did not pass. Cannot commit."
}

# ۲. ایجاد نسخه پشتیبان از اسناد قبل از اعمال تغییرات نهایی
if (Test-Path $StateFile) {
    Copy-Item $StateFile "$BackupDir\PROJECT_STATE_PreCommit_$Time.json.bak" -Force
}
if (Test-Path $MasterHistoryFile) {
    Copy-Item $MasterHistoryFile "$BackupDir\PROJECT_MASTER_HISTORY_PreCommit_$Time.json.bak" -Force
}

# ۳. به‌روزرسانی وضعیت پروژه در PROJECT_STATE.json
if (Test-Path $StateFile) {
    $State = Get-Content $StateFile -Raw | ConvertFrom-Json
    $State.LastCommand = "CMD_098_COMMIT_CHAT_SERVICE"
    $State.LastCommandStatus = "SUCCESS"
    $State.LastCommandTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $State.NextCommand = "CMD_100" # آماده‌سازی برای آغاز فاز و دامنه جدید
    $State.ProgressPercent = 20 # افزایش میزان پیشرفت فیزیکی پروژه به ۲۰٪

    $State | ConvertTo-Json -Depth 20 | Set-Content $StateFile -Encoding UTF8 -Force
}

# ۴. ثبت رکوردهای نهایی در PROJECT_MASTER_HISTORY.json
if (Test-Path $MasterHistoryFile) {
    $MasterHistory = Get-Content $MasterHistoryFile -Raw | ConvertFrom-Json
    
    if ($null -eq $MasterHistory.PSObject.Properties['Commands'] -or $null -eq $MasterHistory.Commands) {
        $MasterHistory = Add-Member -InputObject $MasterHistory -NotePropertyName "Commands" -NotePropertyValue @() -PassThru -Force
    }

    $Record097 = [ordered]@{
        CMD = "CMD_097"
        Name = "TEST_CHAT_SERVICE"
        Domain = "Chat"
        Category = "Testing"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "اجرای موفقیت‌آمیز تست‌های یکپارچگی سه‌گانه روی موتور تعدیل و سرویس چت"
    }

    $Record098 = [ordered]@{
        CMD = "CMD_098"
        Name = "COMMIT_CHAT_SERVICE"
        Domain = "Core"
        Category = "Commit"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "بستن رسمی فاز سیستم چت و تعدیل محتوا و ارتقای پیشرفت فیزیکی به ۲۰٪"
    }

    $CommandsList = [System.Collections.ArrayList]@($MasterHistory.Commands)
    
    # جلوگیری از ثبت تکراری
    $ExistingCMDs = $CommandsList | ForEach-Object { $_.CMD }
    if (!($ExistingCMDs -contains "CMD_097")) { [void]$CommandsList.Add($Record097) }
    if (!($ExistingCMDs -contains "CMD_098")) { [void]$CommandsList.Add($Record098) }
    
    $MasterHistory.Commands = $CommandsList
    $MasterHistory | ConvertTo-Json -Depth 20 | Set-Content $MasterHistoryFile -Encoding UTF8 -Force
}

# ۵. تولید فایل تاریخچه محلی (Local History)
$History = [ordered]@{
    Command       = "CMD_098"
    Version       = "1.0.0"
    Status        = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output        = @($StateFile, $MasterHistoryFile)
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_098_HISTORY_$Time.json" -Encoding UTF8

# ۶. تولید گزارش نهایی این فاز (Local Report)
$Report = @"
==================================================
NASRIUM COMMIT REPORT - CHAT SYSTEM PHASE
==================================================
COMMAND : CMD_098
STATUS  : SUCCESS
DOMAIN  : Core (Commit)

SUMMARY:
--------------------------------------------------
The Chat and Content Moderation subsystem is now
officially completed, tested, and locked.

All integration tests passed successfully (3/3).
Project progress updated to 20%.

UPDATED DOCUMENTS:
--------------------------------------------------
1. $StateFile
2. $MasterHistoryFile

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
==================================================
"@
$Report | Set-Content "$ReportDir\CMD_098_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_098 SUCCESS: Chat Phase Officially Closed!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
