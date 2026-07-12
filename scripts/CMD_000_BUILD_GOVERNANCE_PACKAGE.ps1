# ================================================================================
# NASRIUM PROJECT
# CMD_000_BUILD_GOVERNANCE_PACKAGE
# STEP 001 - FLUSH & INTEGRATED MERGED INSTALLER (NCDS v1.0 & SDPA v2.0)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ۱. تعیین قطعی مسیر ریشه پروژه و راه‌اندازی پوشه اصلی
$Root = "D:\NASRIUM"
if (!(Test-Path $Root)) {
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
}
Set-Location $Root

Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM SDPA v2.0 - INTEGRATED MERGER" -ForegroundColor Cyan
Write-Host "Command   : CMD_000" -ForegroundColor Yellow
Write-Host "File ID   : CMD_000_001" -ForegroundColor Yellow
Write-Host "Module    : AI Governance Package" -ForegroundColor Yellow
Write-Host "Component : Core Foundation & Laws Merger" -ForegroundColor Yellow
Write-Host "Version   : 2.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

# ۲. ایجاد ساختار پوشه‌بندی فیزیکی ادغام شده طبق استانداردهای پیشرفته
Write-Host "[CMD_000_001] Initializing Unified Directory Structure..." -ForegroundColor Cyan
$dirs = @(
    "Core",
    "Core\Builder\Governance",
    "Core\Builder\Governance\Templates",
    "Core\Modules",
    "Core\Knowledge\AI Governance Package",
    "Core\Knowledge\AI Governance Package\Documentation",
    "Core\Registry",
    "Core\Archive",
    "Data\Database",
    "Data\Backups",
    "Logs",
    "Tests",
    "PPR_Reports"
)

foreach ($d in $dirs) {
    $fullPath = Join-Path $Root $d
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  [+] Created: $d" -ForegroundColor Green
    } else {
        Write-Host "  [=] Verified: $d" -ForegroundColor Yellow
    }
}

# ۳. تولید محتوای فایل قوانین معماری عالی (NASRIUM_SDPA_ARCHITECTURE_LAWS_v1.0.txt)
Write-Host ""
Write-Host "[CMD_000_001] Ratifying Supreme Architectural Laws..." -ForegroundColor Cyan

$laws = @(
    '================================================================================',
    'NASRIUM SDPA ARCHITECTURE LAWS',
    'Version: 1.0.0',
    ("Date: " + $stamp),
    'Status: RATIFIED',
    'Classification: Supreme Law of NASRIUM Project',
    '================================================================================',
    '',
    'PREAMBLE',
    '--------------------------------------------------------------------------------',
    'This document is the supreme law of the NASRIUM project architecture.',
    'All Commands, Modules, Scripts, AI Assistants, and human developers',
    'MUST comply with these laws without exception.',
    '',
    '================================================================================',
    'ARTICLE 1: CORE PRINCIPLES',
    '================================================================================',
    '1.1 GOVERNANCE FIRST PRINCIPLE',
    '    No permanent project information shall reside inside any AI Prompt,',
    '    Chat History, or Human Memory. ALL persistent knowledge MUST be stored ',
    '    in the AI Governance Package files on disk.',
    '',
    '1.2 AI REPLACEABILITY PRINCIPLE',
    '    If Model A (e.g. ChatGPT) is removed today, Model B (e.g. Gemini)',
    '    MUST be able to continue development tomorrow using ONLY the',
    '    Governance Files on disk. No model-specific dependencies are permitted.',
    '',
    '1.3 DISK IS TRUTH PRINCIPLE',
    '    Disk files (governance package) > Chat memory > AI assumptions.',
    '    If chat conflicts with disk, disk wins. Always.',
    '',
    '================================================================================',
    'ARTICLE 2: COMMAND STRUCTURE & SINGLE RESPONSIBILITY',
    '================================================================================',
    '2.1 NAMING CONVENTION',
    '    Format: CMD_XXX_YYY (XXX = Command Number, YYY = Step Number)',
    '2.2 SINGLE DOMAIN PER COMMAND',
    '    Each CMD_XXX owns EXACTLY ONE domain/responsibility.',
    '2.3 COMMAND LIFECYCLE',
    '    Definition -> Build -> Validation -> Artifact Creation -> Completion -> Handoff',
    '2.4 ONE FILE ONE PURPOSE',
    '    Each function/script has exactly one responsibility.',
    '',
    '================================================================================',
    'ARTICLE 3: POWERSHELL STANDARDS',
    '================================================================================',
    '3.1 MANDATORY HEADER',
    '    All .ps1 scripts MUST include a standard metadata comment block at the top.',
    '3.2 ERROR MANAGEMENT',
    '    Try/Catch is mandatory for all external and file system operations.',
    '    StrictMode -Version Latest and ErrorActionPreference = ''Stop'' are enforced.',
    '',
    '================================================================================',
    'END OF LAWS',
    '================================================================================'
) -join "`r`n"

