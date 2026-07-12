function Use-NSMEnergy {
    param($Player, [int]$Amount)
    if ($Player.Resources.Energy -lt $Amount) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientEnergy" }
    }
    $Player.Resources.Energy -= $Amount
    return [PSCustomObject]@{ Status = "SUCCESS"; SpentEnergy = $Amount; RemainingEnergy = $Player.Resources.Energy }
}

function Repair-NSMEnergy {
    param($Player, [int]$Amount)
    $Config = Get-NSMGameConfig
    $MaxEnergy = $Config.economy.initial_energy
    $Player.Resources.Energy = [math]::Min(($Player.Resources.Energy + $Amount), $MaxEnergy)
    return [PSCustomObject]@{ Status = "SUCCESS"; RepairedEnergy = $Amount; TotalEnergy = $Player.Resources.Energy }
}

Export-ModuleMember -Function Use-NSMEnergy, Repair-NSMEnergy