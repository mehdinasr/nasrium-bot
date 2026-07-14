<#
 ماژول ذخیره‌سازی بازی ناسریوم v1.0
 وظیفه: خواندن و نوشتن اطلاعات بازیکن روی دیسک فیزیکی
#>

function Get-PlayerSavePath {
    param([string]$Id)
    return Join-Path "D:\NASRIUM\Data\Players" "$Id.json"
}

function Save-NSMPlayer {
    param([Parameter(Mandatory=$true)]$PlayerObject)
    $Path = Get-PlayerSavePath -Id $PlayerObject.Id
    try {
        $Json = $PlayerObject | ConvertTo-Json -Depth 5
        [System.IO.File]::WriteAllText($Path, $Json, (New-Object System.Text.UTF8Encoding $false))
        return $true
    } catch {
        Write-Host "ERROR Saving Player: $_" -ForegroundColor Red
        return $false
    }
}

function Get-NSMPlayer {
    param([string]$Id)
    $Path = Get-PlayerSavePath -Id $Id
    if (Test-Path $Path) {
        try {
            $Raw = [System.IO.File]::ReadAllText($Path)
            return $Raw | ConvertFrom-Json
        } catch {
            return $null
        }
    } else {
        return $null
    }
}

Export-ModuleMember -Function Save-NSMPlayer, Get-NSMPlayer