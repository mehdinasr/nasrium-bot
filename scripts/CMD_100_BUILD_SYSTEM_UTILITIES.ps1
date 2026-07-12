# ================================================================================
# NASRIUM
# CMD_100_BUILD_SYSTEM_UTILITIES
# STEP 002 - REVISED (FIXED PARAMETER TYPE CONSTRAINT)
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = "D:\NASRIUM"
$HelperFile = "$Root\Core\Modules\NSM_BuilderHelper.psm1"
$Time = Get-Date -Format "yyyyMMdd_HHmmss"

# ساخت پوشه ماژول در صورت عدم وجود
$null = New-Item -ItemType Directory -Path "$Root\Core\Modules" -Force

# نوشتن کدهای ماژول مرکزی کمکی با تصحیح محدودیت نوع داده پارامترها
$HelperLines = @(
    '# ================================================================================',
    '# NASRIUM SYSTEM BUILDER HELPER (FIXED v1.0.1)',
    '# ================================================================================',
    'function New-NSMBackup {',
    '    param ([string]$FilePath, [string]$BackupDir)',
    '    if (Test-Path $FilePath) {',
    '        $Time = Get-Date -Format "yyyyMMdd_HHmmss"',
    '        $FileName = [System.IO.Path]::GetFileName($FilePath)',
    '        $null = New-Item -ItemType Directory -Path $BackupDir -Force',
    '        Copy-Item $FilePath "$BackupDir\$FileName`_$Time.bak" -Force',
    '    }',
    '}',
    '',
    'function Update-NSMProjectState {',
    '    param ([string]$StatePath, [string]$LastCmd, [int]$Progress)',
    '    if (Test-Path $StatePath) {',
    '        $State = Get-Content $StatePath -Raw | ConvertFrom-Json',
    '        $State.LastCommand = $LastCmd',
    '        $State.LastCommandStatus = "SUCCESS"',
    '        $State.LastCommandTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")',
    '        $State.ProgressPercent = $Progress',
    '        $State | ConvertTo-Json -Depth 20 | Set-Content $StatePath -Encoding UTF8 -Force',
    '    }',
    '}',
    '',
    'function Register-NSMCommandHistory {',
    '    param ([string]$MasterPath, [PSObject]$CmdRecord)',
    '    if (Test-Path $MasterPath) {',
    '        $Master = Get-Content $MasterPath -Raw | ConvertFrom-Json',
    '        if ($null -eq $Master.PSObject.Properties["Commands"]) {',
    '            $Master = Add-Member -InputObject $Master -NotePropertyName "Commands" -NotePropertyValue @() -PassThru -Force',
    '        }',
    '        $List = [System.Collections.ArrayList]@($Master.Commands)',
    '        $Existing = $List | ForEach-Object { $_.CMD }',
    '        if (!($Existing -contains $CmdRecord.CMD)) {',
    '            [void]$List.Add($CmdRecord)',
    '        }',
    '        $Master.Commands = $List',
    '        $Master | ConvertTo-Json -Depth 20 | Set-Content $MasterPath -Encoding UTF8 -Force',
    '    }',
    '}',
    '',
    'function Write-NSMBuildReport {',
    '    param ([string]$ReportPath, [string]$Cmd, [string]$Domain, [string]$Output)',
    '    $SHA = (Get-FileHash $Output -Algorithm SHA256).Hash',
    '    $Report = @"',
    '==================================================',
    'NASRIUM BUILD REPORT',
    '==================================================',
    'COMMAND : $Cmd',
    'STATUS  : SUCCESS',
    'DOMAIN  : $Domain',
    'OUTPUT  : $Output',
    'SHA256  : $SHA',
    'TIME    : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")',
    '==================================================',
    '"@',
    '    $Report | Set-Content $ReportPath -Encoding UTF8 -Force',
    '}',
    '',
    'Export-ModuleMember -Function New-NSMBackup, Update-NSMProjectState, Register-NSMCommandHistory, Write-NSMBuildReport'
)

$ModuleCode = $HelperLines -join "`r`n"
$ModuleCode | Set-Content $HelperFile -Encoding UTF8 -Force

Write-Host "=========================================" -ForegroundColor Green
Write-Host "CMD_100 SUCCESS: Core Helper Module Created" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
exit 0
