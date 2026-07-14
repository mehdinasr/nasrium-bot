function Send-NSMTelegramMessage {
    param([string]$ChatId, [string]$Text)
    
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TelegramConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "Telegram config missing." }
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    
    if ($Config.bot_token -eq "YOUR_TELEGRAM_BOT_TOKEN_HERE") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BotTokenNotConfigured" }
    }
    
    $Url = "$($Config.api_base_url)$($Config.bot_token)/sendMessage"
    $Body = @{ chat_id = $ChatId; text = $Text }
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -Body $Body -ErrorAction Stop
        return [PSCustomObject]@{ Status = "SUCCESS"; Response = $Response }
    } catch {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }
    }
}

Export-ModuleMember -Function Send-NSMTelegramMessage