# ================================================================================
# NASRIUM
# CMD_096_REGISTER_CHAT_SERVICE
# STEP 001 - FINAL
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$StateFile = "$Root\Core\Knowledge\PROJECT_STATE.json"
$MasterHistoryFile = "$Root\Core\Knowledge\PROJECT_MASTER_HISTORY.json"
$ModuleFile = "$Root\Core\Modules\NSM_ChatService.psm1"
$BackupDir = "$Root\Backups"
$HistoryDir = "$Root\Builder\History"
$ReportDir = "$Root\Builder\Reports"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# ۱. گیت منطقی: مطمئن شویم فایل ماژول در مرحله قبل ساخته شده است
if (!(Test-Path $ModuleFile)) {
    Write-Error "Gate Violation: NSM_ChatService.psm1 does not exist. Execute CMD_095 first."
    exit 1
}

# ۲. ایجاد پشتیبان از اسناد حاکمیتی قبل از تغییر
if (Test-Path $StateFile) {
    Copy-Item $StateFile "$BackupDir\PROJECT_STATE_$Time.json.bak" -Force
}
if (Test-Path $MasterHistoryFile) {
    Copy-Item $MasterHistoryFile "$BackupDir\PROJECT_MASTER_HISTORY_$Time.json.bak" -Force
}

# ۳. به‌روزرسانی پروژه در PROJECT_STATE.json
if (Test-Path $StateFile) {
    $State = Get-Content $StateFile -Raw | ConvertFrom-Json
    $State.LastCommand = "CMD_096_REGISTER_CHAT_SERVICE"
    $State.LastCommandStatus = "SUCCESS"
    $State.LastCommandTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $State.NextCommand = "CMD_097"
    $State.ProgressPercent = 18

    # انتقال ایمن از در حال توسعه به تکمیل‌شده
    if ($State.InProgressModules -contains "Chat System") {
        $State.InProgressModules = $State.InProgressModules | Where-Object { $_ -ne "Chat System" }
    }
    if (!($State.CompletedModules -contains "Chat System")) {
        $State.CompletedModules += "Chat System"
    }

    $State | ConvertTo-Json -Depth 20 | Set-Content $StateFile -Encoding UTF8 -Force
}

# ۴. به‌روزرسانی پروژه در PROJECT_MASTER_HISTORY.json
if (Test-Path $MasterHistoryFile) {
    $MasterHistory = Get-Content $MasterHistoryFile -Raw | ConvertFrom-Json
    
    if ($null -eq $MasterHistory.PSObject.Properties['Commands'] -or $null -eq $MasterHistory.Commands) {
        $MasterHistory = Add-Member -InputObject $MasterHistory -NotePropertyName "Commands" -NotePropertyValue @() -PassThru -Force
    }

    # ثبت رکورد برای CMD_095
    $Record095 = [ordered]@{
        CMD = "CMD_095"
        Name = "BUILD_CHAT_SERVICE_MODULE"
        Domain = "Chat"
        Category = "CoreService"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "ساخت ماژول مستقل سرویس چت شامل توابع کانال‌سازی و ارسال پیام"
    }

    # ثبت رکورد برای CMD_096
    $Record096 = [ordered]@{
        CMD = "CMD_096"
        Name = "REGISTER_CHAT_SERVICE"
        Domain = "Core"
        Category = "Registration"
        Version = "1.0.0"
        Status = "SUCCESS"
        ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Description = "ثبت و یکپارچه‌سازی ماژول سرویس چت در اسناد حاکمیتی و افزایش درصد پیشرفت پروژه به ۱۸٪"
    }

    $CommandsList = [System.Collections.ArrayList]@($MasterHistory.Commands)
    
    # جلوگیری از تکرار رکوردها در صورت اجرای مجدد (Idempotency)
    $ExistingCMDs = $CommandsList | ForEach-Object { $_.CMD }
    if (!($ExistingCMDs -contains "CMD_095")) { [void]$CommandsList.Add($Record095) }
    if (!($ExistingCMDs -contains "CMD_096")) { [void]$CommandsList.Add($Record096) }
    
    $MasterHistory.Commands = $CommandsList
    $MasterHistory | ConvertTo-Json -Depth 20 | Set-Content $MasterHistoryFile -Encoding UTF8 -Force
}

# ۵. تولید فایل تاریخچه محلی (Local History)
$History = [ordered]@{
    Command       = "CMD_096"
    Version       = "1.0.0"
    Status        = "SUCCESS"
    ExecutionTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Output        = @($StateFile, $MasterHistoryFile)
}
$History | ConvertTo-Json -Depth 20 | Set-Content "$HistoryDir\CMD_096_HISTORY_$Time.json" -Encoding UTF8

# ۶. تولید گزارش محلی (Local Report)
$Report = @"
==================================================
NASRIUM BUILD REPORT
==================================================
COMMAND : CMD_096
STATUS  : SUCCESS
DOMAIN  : Core (Registration)

UPDATED ARCHITECTURE DOCUMENTS
------------------------------
1. $StateFile
2. $MasterHistoryFile

NEW BACKUPS CREATED IN
----------------------
$BackupDir

TIME
----
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
==================================================
"@
$Report | Set-Content "$ReportDir\CMD_096_REPORT_$Time.txt" -Encoding UTF8

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_096 SUCCESS: Core Registration Completed" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
