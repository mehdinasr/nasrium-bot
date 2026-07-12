$ErrorActionPreference = "Stop"
$stageId = "CMD_026_MASTER_VIEW"

$root = "D:\NASRIUM"
$knowledge = "D:\NASRIUM\Core\Knowledge"
$logs = "D:\NASRIUM\Core\Logs"
$outputFile = Join-Path $knowledge "PROJECT_MASTER_HISTORY.json"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NASRIUM - CMD_026_MASTER_VIEW (Scan, Write & Open)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ۱. اسکن دایرکتوری‌ها و فایل‌ها
Write-Host "⏳ در حال اسکن کامل دیسک و محاسبه هش فایل‌ها..." -ForegroundColor Yellow

$folders = Get-ChildItem $root -Directory -Recurse -Force
$files = Get-ChildItem $root -File -Recurse -Force

$folderList = @()
foreach($f in $folders){
    $folderList += [ordered]@{
        name      = $f.Name
        full_path = $f.FullName
        created   = $f.CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
        modified  = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    }
}

$fileList = @()
foreach($f in $files){
    $hash = ""
    if ($f.Length -lt 10MB) {
        try { $hash = (Get-FileHash $f.FullName -Algorithm SHA256).Hash } catch { $hash = "N/A" }
    } else {
        $hash = "SKIPPED_LARGE_FILE"
    }

    $fileList += [ordered]@{
        name       = $f.Name
        extension  = $f.Extension
        size_bytes = $f.Length
        full_path  = $f.FullName
        modified   = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        sha256     = $hash
    }
}

Write-Host "✅ اسکن فایل‌ها با موفقیت انجام شد." -ForegroundColor Green

