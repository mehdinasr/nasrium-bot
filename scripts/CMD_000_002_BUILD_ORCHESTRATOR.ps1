# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_000
# File ID   : CMD_000_002
# Module    : AI Governance Package
# Component : Governance Orchestrator Engine
# Version   : 2.2.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM ORCHESTRATOR ENGINE INITIALIZATION" -ForegroundColor Cyan
Write-Host "Command   : CMD_000" -ForegroundColor Yellow
Write-Host "File ID   : CMD_000_002" -ForegroundColor Yellow
Write-Host "Version   : 2.2.0" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$Root = "D:\NASRIUM"
$OrchPath = Join-Path $Root "Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"
$SystemPath = Join-Path $Root "Core\Modules\System"
$ValidatorPath = Join-Path $SystemPath "NSM_GovernanceValidator.ps1"
$RegistryPath = Join-Path $Root "Core\Registry"
$LogsPath = Join-Path $Root "Logs"

try {
    if (!(Test-Path $SystemPath)) { New-Item -ItemType Directory -Path $SystemPath -Force | Out-Null }
    if (!(Test-Path $LogsPath)) { New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null }
} catch {
    throw "Directory initialization failed: $_"
}

# ۱. ساخت ماژول Governance Validator (پیش‌نیاز Orchestrator)
Write-Host "[CMD_000_002] Building Governance Validator Module..." -ForegroundColor Cyan

$validatorCode = @(
    'function Test-NSMGovernanceIntegrity {',
    '    $GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"',
    '    $ManifestPath = Join-Path $GovPath "08_PROJECT_MANIFEST.json"',
    '    if (!(Test-Path $ManifestPath)) { throw "Governance Manifest missing." }',
    '    $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json',
    '    foreach ($file in $manifest.files) {',
    '        $filePath = Join-Path $GovPath $file.name',
    '        if (!(Test-Path $filePath)) { throw "Required file missing: $($file.name)" }',
    '        $bytes = [System.IO.File]::ReadAllBytes($filePath)',
    '        $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)',
    '        $hashStr = ([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()',
    '        if ($hashStr -ne $file.sha256) { throw "Integrity violation in: $($file.name)" }',
    '    }',
    '    return $true',
    '}'
) -join "`r`n"

try {
    [System.IO.File]::WriteAllText($ValidatorPath, $validatorCode, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] Validator Module Created." -ForegroundColor Green
} catch {
    throw "Failed to create Validator Module: $_"
}

# ۲. ساخت موتور Orchestrator
Write-Host "[CMD_000_002] Building Orchestrator Engine..." -ForegroundColor Cyan

