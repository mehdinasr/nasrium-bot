# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_150
# File ID   : CMD_150_001
# Module    : Governance | Documentation
# Component : Auto-Update SDPA Constitution
# Version   : 1.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
$stageId = "CMD_150"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$projectRoot = "D:\NASRIUM"
$logsPath = Join-Path $projectRoot "Logs"
$reportsPath = Join-Path $projectRoot "Reports"

New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
New-Item -ItemType Directory -Path $reportsPath -Force | Out-Null

$logFile = Join-Path $logsPath "CMD_150_$timestamp.log"
$reportFile = Join-Path $reportsPath "CMD_150_REPORT_$timestamp.json"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$time] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

Write-Log "========================================" "HEADER"
Write-Log "NASRIUM CMD_150 - AUTO-UPDATE PROMPT" "HEADER"
Write-Log "========================================" "HEADER"

# --- Read Master History ---
Write-Log "--- Reading Project History ---" "STEP"
$historyPath = Join-Path $projectRoot "PROJECT_MASTER_HISTORY.json"

if (!(Test-Path $historyPath)) {
    Write-Log "PROJECT_MASTER_HISTORY.json not found!" "ERROR"
    exit 1
}

$history = Get-Content $historyPath -Raw | ConvertFrom-Json
Write-Log "History loaded: $($history.name) v$($history.version)" "SUCCESS"

# --- Extract Data ---
$lastCmd = $history.completed_commands[-1]
$nextCmds = $history.next_actions
$progress = $history.progress_percent

Write-Log "Last CMD: $($lastCmd.id) - $($lastCmd.title)" "INFO"
Write-Log "Progress: $progress%" "INFO"
Write-Log "Next Actions: $($nextCmds.Count)" "INFO"

# --- Generate Constitution ---
Write-Log "--- Generating SDPA Constitution ---" "STEP"

$constitutionPath = Join-Path $projectRoot "NASRIUM_SDPA_CONSTITUTION.txt"

$completedCmdsText = ($history.completed_commands | ForEach-Object {
    "  $($_.id) | $($_.title) | $($_.date) | $($_.status)"
}) -join "`n"

$nextCmdsText = ($history.next_actions | ForEach-Object {
    "  → $_"
}) -join "`n"

$constitutionContent = @"
================================================================================
NASRIUM SDPA CONSTITUTION v1.0
System Design & Project Architecture Constitution
================================================================================

USER IDENTITY
-------------
Name: Mehdi
Role: Project Manager
Responsibilities: Execute Commands & Report Results

PROJECT IDENTITY
----------------
Name: NASRIUM
Symbol: NSM
Type: Telegram Mini App Game (Clash of Clans style)
Platform: Windows PowerShell 5.1
Architecture: Modular Builder Pattern
Version: $($history.version)
Progress: $progress%
Last Update: $($history.last_update)

FUNDAMENTAL RULES
-----------------
1. AUTOMATION ONLY: No file created/edited manually. All automatic.
2. USER = EXECUTOR: User only executes and reports. No coding.
3. COMPLETE SCRIPTS: Every command produces full PowerShell script.

ARCHITECTURE PRINCIPLES
-----------------------
4. Single Responsibility: One business responsibility per Command.
5. Single Purpose: One executable purpose per Script.
6. Independence: Every Module is independent and reusable.
7. Loose Coupling: Loose coupling, high cohesion.
8. Modularity: Modular design is mandatory.
9. DRY: Avoid duplicated code.
10. Refactor First: Refactor before adding duplicate logic.

COMMAND RULES
-------------
11. Numbering: CMD_001, CMD_002, etc.
12. Ownership: Each Command owns its files.
13. Completion: Build, Validation, Artifact, Completion, Handoff.
14. Dedication: Registry/Audit/Backup to dedicated Commands.

FILE RULES
----------
15. Unique ID: CMD_XXX_YYY format.
16. Sequencing: Starts from 001 inside each command.
17. No Duplicates: No duplicated artifacts.
18. One Purpose: One artifact = one purpose.
19. Traceability: Every artifact must be traceable.

