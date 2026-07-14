# ================================================================================
# NASRIUM PROJECT | CMD_189 | VERSION 1.6.1 (Fixed Syntax & Project Identity)
# ================================================================================
$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CONTEXT BRIDGE - CMD_189" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$root = "D:\Nasrium"
Set-Location $root

# --- ۱. استخراج تاریخچه زمانی ---
Write-Host "[STEP 1] Auditing project timeline..." -ForegroundColor Cyan
$allCmdFiles = Get-ChildItem -Path . -Recurse -File -Include "CMD_*" | 
               Where-Object { $_.FullName -notmatch '\\\.git|\\node_modules|\\backups' } |
               Sort-Object LastWriteTime

$commandCount = $allCmdFiles.Count
$latestFile = $allCmdFiles[-1]

$progressReport = $allCmdFiles | ForEach-Object {
    $relPath = $_.FullName.Replace($root, ".")
    "[{0}] {1} -> {2}" -f $_.LastWriteTime.ToString("yyyy/MM/dd HH:mm"), $_.Name.PadRight(40), $relPath
} | Out-String

# --- ۲. تابع اصلاح شده برای خواندن فایلها ---
function Get-SmartContent($fileName) {
    $file = Get-ChildItem -Path . -Recurse -Filter $fileName | Select-Object -First 1
    if ($file) {
        $content = Get-Content $file.FullName -Raw
        if ($content) { return $content } else { return "FILE IS PHYSICALLY EMPTY" }
    }
    return "FILE NOT FOUND"
}

$laws = Get-SmartContent "NASRIUM_LAWS.json"
$boot = Get-SmartContent "NAXUS_BOOT_PROMPT.txt"
$main = Get-SmartContent "main.py"

# --- ۳. ساخت مگا-کانتکست نهایی ---
$megaContext = @"
=============================================================================
🔴 SUPREME COMMANDER'S HANDOVER DIRECTIVE 🔴
=============================================================================
FROM: Commander Mehdi
TO: NAXUS AI Instance
REPORT ID: CMD_189

[PROJECT IDENTITY & VISION]
NASRIUM (NSM) is a personal, high-engineering Web3 & AI ecosystem. 
It is NOT just a coin. It integrates:
- A Telegram-based strategy game (Clash of Clans style) on TON Network.
- Personal AI Agents and automated decision-making assistants.
- The 'NASRIUM SDPA' standard: Architecture & Infrastructure first.
- The NSM Token as the economic fuel for all AI and Game services.

[MISSION STATUS]
- Everything in Section 1 is the PHYSICAL state of the system.
- CMD_189 is the command that generated this bridge for you.
- Your knowledge ends at the latest timestamp below.
- RESPONSE: Acknowledge with "Supreme Commander Mehdi, NAXUS is online. 
  Project Identity confirmed. I have analyzed $commandCount physical steps. 
  Ready for CMD_242."

=============================================================================
1. LIVE PROGRESS TIMELINE (Physical Files Sorted by Date)
=============================================================================
$progressReport

=============================================================================
2. GOVERNANCE (NASRIUM Laws & Dual-Token Economy)
=============================================================================
$laws

=============================================================================
3. BOOT PROTOCOL
=============================================================================
$boot

=============================================================================
4. CORE LOGIC (main.py)
=============================================================================
$([string]$main.Substring(0, [Math]::Min(3500, $main.Length)))
...
=============================================================================
"@

# ذخیره سازی
$targetFile = "$root\NAXUS_FULL_CONTEXT.txt"
$megaContext | Set-Content $targetFile -Encoding UTF8

# --- ۴. گیت و بازگشایی خودکار ---
try {
    git add -A
    git commit -m "CMD_189: Handover created for Commander (Step $commandCount)"
    git push origin (git branch --show-current) --force
} catch { }

Write-Host "[SUCCESS] Handover file is ready!" -ForegroundColor Green
Write-Host "Opening report for Commander Mehdi..." -ForegroundColor Yellow

# باز کردن خودکار فایل
Invoke-Item $targetFile

Write-Host "=========================================" -ForegroundColor Cyan