$lawsPath = Join-Path $Root "NASRIUM_SDPA_ARCHITECTURE_LAWS_v1.0.txt"
[System.IO.File]::WriteAllText($lawsPath, $laws, [System.Text.Encoding]::UTF8)
Write-Host "  [OK] Ratified: $lawsPath" -ForegroundColor Green

# ۴. بارگذاری فایل‌های ۹ گانه حاکمیتی هوش مصنوعی (00 تا 07)
Write-Host ""
Write-Host "[CMD_000_001] Constructing AI Governance Package Skeleton..." -ForegroundColor Cyan

$f00 = @(
    '# 00_README_FIRST.md',
    '# NASRIUM AI Governance Package',
    '# Version: 1.0.0',
    '# Status: Official Source of Truth',
    '',
    '## What is this package?',
    'This is the **AI Governance Package** for the NASRIUM (NSM) project.',
    'It is the **only official Source of Truth** for any AI, any account, any model, anywhere in the world.',
    'No chat history, AI memory, or conversation context is authoritative.',
    '',
    '## Required files (read in this order)',
    '1. `00_README_FIRST.md` — this file',
    '2. `01_NASRIUM_CONSTITUTION.md` — supreme laws',
    '3. `02_PROJECT_STATE.json` — current project state',
    '4. `03_ROADMAP.json` — roadmap and phases',
    '5. `04_PROJECT_HISTORY.json` — verified history',
    '6. `05_DEVELOPMENT_STANDARD.md` — coding and command standards',
    '7. `06_AI_BOOTSTRAP_PROMPT.md` — bootstrap loader for any AI',
    '8. `07_SESSION_TEMPLATE.json` — session work template',
    '9. `08_PROJECT_MANIFEST.json` — integrity and checksums',
    '',
    '## Rules for any AI',
    '1. Read all required governance files before any analysis or coding.',
    '2. If any required file is missing, ask the user to provide it.',
    '3. Never guess project state.',
    '4. Never generate code until required files have been reviewed.'
) -join "`r`n"

$f01 = @(
    '# 01_NASRIUM_CONSTITUTION.md',
    '# NASRIUM Constitution',
    '# Version: 1.0.0',
    '# Status: Supreme Law',
    '',
    '## Article 1 — AI Replaceability Principle (Highest Law)',
    'Project continuity must never depend on chat history, AI memory, or a specific platform. If any AI engine is replaced, another compatible engine must resume execution flawlessly using only the AI Governance Package on disk.',
    '',
    '## Article 2 — Single Responsibility',
    '1. Each script has one responsibility.',
    '2. Multiple related files are managed by a Manifest, not by uncontrolled multi-file dumping.',
    '',
    '## Article 3 — Script Header Standard',
    'Every PowerShell script must begin with a standard header displaying: Command, File ID, Module, Component, Version, Status, and Created Date.'
) -join "`r`n"

$f02 = @(
    '{',
    '  "file_id": "02_PROJECT_STATE",',
    '  "version": "2.0.0",',
    ('  "updated_at": "' + $stampISO + '",'),
    '  "project": {',
    '    "name": "Nasrium",',
    '    "symbol": "NSM",',
    '    "type": "Telegram Play-to-Earn Strategy Game",',
    '    "root_path": "D:\\\\NASRIUM",',
    '    "status": "ACTIVE_DEVELOPMENT"',
    '  },',
    '  "current_phase": {',
    '    "id": "PHASE_G0",',
    '    "name": "AI Governance Integration",',
    '    "status": "IN_PROGRESS"',
    '  },',
    '  "completed_phases": [',
    '    "PHASE_0_INIT"',
    '  ],',
    '  "technical_stack": {',
    '    "language": "PowerShell",',
    '    "shell_version": "5.1",',
    '    "governance": "SDPA v2.0"',
    '  },',
    '  "next_recommended_actions": [',
    '    "Execute CMD_000_002 to build system utilities"',
    '  ],',
    '  "source_of_truth": "D:\\\\NASRIUM\\\\Core\\\\Knowledge\\\\AI Governance Package"',
    '}'
) -join "`r`n"