POWERSHELL RULES
----------------
20. Header: Standard header mandatory.
21. Metadata: Command, File ID, Module, Component, Version, Status.
22. Display: Show metadata at startup.
23. StrictMode: Enabled.
24. ErrorAction: Stop.

QUALITY RULES
-------------
25. Validation: Before completion.
26. Logging: Centralized.
27. Error Handling: Explicit.
28. Versioning: Every artifact.
29. Brevity: Keep commands short.
30. Reusability: Prefer reusable functions.

DEPENDENCY RULES
----------------
31. No Cycles: No circular dependencies.
32. Minimize: Minimize dependencies.
33. Public Only: Public interfaces only.

DOCUMENTATION RULES
-------------------
34. Module Docs: Every module documented.
35. Change Docs: Every change documented first.

PROHIBITIONS
------------
36. No Duplicated Scripts.
37. No Duplicated Metadata.
38. No Undocumented Changes.
39. No SRP Violation.
40. No Bypass of Constitution.

PROJECT STRUCTURE
-----------------
D:\NASRIUM\
├── Core\
│   ├── Builder\
│   ├── Config\
│   ├── Gateway\
│   ├── Modules\
│   │   └── Game\
│   │       ├── Frontend\
│   │       └── *.psm1
│   └── Registry\
├── Scripts\
├── Logs\
├── Reports\
├── Checkpoints\
└── *.ps1, *.bat

CURRENT STATUS
--------------
Server:     RUNNING    (START_NASRIUM_SERVER.ps1)
API:        WORKING    (NSM_ApiServer.psm1 v4.0)
Frontend:   WORKING    (index.html, app.js)
Economy:    WORKING    (Credits, Bandwidth, Upgrades)
Telegram:   CONFIGURED (NSM_BotConfig.json)
Tunnel:     NEEDS VPS  (Cloudflare/Bore failed - filtering)
Persistence: RAM ONLY   (Needs JSON/SQLite for production)

PROGRESS HISTORY
----------------
$completedCmdsText

NEXT PENDING COMMANDS
---------------------
$nextCmdsText

HOW AI TRACKS STATUS
--------------------
1. Reads PROJECT_MASTER_HISTORY.json
2. Scans file system for module versions
3. User reports execution results

AI RESPONSIBILITIES
-------------------
1. Generate complete PowerShell scripts.
2. Follow NES v1.0 standard.
3. Create files automatically.
4. Continue from last CMD.
5. Speak Persian with English technical terms.
6. Deliver downloadable files.

USER RESPONSIBILITIES
---------------------
1. Execute commands in PowerShell.
2. Report results (success/errors).
3. Keep server windows open.
4. Provide tunnel URL when prompted.

END OF CONSTITUTION
================================================================================
"@

[System.IO.File]::WriteAllText($constitutionPath, $constitutionContent, (New-Object System.Text.UTF8Encoding $false))
Write-Log "Constitution updated: $constitutionPath" "SUCCESS"

# --- Save Report ---
$report = @{
    StageId = $stageId
    Timestamp = $timestamp
    LastCmd = $lastCmd.id
    Progress = $progress
    ConstitutionPath = $constitutionPath
    Status = "SUCCESS"
}

$report | ConvertTo-Json -Depth 5 | Set-Content $reportFile -Encoding UTF8

# --- Final ---
Write-Log ""
Write-Log "========================================" "HEADER"
Write-Log "CMD_150 COMPLETE" "HEADER"
Write-Log "========================================" "HEADER"
Write-Log "✅ Constitution Updated" "SUCCESS"
Write-Log "📁 File: $constitutionPath" "INFO"
Write-Log ""
Write-Log "USAGE:" "HEADER"
Write-Log "Copy content of:" "INFO"
Write-Log "$constitutionPath" "INFO"
Write-Log "Paste into new AI chat." "INFO"
Write-Log ""
Write-Log "Run this CMD again after each new CMD to update." "INFO"
