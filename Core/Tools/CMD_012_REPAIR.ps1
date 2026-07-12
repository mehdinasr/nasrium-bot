$ErrorActionPreference = "Stop"

$stageId = "CMD_012_REPAIR"
$root = "D:\NASRIUM"
$core = Join-Path $root "Core"
$logsDir = Join-Path $core "Logs"
$reportsDir = Join-Path $core "Reports"
$knowledgeDir = Join-Path $core "Knowledge"
$archiveDir = Join-Path $core "Archive"
$appsDir = Join-Path $root "Apps"
$appDir = Join-Path $appsDir "telegram-bot"

$contextPath = Join-Path $knowledgeDir "NASRIUM_CONTEXT.json"
$historyPath = Join-Path $reportsDir "command_history.ndjson"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$transcript = Join-Path $logsDir "$stageId`_$ts.transcript.txt"
$cmdLog = Join-Path $logsDir "$stageId`_$ts.log.txt"

function Step($msg){ Write-Host "==> $msg" -ForegroundColor Cyan }
function OK($msg){ Write-Host "OK  - $msg" -ForegroundColor Green }
function FAIL($msg){ Write-Host "FAIL- $msg" -ForegroundColor Red }

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
Start-Transcript -Path $transcript -Force | Out-Null

$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "NASRIUM - CMD_012_REPAIR" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    Step "Creating project folders"
    foreach($f in @(
        $appsDir,
        $appDir,
        (Join-Path $appDir "src"),
        (Join-Path $appDir "src\config"),
        (Join-Path $appDir "src\handlers"),
        (Join-Path $appDir "src\utils")
    )){
        New-Item -ItemType Directory -Path $f -Force | Out-Null
    }
    OK "Folders created"

    Step "Writing package.json"
    Set-Content -Path (Join-Path $appDir "package.json") -Encoding UTF8 -Value @(
'{',
'  "name": "nasrium-telegram-bot",',
'  "version": "0.1.0",',
'  "private": true,',
'  "type": "module",',
'  "scripts": {',
'    "dev": "tsx watch src/index.ts",',
'    "build": "tsc -p tsconfig.json",',
'    "start": "node dist/index.js",',
'    "typecheck": "tsc -p tsconfig.json --noEmit"',
'  },',
'  "dependencies": {',
'    "dotenv": "^16.4.5",',
'    "grammy": "^1.35.0"',
'  },',
'  "devDependencies": {',
'    "@types/node": "^24.0.0",',
'    "tsx": "^4.20.0",',
'    "typescript": "^5.6.3"',
'  }',
'}'
    )
    OK "package.json written"

    Step "Writing tsconfig.json"
    Set-Content -Path (Join-Path $appDir "tsconfig.json") -Encoding UTF8 -Value @(
'{',
'  "compilerOptions": {',
'    "target": "ES2022",',
'    "lib": ["ES2022"],',
'    "module": "NodeNext",',
'    "moduleResolution": "NodeNext",',
'    "rootDir": "src",',
'    "outDir": "dist",',
'    "strict": true,',
'    "skipLibCheck": true,',
'    "noImplicitOverride": true,',
'    "noUncheckedIndexedAccess": true,',
'    "esModuleInterop": true,',
'    "resolveJsonModule": true',
'  },',
'  "include": ["src/**/*.ts"]',
'}'
    )
    OK "tsconfig.json written"

    Step "Writing .gitignore and .env.example"
    Set-Content -Path (Join-Path $appDir ".gitignore") -Encoding UTF8 -Value @(
'node_modules/',
'dist/',
'.env',
'.env.*',
'!.env.example',
'*.log'
    )

    Set-Content -Path (Join-Path $appDir ".env.example") -Encoding UTF8 -Value @(
'# Telegram Bot Token',
'BOT_TOKEN=PASTE_YOUR_TOKEN_HERE',
'',
'# Runtime',
'NODE_ENV=development'
    )
    OK ".gitignore and .env.example written"

    Step "Writing TypeScript source files"

    Set-Content -Path (Join-Path $appDir "src\index.ts") -Encoding UTF8 -Value @(
'import "dotenv/config";',
'import { createBot } from "./bot.js";',
'',
'async function main() {',
'  const bot = createBot();',
'  console.log("[NASRIUM] Bot starting (long polling) ...");',
'  await bot.start();',
'}',
'',
'main().catch((err) => {',
'  console.error("[NASRIUM] Fatal error:", err);',
'  process.exit(1);',
'});'
    )

    Set-Content -Path (Join-Path $appDir "src\bot.ts") -Encoding UTF8 -Value @(
'import { Bot } from "grammy";',
'import { getEnv } from "./config/env.js";',
'import { registerStartHandler } from "./handlers/start.js";',
'import { registerTextHandler } from "./handlers/text.js";',
'import { registerErrorHandler } from "./utils/errors.js";',
'',
'export function createBot() {',
'  const env = getEnv();',
'  const bot = new Bot(env.BOT_TOKEN);',
'',
'  registerStartHandler(bot);',
'  registerTextHandler(bot);',
'  registerErrorHandler(bot);',
'',
'  return bot;',
'}'
    )

    Set-Content -Path (Join-Path $appDir "src\config\env.ts") -Encoding UTF8 -Value @(
'type Env = {',
'  BOT_TOKEN: string;',
'  NODE_ENV: "development" | "production" | string;',
'};',
'',
'export function getEnv(): Env {',
'  const BOT_TOKEN = process.env.BOT_TOKEN?.trim();',
'  const NODE_ENV = process.env.NODE_ENV?.trim() || "development";',
'',
'  if (!BOT_TOKEN || BOT_TOKEN === "PASTE_YOUR_TOKEN_HERE") {',
'    throw new Error("BOT_TOKEN is missing. Create .env file based on .env.example and set BOT_TOKEN.");',
'  }',
'',
'  return { BOT_TOKEN, NODE_ENV };',
'}'
    )

    Set-Content -Path (Join-Path $appDir "src\handlers\start.ts") -Encoding UTF8 -Value @(
'import type { Bot, Context } from "grammy";',
'',
'export function registerStartHandler(bot: Bot<Context>) {',
'  bot.command("start", async (ctx) => {',
'    const name = ctx.from?.first_name ?? "دوست عزیز";',
'    await ctx.reply(`سلام ${name}!`);',
'  });',
'}'
    )

    Set-Content -Path (Join-Path $appDir "src\handlers\text.ts") -Encoding UTF8 -Value @(
'import type { Bot, Context } from "grammy";',
'',
'export function registerTextHandler(bot: Bot<Context>) {',
'  bot.on("message:text", async (ctx) => {',
'    await ctx.reply("پیام شما دریافت شد. برای شروع /start را بزنید.");',
'  });',
'}'
    )

    Set-Content -Path (Join-Path $appDir "src\utils\errors.ts") -Encoding UTF8 -Value @(
'import type { Bot, Context } from "grammy";',
'',
'export function registerErrorHandler(bot: Bot<Context>) {',
'  bot.catch((err) => {',
'    const ctx = err.ctx as Context | undefined;',
'    const updateId = (ctx as any)?.update?.update_id;',
'    console.error("[NASRIUM] Bot error", { updateId, error: err.error });',
'  });',
'}'
    )

    OK "Source files written"

    Step "Installing dependencies"
    Push-Location $appDir
    npm install --no-fund --no-audit
    OK "npm install finished"

    Step "Running typecheck"
    npm run typecheck
    OK "typecheck passed"
    Pop-Location

    Step "Updating context and history"
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null

    if (Test-Path $contextPath) {
        Copy-Item $contextPath (Join-Path $archiveDir "NASRIUM_CONTEXT_$ts.json") -Force

        $ctx = Get-Content $contextPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        $ctx.meta.last_update = $now
        $ctx.state.last_stage_id = $stageId
        $ctx.state.last_stage_time = $now
        $ctx.state.last_action = "Repaired and created TypeScript Telegram bot scaffold"
        $ctx.state.next_action = "CMD_013 - Create .env and run bot locally"

        ($ctx | ConvertTo-Json -Depth 50) | Out-File -FilePath $contextPath -Encoding UTF8 -Force

        if (!(Test-Path $historyPath)) {
            New-Item -ItemType File -Path $historyPath -Force | Out-Null
        }

        $hist = [ordered]@{
            stage_id = $stageId
            time = $now
            result = "SUCCESS"
            outputs = @{
                app_dir = $appDir
                context = $contextPath
                transcript = $transcript
            }
        }

        ($hist | ConvertTo-Json -Depth 10 -Compress) | Out-File -FilePath $historyPath -Append -Encoding UTF8
    }

    $sw.Stop()
    "SUCCESS $stageId $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $cmdLog -Encoding UTF8 -Force

    Write-Host "----------------------------------------" -ForegroundColor Green
    Write-Host ("DONE: {0} SUCCESS | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Green
    Write-Host ("App: {0}" -f $appDir) -ForegroundColor Gray
    Write-Host ("Transcript: {0}" -f $transcript) -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Green
}
catch {
    $sw.Stop()
    "FAILED $stageId $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $($_.Exception.Message)" | Out-File -FilePath $cmdLog -Encoding UTF8 -Force
    Write-Host "----------------------------------------" -ForegroundColor Red
    Write-Host ("DONE: {0} FAILED | Duration: {1}s" -f $stageId, [math]::Round($sw.Elapsed.TotalSeconds,2)) -ForegroundColor Red
    Write-Host ("ERROR: {0}" -f $_.Exception.Message) -ForegroundColor Red
    Write-Host ("Transcript: {0}" -f $transcript) -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Red
    throw
}
finally {
    Pop-Location -ErrorAction SilentlyContinue
    Stop-Transcript | Out-Null
}
