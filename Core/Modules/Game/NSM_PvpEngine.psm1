function Invoke-NSMPvpAttack {
    param($Attacker, $Defender)
    
    # 1. Check if Defender has Shields
    if ($Defender.Shields -gt 0) {
        $Defender.Shields -= 1
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "DefenderWasShielded"; ShieldConsumed = $true }
    }
    
    # 2. Calculate Loot (20% of unshielded Gold & Soft Token)
    $LootGold = [math]::Floor($Defender.Resources.Gold * 0.20)
    $LootSoft = [math]::Floor($Defender.Resources.NSM_Soft * 0.20)
    
    if ($LootGold -eq 0 -and $LootSoft -eq 0) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "DefenderHasNoLoot" }
    }
    
    # 3. Transfer Resources
    $Defender.Resources.Gold -= $LootGold
    $Defender.Resources.NSM_Soft -= $LootSoft
    
    $Attacker.Resources.Gold += $LootGold
    $Attacker.Resources.NSM_Soft += $LootSoft
    
    return [PSCustomObject]@{
        Status = "SUCCESS"
        LootGold = $LootGold
        LootSoftToken = $LootSoft
        AttackerTotalGold = $Attacker.Resources.Gold
        DefenderTotalGold = $Defender.Resources.Gold
    }
}

Export-ModuleMember -Function Invoke-NSMPvpAttack