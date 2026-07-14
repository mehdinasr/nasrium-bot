function Export-NSMPlayer {
    param($Player)
    $DatabaseDir = "D:\NASRIUM\Data\Database\Players"
    if (!(Test-Path $DatabaseDir)) { New-Item -ItemType Directory -Path $DatabaseDir -Force | Out-Null }
    $FilePath = Join-Path $DatabaseDir "$($Player.Id).json"
    try {
        $Player | ConvertTo-Json -Depth 5 | Set-Content $FilePath -Encoding UTF8
        return $true
    } catch {
        throw "Failed to save player data: $_"
    }
}

function Import-NSMPlayer {
    param([string]$PlayerId)
    $FilePath = Join-Path "D:\NASRIUM\Data\Database\Players" "$PlayerId.json"
    if (!(Test-Path $FilePath)) {
        throw "Player data not found: $PlayerId"
    }
    try {
        return Get-Content $FilePath -Raw | ConvertFrom-Json
    } catch {
        throw "Failed to load player data: $_"
    }
}

Export-ModuleMember -Function Export-NSMPlayer, Import-NSMPlayer