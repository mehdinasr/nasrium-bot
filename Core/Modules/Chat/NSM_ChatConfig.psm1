function Get-NSMChatConfig {
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_ChatConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "Chat configuration file missing." }
    return Get-Content $ConfigPath -Raw | ConvertFrom-Json
}

Export-ModuleMember -Function Get-NSMChatConfig