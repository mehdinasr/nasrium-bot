<#
 ماژول احراز هویت و ثبت‌نام ناسریوم v1.0
 وظیفه: مدیریت ورود کاربران جدید از تلگرام و تخصیص منابع اولیه
#>

function Initialize-NSMPlayer {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TelegramId,
        [Parameter(Mandatory=$false)]
        [string]$Username = "NewNode"
    )
    
    # بررسی اینکه آیا کاربر قبلاً ثبت‌نام کرده است یا خیر
    $existingPlayer = Get-NSMPlayer -Id $TelegramId
    if ($existingPlayer) {
        return $existingPlayer
    }
    
    # ایجاد کاربر جدید با منابع اولیه (طبق تم سایبرپانک)
    $newPlayer = @{
        Id = $TelegramId
        Username = $Username
        LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Resources = @{ Credits=1000; Bandwidth=200 }
        Buildings = @{ AI_CORE=@{Level=1} }
    }
    
    # ذخیره روی دیسک فیزیکی
    $saveStatus = Save-NSMPlayer -PlayerObject $newPlayer
    
    if ($saveStatus) {
        return $newPlayer
    } else {
        throw "Failed to save new player $TelegramId"
    }
}

Export-ModuleMember -Function Initialize-NSMPlayer