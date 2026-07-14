$ErrorActionPreference = "Stop"

$root = "D:\NASRIUM"
$tools = "$root\Core\Tools"
$archive = "$root\Core\Archive"
$target = "$tools\CMD_013.ps1"

$ts = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Path $archive -Force | Out-Null

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NASRIUM - PATCH_CMD_013 (PS5 Compatibility)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if (!(Test-Path $target)) { throw "Target not found: $target" }

# Backup
$backup = Join-Path $archive ("CMD_013_before_patch_{0}.ps1" -f $ts)
Copy-Item $target $backup -Force
Write-Host "OK  - Backup created: $backup" -ForegroundColor Green

$content = Get-Content $target -Raw -Encoding UTF8

# Replace the PS7 operator line: $token = ($token ?? "").Trim()
# with PS5-safe block.
$pattern = '(?m)^(?<i>\s*)\$token\s*=\s*\(\$token\s*\?\?\s*""\)\.Trim\(\)\s*$'
if ($content -match $pattern) {
  $content = [regex]::Replace($content, $pattern, {
    param($m)
    $i = $m.Groups["i"].Value
    return ($i + 'if ($null -eq $token) { $token = "" }' + "`r`n" +
            $i + '$token = [string]$token' + "`r`n" +
            $i + '$token = $token.Trim()')
  })
  Write-Host "OK  - Patched '??' operator usage" -ForegroundColor Green
} else {
  Write-Host "WARN- Pattern not found. Checking for any '??' occurrences..." -ForegroundColor Yellow
}

# Verify no "??" remains
if ($content -match '\?\?') {
  throw "Patch incomplete: '??' still exists in CMD_013.ps1. Please send the file content around the token line."
}

$content | Out-File -FilePath $target -Encoding UTF8 -Force
Write-Host "OK  - Updated file saved: $target" -ForegroundColor Green

Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "DONE: PATCH_CMD_013 SUCCESS" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Green
