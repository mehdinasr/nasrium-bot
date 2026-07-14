function New-NSMVipSubscription {
    param($Player, [ValidateSet("silver", "gold", "premium")][string]$Tier)
    
    $Config = Get-NSMGameConfig
    $TierConfig = $Config.vip.$Tier
    
    if (-not $TierConfig) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidVipTier" }
    }
    
    $Cost = $TierConfig.cost_nsm_withdraw
    
    if ($Player.Resources.NSM_Withdraw -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }
    }
    
    # Deduct Cost
    $Player.Resources.NSM_Withdraw -= $Cost
    
    # Apply VIP Status
    $Player.VipTier = $Tier
    $Expiry = (Get-Date).AddDays($TierConfig.duration_days)
    $Player.VipExpiry = $Expiry.ToString("yyyy-MM-dd HH:mm:ss")
    
    return [PSCustomObject]@{
        Status = "SUCCESS"
        Tier = $Tier
        Expiry = $Player.VipExpiry
        ProductionBoost = $TierConfig.boost_production
        EnergyBoost = $TierConfig.energy_cap_boost
        CostPaid = $Cost
    }
}

Export-ModuleMember -Function New-NSMVipSubscription