function Invoke-NSMGameCommand {
    param([string]$ChatId, [string]$CommandText)
    
    $Parts = $CommandText -split " "
    $Cmd = $Parts[0].ToLower()
    $Arg1 = if ($Parts.Length -gt 1) { $Parts[1] } else { "" }
    $Arg2 = if ($Parts.Length -gt 2) { $Parts[2] } else { "" }
    $Arg3 = if ($Parts.Length -gt 3) { $Parts[3] } else { "" }
    
    $Player = $null
    try {
        $Player = Import-NSMPlayer -PlayerId $ChatId
    } catch {
        $Player = New-NSMPlayer -Username "TG_$ChatId"
        $Player.Id = $ChatId
        Export-NSMPlayer -Player $Player | Out-Null
    }
    
    $ResponseText = ""
    
    switch ($Cmd) {
        "/start" {
            $ResponseText = "Welcome to NASRIUM! Use /build, /claim, /status, /shop, /vip, /clan, or /ask."
        }
        "/status" {
            $ResponseText = "=== STATUS ===`r`nLevel: $($Player.Level)`r`nVIP: $($Player.VipTier)`r`nGold: $($Player.Resources.Gold)`r`nEnergy: $($Player.Resources.Energy)`r`nSoft: $($Player.Resources.NSM_Soft)`r`nWithdraw: $($Player.Resources.NSM_Withdraw)"
        }
        "/build" {
            if (-not $Arg1) { $ResponseText = "Usage: /build <BuildingType>"; break }
            $Result = Start-NSMBuildingUpgrade -Player $Player -BuildingType $Arg1
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "SUCCESS: $Arg1 upgraded. Gold: $($Result.RemainingGold)"
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        "/claim" {
            if (-not $Arg1) { $ResponseText = "Usage: /claim <BuildingType>"; break }
            $Building = $Player.Buildings | Where-Object { $_.Type -eq $Arg1 } | Select-Object -First 1
            if ($Building) { $Building.Upgrading = $false }
            $Result = Receive-NSMResources -Player $Player -BuildingType $Arg1
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "SUCCESS: Claimed $($Result.YieldAmount) Gold."
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        "/vip" {
            if (-not $Arg1) { $ResponseText = "Usage: /vip <silver|gold|premium>"; break }
            $Result = New-NSMVipSubscription -Player $Player -Tier $Arg1
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "SUCCESS: VIP $($Result.Tier) activated until $($Result.Expiry)"
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        "/clan" {
            if ($Arg1 -eq "create" -and $Arg2) {
                $Result = New-NSMPlayerClan -Player $Player -ClanName $Arg2
                if ($Result.Status -eq "SUCCESS") {
                    Export-NSMPlayer -Player $Player | Out-Null
                    $ResponseText = "SUCCESS: Clan $($Result.ClanName) created!"
                } else { $ResponseText = "FAILED: $($Result.Reason)" }
            }
            elseif ($Arg1 -eq "donate" -and $Arg2 -and $Arg3) {
                $Amount = [decimal]$Arg3
                $Result = Submit-NSMClanDonation -Player $Player -Amount $Amount -Type $Arg2
                if ($Result.Status -eq "SUCCESS") {
                    Export-NSMPlayer -Player $Player | Out-Null
                    $ResponseText = "SUCCESS: Donated $($Result.Amount) $($Result.Type)."
                } else { $ResponseText = "FAILED: $($Result.Reason)" }
            }
            else { $ResponseText = "Usage: /clan create <name> | /clan donate <Gold|NSM_Soft> <amount>" }
        }
        "/shop" {
            if (-not $Arg1 -or -not $Arg2) { $ResponseText = "Usage: /shop <shield|nft> <sku>"; break }
            if ($Arg1 -eq "shield") {
                $Result = New-NSMShield -Player $Player -Sku $Arg2
            } elseif ($Arg1 -eq "nft") {
                $Result = New-NSMNft -Player $Player -Sku $Arg2
            } else { $Result = [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopCategory" } }
            
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "SUCCESS: Purchased $Arg1 $Arg2."
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        "/speedup" {
            if (-not $Arg1) { $ResponseText = "Usage: /speedup <BuildingType>"; break }
            $Result = Complete-NSMInstantUpgrade -Player $Player -BuildingType $Arg1
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "SUCCESS: $Arg1 completed instantly! ($($Result.CostPaid) NSM_W spent)"
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        "/buyton" {
            # MOCK: Simulates buying NSM_Withdraw with TON
            # In production, this triggers TON Payment Gateway
            Grant-NSMToken -Player $Player -Amount 100 -TokenType NSM_Withdraw | Out-Null
            Export-NSMPlayer -Player $Player | Out-Null
            $ResponseText = "SUCCESS: +100 NSM_Withdraw added (Mock TON Payment)."
        }
        "/ask" {
            if (-not $Arg1 -or -not $Arg2) { $ResponseText = "Usage: /ask <faq|simple|advanced> <question>"; break }
            $Tier = $Arg1
            $Query = $CommandText.Substring($CommandText.IndexOf($Arg2))
            $Result = Request-NSMAiSupport -Player $Player -Query $Query -Tier $Tier
            if ($Result.Status -eq "SUCCESS") {
                Export-NSMPlayer -Player $Player | Out-Null
                $ResponseText = "$($Result.Response) (Cost: $($Result.TokensSpent) NSM_Soft)"
            } else { $ResponseText = "FAILED: $($Result.Reason)" }
        }
        default { $ResponseText = "Unknown command. Use /start for help." }
    }
    return $ResponseText
}

Export-ModuleMember -Function Invoke-NSMGameCommand