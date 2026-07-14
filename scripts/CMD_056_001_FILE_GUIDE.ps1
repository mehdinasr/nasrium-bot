# ================================================================================
# NASRIUM PROJECT
# Command   : CMD_056
# File ID   : CMD_056_001
# Module    : Infrastructure | File Management Guide
# Component : How to view and edit files in PowerShell
# Version   : 1.0.0
# Status    : Production
# NES       : v1.0
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "NASRIUM CMD_056 - FILE MANAGEMENT GUIDE" -ForegroundColor Cyan
Write-Host "Command   : CMD_056" -ForegroundColor Yellow
Write-Host "File ID   : CMD_056_001" -ForegroundColor Yellow
Write-Host "Module    : Infrastructure | File Management" -ForegroundColor Yellow
Write-Host "Component : View and edit files" -ForegroundColor Yellow
Write-Host "Version   : 1.0.0" -ForegroundColor Yellow
Write-Host "Status    : Production" -ForegroundColor Green
Write-Host "NES       : v1.0" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 1: View File (PowerShell)" -ForegroundColor Green
Write-Host "  Get-Content 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
Write-Host "  OR:" -ForegroundColor White
Write-Host "  type 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 2: View First 10 Lines" -ForegroundColor Green
Write-Host "  Get-Content 'D:\NASRIUM\main.py' | Select-Object -First 10" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 3: Open in Notepad" -ForegroundColor Green
Write-Host "  notepad 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 4: Open in VS Code (if installed)" -ForegroundColor Green
Write-Host "  code 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 5: Edit with PowerShell ISE" -ForegroundColor Green
Write-Host "  ise 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 6: Create/Overwrite File" -ForegroundColor Green
Write-Host "  'your text here' | Set-Content 'D:\NASRIUM\file.txt'" -ForegroundColor Cyan
Write-Host ""

Write-Host "METHOD 7: Append to File" -ForegroundColor Green
Write-Host "  'new line' | Add-Content 'D:\NASRIUM\file.txt'" -ForegroundColor Cyan
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CMD_056_001 COMPLETE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "EXAMPLE - View main.py:" -ForegroundColor Yellow
Write-Host "  Get-Content 'D:\NASRIUM\main.py'" -ForegroundColor Cyan
