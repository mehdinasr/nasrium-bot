# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000
# File ID   : CMD_000_VISUALIZER
# Module    : System | Observer
# Component : Project Branch Diagram Generator
# Version   : 1.0.1 (Fixed)
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Invoke-CMD_000_VisualMapper {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM VISUAL SYSTEM MAPPER" -ForegroundColor Cyan
    Write-Host "Command   : CMD_000 (System Utility)" -ForegroundColor Yellow
    Write-Host "Task      : Generate Directory & Command Tree" -ForegroundColor DarkGray
    Write-Host "=========================================" -ForegroundColor Cyan

    # --- Configuration ---
    $RootPath = "D:\NASRIUM"
    
    # طبق قانون v3.1.0: مسیرهای استاندارد
    $Dir_Reports = Join-Path $RootPath "Builder\Reports"
    $Dir_History = Join-Path $RootPath "Builder\History"
    
    # بررسی وجود و ایجاد پوشه‌ها (ایمنی)
    if (!(Test-Path $RootPath)) { throw "FATAL: Root path not found." }
    
    # --- FIX APPLIED HERE: Added missing closing brace '}' for ForEach-Object ---
    @($Dir_Reports, $Dir_History) | ForEach-Object { 
        if (!(Test-Path $_)) { 
            New-Item -ItemType Directory -Path $_ -Force | Out-Null 
        }
    }

    # --- Logic Engine ---
    Write-Host "[CMD_000] Scanning Physical Disk..." -ForegroundColor Cyan
    
    $TreeLines = [System.Collections.Generic.List[string]]::new()
    $TreeLines.Add("NASRIUM BRANCH DIAGRAM - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
    $TreeLines.Add("")

    # تابع بازگشتی برای ساخت درخت
    function Build-TreeString {
        param([string]$Path, [string]$Prefix = "", [bool]$IsLast = $true)
        
        $ObjName = Split-Path $Path -Leaf
        
        # استفاده از کاراکترهای ASCII برای زیبایی
        if ($IsLast) { $Connector = "`u{2514}`u{2500}`u{2500} " } else { $Connector = "`u{251C}`u{2500}`u{2500} " }
        
        # تشخیص نوع فایل بر اساس الگو
        $Tag = ""
        if ($ObjName -match "^CMD_00[0-9]") { $Tag = "[SYS TOOL]" }     
        elseif ($ObjName -match "^CMD_\d+") { $Tag = "[GAME LOGIC]" }   
        elseif ($ObjName -match "\.psm1") { $Tag = "[MODULE]" }
        elseif ($ObjName -match "\.json") { $Tag = "[DATA]" }

        $Meta = ""
        if (!(Test-Path $Path -PathType Container)) { 
            try { $Meta = " ($(Get-Item $Path).Length B)" } catch {} 
        }

        $TreeLines.Add("$Prefix$Connector$ObjName $Tag$Meta")

        if (Test-Path $Path -PathType Container) {
            $Children = Get-ChildItem $Path -ErrorAction SilentlyContinue | Sort-Object Name
            $Count = $Children.Count
            for ($i = 0; $i -lt $Count; $i++) {
                $IsLastC = ($i -eq ($Count - 1))
                # تنظیم پیشوند برای زیرشاخه‌ها
                if ($IsLast) { $NewPrefix = "$Prefix    " } else { $NewPrefix = "$Prefix|   " }
                Build-TreeString -Path $Children[$i].FullName -Prefix $NewPrefix -IsLast $IsLastC
            }
        }
    }

    # شروع پردازش از ریشه
    Build-TreeString -Path $RootPath

    # --- خروجی و ذخیره ---
    $TS = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $ReportFile = Join-Path $Dir_Reports "TREE_MAP_$TS.txt"

    try {
        [System.IO.File]::WriteAllText($ReportFile, ($TreeLines -join "`r`n"), (New-Object System.Text.UTF8Encoding $false))
        Write-Host "  [OK] Map Generated." -ForegroundColor Green
        
        # نمایش خلاصه در کنسول
        $TreeLines | Select-Object -First 30 | ForEach-Object { Write-Host $_ }
        Write-Host "..." -ForegroundColor Gray
        Write-Host "Full report saved to: $ReportFile" -ForegroundColor DarkGray
    } catch {
        throw "Write Error: $_"
    }

    # --- ثبت تاریخچه (Audit Trail v3.1.0) ---
    Write-Host "[CMD_000] Saving History..." -ForegroundColor Cyan
    $HistData = @{
        cmd_id = "CMD_000_VISUALIZER"
        timestamp = $TS
        output_path = $ReportFile
        status = "SUCCESS"
    } | ConvertTo-Json
    
    $HistFile = Join-Path $Dir_History "HIST_CMD000_$TS.json"
    [System.IO.File]::WriteAllText($HistFile, $HistData)

    # --- پایان استاندارد ---
    Write-Host ""
    if (Test-Path $ReportFile) {
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "   CMD_000 UTILITY COMPLETE" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
        Write-Host "OK_CMD_000_COMPLETE" -ForegroundColor Green
    }
}

# --- Execute ---
Invoke-CMD_000_VisualMapper
