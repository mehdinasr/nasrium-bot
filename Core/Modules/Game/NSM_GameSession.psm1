function Invoke-NSMGameTransaction {
    param($Player, [scriptblock]$Action)
    
    $OriginalGold = $Player.Resources.Gold
    $OriginalBuildings = $Player.Buildings | ConvertTo-Json -Depth 3 | ConvertFrom-Json
    
    try {
        $Result = & $Action
        if ($Result.Status -eq "FAILED") {
            throw "Action failed: $($Result.Reason)"
        }
        Export-NSMPlayer -Player $Player | Out-Null
        return $Result
    }
    catch {
        # Rollback State
        $Player.Resources.Gold = $OriginalGold
        $Player.Buildings = $OriginalBuildings
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TransactionRolledBack"; Error = $_.Exception.Message }
    }
}

Export-ModuleMember -Function Invoke-NSMGameTransaction