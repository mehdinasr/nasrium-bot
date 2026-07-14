function Request-NSMWithdrawal {
    param($Player)
    
    $Config = Get-NSMGameConfig
    
    # 1. Check Town Hall Level >= 3
    $TownHall = $Player.Buildings | Where-Object { $_.Type -eq "TownHall" } | Select-Object -First 1
    if (-not $TownHall -or $TownHall.Level -lt 3) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotUnlockedRequiresTH3" }
    }
    
    # 2. Check Wallet Linked
    if ($Player.WalletAddress -eq "") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletNotLinked" }
    }
    
    # 3. Check Balance
    if ($Player.Resources.NSM_Withdraw -le 0) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawBalance" }
    }
    
    # 4. Calculate Rate based on TH Level
    $ThLevelStr = $TownHall.Level.ToString()
    if (-not $Config.economy.withdraw_rates.$ThLevelStr) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WithdrawRateNotDefined" }
    }
    $Rate = $Config.economy.withdraw_rates.$ThLevelStr
    
    # 5. Calculate Amounts
    $MaxWithdrawable = $Player.Resources.NSM_Withdraw * ($Rate / 100)
    $ActualWithdraw = [math]::Floor($MaxWithdrawable)
    
    if ($ActualWithdraw -le 0) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WithdrawAmountTooLow" }
    }
    
    # 6. Deduct Balance
    $Player.Resources.NSM_Withdraw -= $ActualWithdraw
    
    return [PSCustomObject]@{
        Status = "SUCCESS"
        WithdrawAmount = $ActualWithdraw
        FeePercentage = $Rate
        DestinationWallet = $Player.WalletAddress
        RemainingBalance = $Player.Resources.NSM_Withdraw
    }
}

Export-ModuleMember -Function Request-NSMWithdrawal