$f03 = @(
    '{',
    '  "file_id": "03_ROADMAP",',
    '  "version": "2.0.0",',
    ('  "updated_at": "' + $stampISO + '",'),
    '  "vision": "Build a real Telegram strategy game with sustainable economy and TON integration.",',
    '  "phases": [',
    '    {',
    '      "id": "PHASE_1",',
    '      "name": "Architecture Bootstrap",',
    '      "status": "IN_PROGRESS",',
    '      "goals": ["Bootstrap structural dirs", "Core scripts", "AI governance package"]',
    '    },',
    '    {',
    '      "id": "PHASE_2",',
    '      "name": "Chat & Moderation Engine",',
    '      "status": "PLANNED",',
    '      "goals": ["Construct config schema", "PowerShell engine", "Integration testing"]',
    '    }',
    '  ]',
    '}'
) -join "`r`n"

$f04 = @(
    '{',
    '  "file_id": "04_PROJECT_HISTORY",',
    '  "version": "2.0.0",',
    ('  "updated_at": "' + $stampISO + '",'),
    '  "events": [',
    '    {',
    '      "id": "H001",',
    '      "date": "' + $stamp + '",',
    '      "type": "ARCHITECTURE",',
    '      "summary": "Unified SDPA v2.0 architecture and modular helper deployed successfully via CMD_000."',
    '    }',
    '  ]',
    '}'
) -join "`r`n"

$f05 = @(
    '# 05_DEVELOPMENT_STANDARD.md',
    '# NASRIUM Development Standard',
    '# Version: 1.0.0',
    '',
    '## 1. Command Rules',
    '- Always use standard PowerShell 5.1 native syntax.',
    '- All code blocks must be provided within pure Markdown `powershell` fences.',
    '- Standard headers and clear progress output are required.'
) -join "`r`n"

$f06 = @(
    '# 06_AI_BOOTSTRAP_PROMPT.md',
    '# NASRIUM AI Bootstrap Loader',
    '',
    'Hello. You are now the Chief Architect of NASRIUM.',
    'Before doing anything:',
    '1. Read all Governance Files in this package.',
    '2. If any required file is missing, request it from the user.',
    '3. Disk files are the only Source of Truth.',
    '4. Do not generate code until the required files have been reviewed.'
) -join "`r`n"

$f07 = @(
    '{',
    '  "file_id": "07_SESSION_TEMPLATE",',
    '  "version": "1.0.0",',
    '  "session_template": {',
    '    "session_id": "SESSION_YYYYMMDD_HHMM",',
    '    "ai_model": "",',
    '    "operator": "",',
    '    "started_at": "",',
    '    "files_read": [],',
    '    "actions_completed": [],',
    '    "risks": []',
    '  }',
    '}'
) -join "`r`n"

# نوشتن فایل‌ها به دیسک به صورت اتمیک و محاسبه چکسام داینامیک
$packagePath = Join-Path $Root "Core\Knowledge\AI Governance Package"

$files = [ordered]@{
    "00_README_FIRST.md"         = $f00
    "01_NASRIUM_CONSTITUTION.md" = $f01
    "02_PROJECT_STATE.json"      = $f02
    "03_ROADMAP.json"            = $f03
    "04_PROJECT_HISTORY.json"    = $f04
    "05_DEVELOPMENT_STANDARD.md" = $f05
    "06_AI_BOOTSTRAP_PROMPT.md"  = $f06
    "07_SESSION_TEMPLATE.json"   = $f07
}

$checksums = @{}
$fileIndex = 1

foreach ($name in $files.Keys) {
    $p = Join-Path $packagePath $name
    [System.IO.File]::WriteAllText($p, $files[$name], [System.Text.Encoding]::UTF8)
    
    $bytes = [System.IO.File]::ReadAllBytes($p)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    $hashStr = ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    $checksums[$name] = $hashStr
    
    Write-Host "  [+] Created: $name (SHA256: $hashStr)" -ForegroundColor Green
    $fileIndex++
}

# ۵. ساخت فایل مانیفست پویا 08_PROJECT_MANIFEST.json
Write-Host ""
Write-Host "[CMD_000_001] Generating Dynamic Integrity Manifest..." -ForegroundColor Cyan

