# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_093
# File ID   : CMD_093_001
# Module    : Chat
# Component : Unified Chat Pipeline Builder
# Version   : 3.0.0
# Status    : Production
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CHAT PIPELINE RECONSTRUCTION" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$Root = "D:\NASRIUM"
$ModuleDir = "$Root\Core\Modules\Chat"
$ModuleFile = "$ModuleDir\NSM_ChatPipeline.psm1"
$MetadataDir = "$Root\Data\Metadata"

if (!(Test-Path $ModuleDir)) { New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null }
if (!(Test-Path $MetadataDir)) { New-Item -ItemType Directory -Path $MetadataDir -Force | Out-Null }

# ساخت محتوای ماژول با آرایه رشته‌ها برای جلوگیری از تداخل Here-String
$ModuleLines = @(
    'function Process-NSMChatMessage {'
    '    param([string]$Message)'
    '    return [PSCustomObject]@{ Status = "RECEIVED"; Message = $Message; ProcessedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }'
    '}'
    ''
    'function Route-NSMChatMessage {'
    '    param([string]$Channel, [string]$Message)'
    '    return [PSCustomObject]@{ Channel = $Channel; Message = $Message; RouteStatus = "ACCEPTED"; RoutedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }'
    '}'
    ''
    'function Validate-NSMChatMessage {'
    '    param([string]$Message)'
    '    $Result = [ordered]@{ Valid = $true; Length = $Message.Length; Reason = "" }'
    '    if ([string]::IsNullOrWhiteSpace($Message)) { $Result.Valid = $false; $Result.Reason = "EmptyMessage" }'
    '    elseif ($Message.Length -gt 2000) { $Result.Valid = $false; $Result.Reason = "MaximumLengthExceeded" }'
    '    return [PSCustomObject]$Result'
    '}'
    ''
    'function Invoke-NSMChatModeration {'
    '    param([string]$Message)'
    '    $ModeratorPath = "D:\NASRIUM\Core\Modules\Chat\NSM_ChatModerator.psm1"'
    '    if (Test-Path $ModeratorPath) {'
    '        Import-Module $ModeratorPath -Force'
    '        return Verify-NSMChatMessage -Message $Message'
    '    }'
    '    return [PSCustomObject]@{ Status = "SKIPPED"; Reason = "ModeratorModuleNotFound" }'
    '}'
    ''
    'function Send-NSMChatPipeline {'
    '    param([string]$Channel, [string]$Message)'
    '    $Validation = Validate-NSMChatMessage -Message $Message'
    '    if ($Validation.Valid -eq $false) {'
    '        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = $Validation.Reason }'
    '    }'
    '    $Route = Route-NSMChatMessage -Channel $Channel -Message $Message'
    '    return [PSCustomObject]@{ Status = "DELIVERED"; Channel = $Route.Channel; Message = $Route.Message; Time = $Route.RoutedTime }'
    '}'
    ''
    'Export-ModuleMember -Function Process-NSMChatMessage, Route-NSMChatMessage, Validate-NSMChatMessage, Invoke-NSMChatModeration, Send-NSMChatPipeline'
)

$ModuleContent = $ModuleLines -join "`r`n"
[System.IO.File]::WriteAllText($ModuleFile, $ModuleContent, [System.Text.Encoding]::UTF8)
Write-Host "[OK] Step 001-005: Module Rebuilt Successfully." -ForegroundColor Green

# گام ۶: اعتبارسنجی و تولید متادیتا
$Hash = (Get-FileHash $ModuleFile -Algorithm SHA256).Hash
$Validation = [ordered]@{
    Command = "CMD_093"
    SHA256  = $Hash
    Time    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}
$Validation | ConvertTo-Json | Set-Content "$MetadataDir\NSM_CHAT_PIPELINE_VALIDATION_V1.json" -Encoding UTF8
Write-Host "[OK] Step 006: Metadata Sealed." -ForegroundColor Green

# گام ۷: تست در زمان اجرا (Runtime Test)
Remove-Module NSM_ChatPipeline -ErrorAction SilentlyContinue
Import-Module $ModuleFile -Force
$Result = Send-NSMChatPipeline -Channel "Global" -Message "NASRIUM INTEGRITY TEST"
$Result | ConvertTo-Json | Set-Content "$MetadataDir\NSM_CHAT_PIPELINE_RUNTIME_TEST_V1.json" -Encoding UTF8

Write-Host "-----------------------------------------"
Write-Host "RESULT: $($Result.Status)" -ForegroundColor Cyan
Write-Host "CMD_093 EXECUTION COMPLETE (100%)" -ForegroundColor Green
