function Complete-NSMInstantUpgrade {
    param($Player, [string]$BuildingType)
    
    $Building = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType -and $_.Upgrading -eq $true } | Select-Object -First 1
    if (-not $Building) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BuildingNotFoundOrNotUpgrading" }
    }
    
    $Config = Get-NSMGameConfig
    $Cost = $Config.economy.instant_build_cost_nsm_withdraw
    
    if ($Player.Resources.NSM_Withdraw -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientWithdrawToken" }
    }
    
    # Deduct Cost & Complete Upgrade
    $Player.Resources.NSM_Withdraw -= $Cost
    $Building.Upgrading = $false
    
    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; CostPaid = $Cost }
}

Export-ModuleMember -Function Complete-NSMInstantUpgrade