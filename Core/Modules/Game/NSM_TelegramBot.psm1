<#
 ماژول یکپارچگی تلگرام ناسریوم v2.0 (Patched)
 وظیفه: تنظیمات ربات، منوی وب‌اپ و ارسال پیام
#>

function Set-NSMBotMenu {
    param([string]$BotToken, [string]$WebAppUrl)
    
    # فعال‌سازی اجباری پروتکل امنیتی برای اتصال به تلگرام
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # اصلاح متد API به setChatMenuButton
    $apiUrl = "https://api.telegram.org/bot$BotToken/setChatMenuButton"
    $body = @{
        menu_button = @{
            type = "web_app"
            text = "Open NASRIUM"
            web_app = @{ url = $WebAppUrl }
        }
    } | ConvertTo-Json -Depth 3
    
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $body -ContentType "application/json"
        if ($response.ok) { return $true } else { return $false }
    } catch {
        throw "Telegram API Error: $_"
    }
}

function Send-NSMMessage {
    param([string]$BotToken, [string]$ChatId, [string]$Text)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $apiUrl = "https://api.telegram.org/bot$BotToken/sendMessage"
    $body = @{ chat_id=$ChatId; text=$Text; parse_mode="Markdown" } | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri $apiUrl -Method Post -Body $body -ContentType "application/json" | Out-Null
    } catch {
        Write-Host "Failed to send message: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Set-NSMBotMenu, Send-NSMMessage