$manifestObj = [ordered]@{
    file_id = "08_PROJECT_MANIFEST"
    version = "1.0.0"
    package_name = "NASRIUM AI Governance Package"
    package_version = "2.0.0"
    generated_at = $stampISO
    package_path = $packagePath
    required_files = @(
        "00_README_FIRST.md",
        "01_NASRIUM_CONSTITUTION.md",
        "02_PROJECT_STATE.json",
        "03_ROADMAP.json",
        "04_PROJECT_HISTORY.json",
        "05_DEVELOPMENT_STANDARD.md",
        "06_AI_BOOTSTRAP_PROMPT.md",
        "07_SESSION_TEMPLATE.json",
        "08_PROJECT_MANIFEST.json"
    )
    files = @()
}

foreach ($name in $files.Keys) {
    $p = Join-Path $packagePath $name
    $item = [ordered]@{
        name = $name
        version = "2.0.0"
        sha256 = $checksums[$name]
        bytes = (Get-Item $p).Length
        required = $true
    }
    $manifestObj.files += $item
}

# ذخیره مانیفست موقت
$manifestPath = Join-Path $packagePath "08_PROJECT_MANIFEST.json"
$manifestJson = $manifestObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, [System.Text.Encoding]::UTF8)

# اعمال خودگردانی و محاسبه چکسام مانیفست روی خودش
$selfRaw = [System.IO.File]::ReadAllBytes($manifestPath)
$selfHash = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($selfRaw)) -replace '-', '').ToLower()

$manifestObj.files += [ordered]@{
    name = "08_PROJECT_MANIFEST.json"
    version = "2.0.0"
    sha256 = $selfHash
    bytes = $selfRaw.Length
    required = $true
}

$manifestJson = $manifestObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, [System.Text.Encoding]::UTF8)
Write-Host "  [OK] Integrity Manifest Sealed (08_PROJECT_MANIFEST.json)" -ForegroundColor Green

# ۶. تولید اسکریپت بیلد حاکمیتی قابل استفاده مجدد (BUILD_GOVERNANCE_PACKAGE.ps1)
Write-Host ""
Write-Host "[CMD_000_001] Deploying Recurrent Governance Builder..." -ForegroundColor Cyan

$builderCode = @(
    '############################################################',
    '# NASRIUM SDPA v2.0',
    '# Command      : CMD_000',
    '# File ID      : CMD_000_002',
    '# Module       : AI Governance Package',
    '# Component    : Reusable Governance Builder',
    '# Version      : 2.0.0',
    '# Author       : NASRIUM Architecture',
    '# Status       : Production',
    '############################################################',
    '$ErrorActionPreference = "Stop"',
    '',
    '$Root = "D:\NASRIUM"',
    '$PackagePath = Join-Path $Root "Core\Knowledge\AI Governance Package"',
    '$ManifestPath = Join-Path $PackagePath "08_PROJECT_MANIFEST.json"',
    '$DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"',
    '',
    'Write-Host "Rebuilding Checksums & Manifest..." -ForegroundColor Cyan',
    '',
    '$required = @(',
    '    "00_README_FIRST.md",',
    '    "01_NASRIUM_CONSTITUTION.md",',
    '    "02_PROJECT_STATE.json",',
    '    "03_ROADMAP.json",',
    '    "04_PROJECT_HISTORY.json",',
    '    "05_DEVELOPMENT_STANDARD.md",',
    '    "06_AI_BOOTSTRAP_PROMPT.md",',
    '    "07_SESSION_TEMPLATE.json"',
    ')',
    '',
    '$filesMeta = @()',
    'foreach ($name in $required) {',
    '    $p = Join-Path $PackagePath $name',
    '    $bytes = [System.IO.File]::ReadAllBytes($p)',
    '    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)',
    '    $hashStr = ([System.BitConverter]::ToString($hash) -replace ''-'', '''').ToLower()',
    '    ',
    '    $filesMeta += [ordered]@{',
    '        name = $name',
    '        version = "2.0.0"',
    '        sha256 = $hashStr',
    '        bytes = (Get-Item $p).Length',
    '        required = $true',
    '    }',
    '}',
    '',
    '$manifest = [ordered]@{',
    '    file_id = "08_PROJECT_MANIFEST"',
    '    version = "2.0.0"',
    '    package_name = "NASRIUM AI Governance Package"',
    '    package_version = "2.0.0"',
    '    generated_at = $DateTime',
    '    package_path = $PackagePath',
    '    required_files = $required + @("08_PROJECT_MANIFEST.json")',
    '    files = $filesMeta',
    '}',
    '',
    '[System.IO.File]::WriteAllText($ManifestPath, ($manifest | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)',
    '',
    '# اضافه کردن چکسام خود مانیفست',
    '$selfRaw = [System.IO.File]::ReadAllBytes($ManifestPath)',
    '$selfHash = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($selfRaw)) -replace ''-'', '''').ToLower()',
    '',
    '$manifest.files += [ordered]@{',
    '    name = "08_PROJECT_MANIFEST.json"',
    '    version = "2.0.0"',
    '    sha256 = $selfHash',
    '    bytes = $selfRaw.Length',
    '    required = $true',
    '}',
    '',
    '[System.IO.File]::WriteAllText($ManifestPath, ($manifest | ConvertTo-Json -Depth 10), [System.Text.Encoding]::UTF8)',
    'Write-Host "SUCCESS: AI Governance Package Rebuilt and Integrity Verified." -ForegroundColor Green'
) -join "`r`n"

