function New-NSMShield {
    param($Player, [string]$Sku)
    
    $Config = Get-NSMGameConfig
    if (-not $Config.shop.$Sku) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopItem" }
    }
    
    $Item = $Config.shop.$Sku
    $Cost = $Item.cost_nsm_soft
    
    if ($Player.Resources.NSM_Soft -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }
    }
    
    # Deduct Cost & Apply Shield
    $Player.Resources.NSM_Soft -= $Cost
    $Player.Shields += 1
    
    return [PSCustomObject]@{ Status = "SUCCESS"; Item = $Sku; DurationHours = $Item.duration_hours; TotalShields = $Player.Shields }
}

function New-NSMNft {
    param($Player, [string]$Sku)
    
    $Config = Get-NSMGameConfig
    if (-not $Config.shop.$Sku) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidShopItem" }
    }
    
    $Item = $Config.shop.$Sku
    $Cost = $Item.cost_nsm_withdraw
    
    if ($Player.Resources.NSM_Withdraw -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }
    }
    
    if ($Player.WalletAddress -eq "") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotLinked" }
    }
    
    # Deduct Cost & Mint NFT record
    $Player.Resources.NSM_Withdraw -= $Cost
    
    $NftId = [guid]::NewGuid().ToString()
    $Player.Nfts += [PSCustomObject]@{ Id = $NftId; Type = $Sku; Status = "PendingTransfer" }
    
    return [PSCustomObject]@{ Status = "SUCCESS"; Item = $Sku; NftId = $NftId; DestinationWallet = $Player.WalletAddress }
}

Export-ModuleMember -Function New-NSMShield, New-NSMNft