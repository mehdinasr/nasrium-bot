<#
 NASRIUM CORE GAME ENGINE v1.0
#>

function Get-NSMGameConfig {
    $cPath = "D:\NASRIUM\Core\Config\NSM_GameConfig.json"
    if (Test-Path $cPath) { return Get-Content $cPath -Raw | ConvertFrom-Json }
    else { throw "Missing Config" }
}

function Get-UpgradeCost {
    param([string]$BType, [int]$CurrLvl, [int]$TgtLvl)
    $Conf = Get-NSMGameConfig
    $Cost = @{ Credits=0; Bandwidth=0 }
    for ($L = ($CurrLvl+1); $L -le $TgtLvl; $L++) {
        $k = "$L"
        if ($Conf.buildings.$BType.levels.$k) {
            $d = $Conf.buildings.$BType.levels.$k
            $Cost.Credits += $d.cost_gold
            $Cost.Bandwidth += $d.energy_cost_to_build
        } else {
            # Fallback Formula for dynamic balancing
            $Cost.Credits += [math]::Floor(500 * [math]::Pow($L, 1.5))
            $Cost.Bandwidth += [math]::Floor(10 * $L)
        }
    }
    return $Cost
}

function Test-Afford {
    param([object]$Res, [object]$Req)
    return ($Res.Credits -ge $Req.Credits) -and ($Res.Bandwidth -ge $Req.Bandwidth)
}

function Invoke-ResourceTick {
    param([object]$State)
    $Inc = @{ C=0; B=0 }
    foreach ($prop in $State.Buildings.PSObject.Properties) {
        if ($prop.Name -eq "DATA_MINER") { $Inc.C += ($prop.Value.Level * 5) }
        elseif ($prop.Name -eq "SERVER_FARM") { $Inc.B += ($prop.Value.Level * 2) }
    }
    return $Inc
}

Export-ModuleMember -Function Get-UpgradeCost, Test-Afford, Invoke-ResourceTick