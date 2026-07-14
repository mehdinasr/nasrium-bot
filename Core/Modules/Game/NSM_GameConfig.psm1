function Get-NSMGameConfig {
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_GameConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "Game configuration file missing." }
    return Get-Content $ConfigPath -Raw | ConvertFrom-Json
}

Export-ModuleMember -Function Get-NSMGameConfig