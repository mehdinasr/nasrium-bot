function New-NSMPlayerClan {
    param($Player, [string]$ClanName)
    
    $Config = Get-NSMGameConfig
    $Cost = $Config.clan.creation_cost_gold
    
    if ($Player.Resources.Gold -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }
    }
    
    if ($Player.ClanId -ne "") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "AlreadyInClan" }
    }
    
    # Deduct Cost & Create Clan
    $Player.Resources.Gold -= $Cost
    $Clan = New-NSMClan -Name $ClanName -LeaderId $Player.Id
    $Player.ClanId = $Clan.Id
    
    # Save Clan to Disk (Simulated DB)
    $ClanDir = "D:\NASRIUM\Data\Database\Clans"
    if (!(Test-Path $ClanDir)) { New-Item -ItemType Directory -Path $ClanDir -Force | Out-Null }
    $Clan | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $ClanDir "$($Clan.Id).json") -Encoding UTF8
    
    return [PSCustomObject]@{ Status = "SUCCESS"; ClanId = $Clan.Id; ClanName = $Clan.Name }
}

function Submit-NSMClanDonation {
    param($Player, [decimal]$Amount, [ValidateSet("Gold", "NSM_Soft")]$Type = "Gold")
    
    if ($Player.ClanId -eq "") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "NotInClan" }
    }
    
    if ($Type -eq "Gold" -and $Player.Resources.Gold -lt $Amount) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientGold" }
    }
    
    if ($Type -eq "NSM_Soft" -and $Player.Resources.NSM_Soft -lt $Amount) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }
    }
    
    # Deduct from Player
    if ($Type -eq "Gold") { $Player.Resources.Gold -= $Amount }
    if ($Type -eq "NSM_Soft") { $Player.Resources.NSM_Soft -= $Amount }
    
    # Add to Clan Bank (Simulated)
    $ClanDir = "D:\NASRIUM\Data\Database\Clans"
    $ClanPath = Join-Path $ClanDir "$($Player.ClanId).json"
    $Clan = Get-Content $ClanPath -Raw | ConvertFrom-Json
    if ($Type -eq "Gold") { $Clan.BankGold += $Amount }
    if ($Type -eq "NSM_Soft") { $Clan.BankSoft += $Amount }
    $Clan | ConvertTo-Json -Depth 3 | Set-Content $ClanPath -Encoding UTF8
    
    return [PSCustomObject]@{ Status = "SUCCESS"; Amount = $Amount; Type = $Type }
}

Export-ModuleMember -Function New-NSMPlayerClan, Submit-NSMClanDonation