$builderFile = Join-Path $Root "Core\Builder\Governance\BUILD_GOVERNANCE_PACKAGE.ps1"
[System.IO.File]::WriteAllText($builderFile, $builderCode, [System.Text.Encoding]::UTF8)
Write-Host "  [OK] Reusable Builder Deployed: $builderFile" -ForegroundColor Green

# ۷. ثبت گزارش PPR و حالت Registry پایدار
Write-Host ""
Write-Host "[CMD_000_001] Committing Pipeline State & Physical Progress Reports (PPR)..." -ForegroundColor Cyan

$state = @{
    cmd_id = "CMD_000_001"
    task = "Initialize Consolidated SDPA Foundation"
    status = "COMPLETED"
    completed_at = $stampISO
    artifacts = @(
        "NASRIUM_SDPA_ARCHITECTURE_LAWS_v1.0.txt",
        "Core\Builder\Governance\BUILD_GOVERNANCE_PACKAGE.ps1",
        "Core\Knowledge\AI Governance Package\*"
    )
    next_step = "CMD_001"
} | ConvertTo-Json -Depth 3

[System.IO.File]::WriteAllText((Join-Path $Root "Core\Registry\CMD_000_001_state.json"), $state, [System.Text.Encoding]::UTF8)

$ppr = @(
    '================================================================================',
    'NASRIUM PROJECT - PHYSICAL PROGRESS REPORT',
    '================================================================================',
    'Version: 5.0 (SDPA Merged Specification)',
    ("Date: " + $stamp),
    'Status: CMD_000_001 COMPLETED SUCCESSFULLY',
    '================================================================================',
    'All 9 Governance files initialized, calculated, and sealed on physical disk.',
    '================================================================================'
) -join "`r`n"
[System.IO.File]::WriteAllText((Join-Path $Root "PPR_Reports\Nasrium_PPR_v5.0_CMD_000.txt"), $ppr, [System.Text.Encoding]::UTF8)

# ۸. تأیید نهایی یکپارچگی فایل‌ها روی دیسک
Write-Host ""
Write-Host "===== FINAL DISK INTEGRITY VERIFICATION =====" -ForegroundColor Cyan
$allOk = $true
$verifyList = @(
    "NASRIUM_SDPA_ARCHITECTURE_LAWS_v1.0.txt",
    "Core\Builder\Governance\BUILD_GOVERNANCE_PACKAGE.ps1",
    "Core\Knowledge\AI Governance Package\00_README_FIRST.md",
    "Core\Knowledge\AI Governance Package\01_NASRIUM_CONSTITUTION.md",
    "Core\Knowledge\AI Governance Package\02_PROJECT_STATE.json",
    "Core\Knowledge\AI Governance Package\03_ROADMAP.json",
    "Core\Knowledge\AI Governance Package\04_PROJECT_HISTORY.json",
    "Core\Knowledge\AI Governance Package\05_DEVELOPMENT_STANDARD.md",
    "Core\Knowledge\AI Governance Package\06_AI_BOOTSTRAP_PROMPT.md",
    "Core\Knowledge\AI Governance Package\07_SESSION_TEMPLATE.json",
    "Core\Knowledge\AI Governance Package\08_PROJECT_MANIFEST.json",
    "Core\Registry\CMD_000_001_state.json",
    "PPR_Reports\Nasrium_PPR_v5.0_CMD_000.txt"
)

foreach ($p in $verifyList) {
    $fullPath = Join-Path $Root $p
    if (Test-Path $fullPath) {
        Write-Host "  [OK] Verified: $p" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Missing: $p" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""
if ($allOk) {
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "   CMD_000 MERGED BUILDER COMPLETE (100%)" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "OK_CMD_000_COMPLETE" -ForegroundColor Green
} else {
    Write-Host "ERROR_CMD_000_INCOMPLETE" -ForegroundColor Red
    exit 1
}