$orchCode = @(
    '# ================================================================================',
    '# NASRIUM ORCHESTRATOR ENGINE v2.2',
    '# ================================================================================',
    '$ErrorActionPreference = "Stop"',
    'Set-StrictMode -Version Latest',
    '',
    '$Root = "D:\NASRIUM"',
    '$RegistryPath = Join-Path $Root "Core\Registry"',
    '$LogsPath = Join-Path $Root "Logs"',
    '$ValidatorPath = Join-Path $Root "Core\Modules\System\NSM_GovernanceValidator.ps1"',
    '',
    'function Write-OrchLog {',
    '    param([string]$Message)',
    '    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"',
    '    $line = "[$ts] [ORCHESTRATOR] $Message"',
    '    Add-Content -Path (Join-Path $LogsPath "orchestrator.log") -Value $line -Encoding UTF8',
    '    Write-Host $line -ForegroundColor Cyan',
    '}',
    '',
    'function Invoke-GovernanceValidation {',
    '    if (!(Test-Path $ValidatorPath)) { throw "Governance Validator module missing." }',
    '    . $ValidatorPath',
    '    Write-OrchLog "Running Governance Integrity Check..."',
    '    $result = Test-NSMGovernanceIntegrity',
    '    if (-not $result) { throw "Governance integrity validation failed." }',
    '    Write-OrchLog "Governance Integrity Verified."',
    '}',
    '',
    'function Repair-StalledCommands {',
    '    $states = Get-ChildItem $RegistryPath -Filter "*_state.json"',
    '    foreach ($s in $states) {',
    '        $json = Get-Content $s.FullName -Raw | ConvertFrom-Json',
    '        if ($json.status -eq "IN_PROGRESS") {',
    '            $json.status = "FAILED"',
    '            $json.failed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")',
    '            $json.failure_reason = "Crash Recovery"',
    '            $json | ConvertTo-Json -Depth 3 | Set-Content $s.FullName -Encoding UTF8',
    '            Write-OrchLog "RECOVERY: $($s.Name) marked FAILED"',
    '        }',
    '    }',
    '}',
    '',
    'function Register-CommandStart {',
    '    param([string]$CmdId)',
    '    $obj = @{ cmd_id = $CmdId; status = "IN_PROGRESS"; started_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") } | ConvertTo-Json -Depth 3',
    '    Set-Content (Join-Path $RegistryPath "${CmdId}_state.json") $obj -Encoding UTF8',
    '}',
    '',
    'function Register-CommandComplete {',
    '    param([string]$CmdId)',
    '    $obj = @{ cmd_id = $CmdId; status = "COMPLETED"; completed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") } | ConvertTo-Json -Depth 3',
    '    Set-Content (Join-Path $RegistryPath "${CmdId}_state.json") $obj -Encoding UTF8',
    '}',
    '',
    'function Invoke-NasriumCommand {',
    '    param([string]$CmdId, [scriptblock]$Action)',
    '    Repair-StalledCommands',
    '    Invoke-GovernanceValidation',
    '    Register-CommandStart -CmdId $CmdId',
    '    Write-OrchLog "Executing $CmdId ..."',
    '    try {',
    '        & $Action',
    '        Register-CommandComplete -CmdId $CmdId',
    '        Write-OrchLog "$CmdId completed successfully."',
    '    }',
    '    catch {',
    '        $failObj = @{ cmd_id = $CmdId; status = "FAILED"; failed_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"); failure_reason = $_.Exception.Message } | ConvertTo-Json -Depth 3',
    '        Set-Content (Join-Path $RegistryPath "${CmdId}_state.json") $failObj -Encoding UTF8',
    '        Write-OrchLog "FAILED: $CmdId - $($_.Exception.Message)"',
    '        throw',
    '    }',
    '}',
    '',
    'Write-OrchLog "Governance Orchestrator Engine v2.2 Ready."'
) -join "`r`n"

try {
    [System.IO.File]::WriteAllText($OrchPath, $orchCode, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] Orchestrator Engine Created." -ForegroundColor Green
} catch {
    throw "Failed to create Orchestrator Engine: $_"
}

# ۳. ثبت State و PPR
Write-Host "[CMD_000_002] Committing State & PPR..." -ForegroundColor Cyan

$stampISO = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

try {
    $state = @{
        cmd_id = "CMD_000_002"
        task = "Deploy Governance Orchestrator Engine"
        status = "COMPLETED"
        completed_at = $stampISO
        artifacts = @(
            "Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1",
            "Core\Modules\System\NSM_GovernanceValidator.ps1"
        )
        next_step = "CMD_001"
    } | ConvertTo-Json -Depth 3

    [System.IO.File]::WriteAllText((Join-Path $RegistryPath "CMD_000_002_state.json"), $state, [System.Text.Encoding]::UTF8)
    
    $ppr = "================================================================================`r`nNASRIUM PROJECT - PHYSICAL PROGRESS REPORT`r`n================================================================================`r`nDate: $stampISO`r`nStatus: CMD_000_002 COMPLETED SUCCESSFULLY`r`n================================================================================"
    [System.IO.File]::WriteAllText((Join-Path $Root "PPR_Reports\Nasrium_PPR_CMD_000_002.txt"), $ppr, [System.Text.Encoding]::UTF8)
} catch {
    throw "Failed to commit State/PPR: $_"
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "   CMD_000_002 ORCHESTRATOR DEPLOYED" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "OK_CMD_000_002_COMPLETE" -ForegroundColor Green