# ۲. تعریف تاریخچه روند و دستورات پروژه
$completedCommands = @(
    [ordered]@{ id="CMD_010"; title="NOS Core Initialization"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد پوشه‌های اصلی Core، فایل مغز پروژه NASRIUM_CONTEXT.json و سند AI_HANDOVER" },
    [ordered]@{ id="CMD_011"; title="NOS Tool Creation"; date="2026-07-07"; status="SUCCESS"; desc="طراحی ابزار اصلی مدیریت پروژه nos.ps1 با قابلیت‌های status, backup, export" },
    [ordered]@{ id="CMD_012"; title="TypeScript Bot Scaffold"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد کالبد و ساختار ماژولار ربات تلگرام با فریمورک grammY و TypeScript" },
    [ordered]@{ id="CMD_013"; title="Secure Bot Configuration"; date="2026-07-07"; status="SUCCESS"; desc="راه‌اندازی متد Token File برای ذخیره امن توکن‌ها و اجرای ربات در پس‌زمینه" },
    [ordered]@{ id="CMD_015"; title="Storage Infrastructure"; date="2026-07-07"; status="SUCCESS"; desc="ساخت پوشه‌های Saves، Templates و Schemas برای سیستم‌عامل ذخیره‌سازی پروژه" },
    [ordered]@{ id="CMD_016"; title="AI Project State"; date="2026-07-07"; status="SUCCESS"; desc="تولید نسخه اول از حافظه هوش مصنوعی با ساختار ۱۲ بخشی برای ثبت وضعیت" },
    [ordered]@{ id="CMD_017"; title="First Checkpoint"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد اولین نقطه بازگشت CP_000001 به همراه فایل CHECKPOINT_INFO.json" },
    [ordered]@{ id="CMD_018_RECOVERY"; title="System Recovery"; date="2026-07-07"; status="SUCCESS"; desc="بازگرداندن فایل nos.ps1 به نسخه پایدار و پیشگیری از ناپایداری‌های ناشی از وصله کدهای بزرگ" },
    [ordered]@{ id="CMD_019"; title="Builder Structure"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد ساختار اولیه کارخانه کدنویسی یا NASRIUM Builder" },
    [ordered]@{ id="CMD_020"; title="Builder State Engine"; date="2026-07-07"; status="SUCCESS"; desc="طراحی موتور مرکزی برای ردیابی شماره دستورات، Checkpointها و ADRها" },
    [ordered]@{ id="CMD_021"; title="Project Dashboard"; date="2026-07-07"; status="SUCCESS"; desc="طراحی داشبورد فیزیکی پروژه PROJECT_DASHBOARD.json جهت مانیتورینگ سلامت سیستم" },
    [ordered]@{ id="CMD_022A"; title="SaveManager Module"; date="2026-07-07"; status="SUCCESS"; desc="طراحی مقدماتی اولین ماژول ذخیره و بسته‌بندی فایل‌های پروژه" },
    [ordered]@{ id="CMD_022B"; title="System Context V2"; date="2026-07-07"; status="SUCCESS"; desc="ارتقای ساختار فایل توصیفی وضعیت پروژه به نسخه ۲.۰" },
    [ordered]@{ id="CMD_022C"; title="Master Project Brain V2"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد فایل جامع MASTER_PROJECT.json به عنوان شناسنامه بقای پروژه در چت‌های جدید" },
    [ordered]@{ id="CMD_022_V3"; title="Master Project Brain V3"; date="2026-07-07"; status="SUCCESS"; desc="ارتقا به نسخه سوم حافظه پروژه به همراه افزودن متاداده‌های امنیتی و اهداف تفصیلی" },
    [ordered]@{ id="CMD_023A"; title="Player Database Schema"; date="2026-07-07"; status="SUCCESS"; desc="طراحی اولین اسکیمای دیتابیس برای ماهیت بازیکن (Player) با استانداردهای کلش" },
    [ordered]@{ id="CMD_023B"; title="Localization System (25 Languages)"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد فایل شاخص ترجمه و ۲۵ فایل JSON مجزا برای پوشش کامل کشورهای جهانی و لاتین" },
    [ordered]@{ id="CMD_023C"; title="Village Database Schema"; date="2026-07-07"; status="SUCCESS"; desc="طراحی اسکیمای پیشرفته دهکده شامل ابعاد نقشه، مختصات جهانی، تم، آب‌وهوا و سپر دفاعی" },
    [ordered]@{ id="GDD_001"; title="Game Core Design"; date="2026-07-07"; status="SUCCESS"; desc="تولید بخش اول سند طراحی بازی شامل حلقه‌های تکرار، ژانر و الهام‌بخش‌ها" },
    [ordered]@{ id="GEDD_001"; title="Game Economy Architecture"; date="2026-07-07"; status="SUCCESS"; desc="طراحی موتور تولید منابع، مدیریت تورم، تراکنش‌ها و جداسازی منابع بازی از دارایی‌های بلاکچینی" },
    [ordered]@{ id="CMD_024A"; title="Building Templates Schema"; date="2026-07-07"; status="SUCCESS"; desc="ایجاد قالب‌های استاندارد برای ۱۰ ساختمان اصلی بازی و تفکیک مقادیر تعادل از کدهای منطقی" },
    [ordered]@{ id="CMD_024B"; title="Building Instance Schema"; date="2026-07-07"; status="SUCCESS"; desc="اسکیمای نمونه‌های ساخته شده ساختمان‌ها توسط بازیکنان بر اساس ماشین وضعیت پایدار" },
    [ordered]@{ id="CMD_024C"; title="Formula Engine Schema"; date="2026-07-07"; status="SUCCESS"; desc="تعریف اسکیمای محاسباتی ارتقاء، ساخت و مبارزات بر پایه ضرایب و اصلاح‌کننده‌های رویداد" }
)

ادامه پروژه و روند اجرای دستورات هر بار با کاربرچک گردد با اینکه دستوری در پاورشل ایجاد کنید که لیست شاخه ای کل دستورات را چاپ کند و به شما گزارش کند
# ۳. ثبت قوانین کارکردی پروژه
$rules = @(
    "قانون ۱: تمام فایل‌ها و زیرشاخه‌ها باید به صورت ساختاریافته در درایو D:\NASRIUM ذخیره و نگهداری شوند تا دچار آسیب نشوند.",
    "قانون ۲: دستیار هوشمند نقش معمار و مدیر پروژه را دارد و کدهای پاورشل را به صورت اتوماتیک و مرحله‌به‌مرحله ارائه می‌دهد.",
    "قانون ۳: کاربر نقش مجری و واسطه مستقیم سیستم را برای کپی و پیست کدها در پاورشل دارد.",
    "قانون ۴: هر مرحله باید تست شود و با تایید کاربر گام بعدی برداشته شود تا خطایابی فوری میسر باشد.",
    "قانون ۵: تمام پاسخ‌ها و راهنماها باید به زبان فارسی روان، شیوا و خوانا به همراه متون انگلیسی فنی ارائه شوند.",
    "قانون ۶: پروژه باید دارای فایل گزارش و پشتیبان باشد تا در صورت مواجهه با محدودیت سقف چت، در چت جدید با ارسال یک فایل قابل بازیابی باشد.",
    "قانون ۷: تمام فایل‌های گزارش و وضعیت باید به فرمت JSON و یونیکد UTF-8 باشند تا خواندن و نوشتن خودکار آن بدون مشکل انجام شود.",
    "قانون ۸: هیچ اطلاعات حساسی مانند کلیدهای خصوصی، توکن‌های امنیتی یا پسوردها نباید در کدهای گیت یا فایل‌های متنی عمومی ذخیره شوند.",
    "قانون ۹: از هر مرحله مهم یک Checkpoint یا نقطه بازگشت فیزیکی گرفته می‌شود تا قابلیت Rollback همواره وجود داشته باشد.",
    "قانون ۱۰: اسکریپت‌ها باید به صورت تکرارپذیر (Idempotent) طراحی شوند تا اجرای چندباره آنها به ساختار پروژه آسیب نزند.",
    "قانون ۱۱: سیستم به صورت چندزبانه کامل (نامحدود با شروع ۲۵ زبان جهانی از جمله فارسی و کشورهای لاتین) پیاده‌سازی می‌شود.",
    "قانون ۱۲: معماری پروژه بر پایه تفکیک داده (Data)، منطق (Logic) و توازن (Balance) شکل می‌گیرد.",
    "قانون ۱۳: از الگوهای تفکیکی قالب و نمونه (Template / Instance) برای توسعه‌پذیری بدون تغییر کدهای هسته استفاده می‌شود.",
    "قانون ۱۴: هیچ عددی در گیم‌پلی نباید Hardcode شود؛ تمام بالانس بازی از فایل‌های پیکربندی خارج از کد خوانده می‌شود.",
    "قانون ۱۵: ساختمان‌ها و نیروها باید مجهز به ماشین وضعیت (State Machine) باشند تا قابلیت‌های ارتقا، تخریب و بازسازی به راحتی مدیریت شود."
)

# ۴. ساخت پکیج نهایی JSON
$masterOutput = [ordered]@{
    schema            = "MASTER-3.0"
    project_id        = "PRJ-000001"
    name              = "NASRIUM"
    symbol            = "NSM"
    version           = "0.1.0-alpha"
    progress_percent  = 90
    last_update       = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    
    statistics = [ordered]@{
        total_folders = $folderList.Count
        total_files   = $fileList.Count
        steps_logged  = $completedCommands.Count
    }
    
    project_rules      = $rules
    completed_commands = $completedCommands
    
    next_actions = @(
        "CMD_024D - Create Balance Configuration Files",
        "CMD_025 - Troop and Unit Design Schema",
        "CMD_026 - Hero and Skill Design Schema"
    )
    
    folders = $folderList
    files   = $fileList
}

# ۵. ذخیره روی دیسک با کدگذاری استاندارد UTF-8
$masterOutput | ConvertTo-Json -Depth 100 | Out-File $outputFile -Encoding UTF8 -Force

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✅ فایل PROJECT_MASTER_HISTORY.json با موفقیت روی دیسک ساخته شد." -ForegroundColor Green
Write-Host "⏳ در حال باز کردن خودکار فایل در Notepad... لطفا پس از مشاهده، آن را ببندید." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# ۶. باز کردن خودکار فایل در Notepad و توقف اسکریپت تا زمان بستن نوت‌پد
Start-Process "notepad.exe" -ArgumentList "`"$outputFile`"" -Wait

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✅ فایل بسته شد و پرامپت پاورشل مجدداً آزاد گردید." -ForegroundColor Green
Write-Host "📄 مسیر فایل ذخیره شده: $outputFile" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
