function Receive-NSMResources {
    param($Player, [string]$BuildingType)
    
    $Building = $Player.Buildings | Where-Object { $_.Type -eq $BuildingType -and -not $_.Upgrading } | Select-Object -First 1
    if (-not $Building) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "BuildingNotFoundOrUpgrading" }
    }
    
    $Config = Get-NSMGameConfig
    $Yield = $Config.buildings.$BuildingType.levels."$($Building.Level)".yield_gold_per_cycle
    
    if (-not $Yield -or $Yield -eq 0) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "NoYieldDefined" }
    }
    
    $Player.Resources.Gold += $Yield
    return [PSCustomObject]@{ Status = "SUCCESS"; Building = $BuildingType; YieldAmount = $Yield; TotalGold = $Player.Resources.Gold }
}

Export-ModuleMember -Function Receive-NSMResources