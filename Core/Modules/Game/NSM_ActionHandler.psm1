<#
 NASRIUM ACTION HANDLER v1.0
 Processes player commands (e.g., Upgrade Building).
#>

Import-Module (Join-Path $PSScriptRoot "NSM_GameEngine.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "NSM_GameRepo.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "NSM_EconomyProcessor.psm1") -Force

function Start-NSMBuildingUpgrade {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PlayerId,
        [Parameter(Mandatory=$true)]
        [string]$BuildingType
    )
    
    # 1. Load Player State
    $Player = Get-NSMPlayer -Id $PlayerId
    if (-not $Player) { return @{ Success=$false; Message="Player not found" } }
    
    # 2. Apply Pending Economy (Add offline resources first)
    $Player = Invoke-PlayerEconomyTick -PlayerState $Player
    
    # 3. Determine Current Level
    $CurrLvl = 0
    if ($Player.Buildings.PSObject.Properties.Match($BuildingType).Count -gt 0) {
        $CurrLvl = $Player.Buildings.$BuildingType.Level
    }
    $TargetLvl = $CurrLvl + 1
    
    # 4. Calculate Cost
    $Cost = Get-UpgradeCost -BType $BuildingType -CurrLvl $CurrLvl -TgtLvl $TargetLvl
    
    # 5. Check Affordability
    $CanAfford = Test-Afford -Res $Player.Resources -Req $Cost
    
    if (-not $CanAfford) {
        # Save the economy tick state even if upgrade fails
        Save-NSMPlayer -PlayerObject $Player | Out-Null
        return @{ Success=$false; Message="Insufficient Resources"; Required=$Cost; Current=$Player.Resources }
    }
    
    # 6. Execute Upgrade: Deduct Resources
    $Player.Resources.Credits -= $Cost.Credits
    $Player.Resources.Bandwidth -= $Cost.Bandwidth
    
    # 7. Update Building Level
    if ($CurrLvl -eq 0) {
        # New Building
    $Player.Buildings | Add-Member -NotePropertyName $BuildingType -NotePropertyValue @{ Level=$TargetLvl; IsUpgrading=$false }
    } else {
        # Existing Building
    $Player.Buildings.$BuildingType.Level = $TargetLvl
    }
    
    # 8. Save New State
    $SaveStatus = Save-NSMPlayer -PlayerObject $Player
    
    if ($SaveStatus) {
        return @{ Success=$true; Message="Upgrade Successful"; NewLevel=$TargetLvl; RemainingResources=$Player.Resources }
    } else {
        return @{ Success=$false; Message="Failed to save state to disk" }
    }
}

Export-ModuleMember -Function Start-NSMBuildingUpgrade