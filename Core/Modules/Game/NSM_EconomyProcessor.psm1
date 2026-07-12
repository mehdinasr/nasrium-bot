<#
 NASRIUM ECONOMY PROCESSOR v1.0
 Handles time-based resource generation (Offline Progress).
#>

# Import dependencies (Assuming they are in the same directory)
Import-Module (Join-Path $PSScriptRoot "NSM_GameEngine.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "NSM_GameRepo.psm1") -Force

function Invoke-PlayerEconomyTick {
    param([Parameter(Mandatory=$true)]$PlayerState)
    
    # 1. Calculate Time Delta
    $Now = Get-Date
    try {
        $LastLogin = [datetime]::Parse($PlayerState.LastLogin)
    } catch {
        # Fallback if date is corrupted
        $LastLogin = $Now
    }
    
    $Delta = $Now - $LastLogin
    
    # 2. Cap offline time (Max 24 hours to prevent insane exploits)
    if ($Delta.TotalHours -gt 24) { $Delta = [timespan]::FromHours(24) }
    
    # 3. Get Income Rate from Engine
    $IncomePerSec = Invoke-ResourceTick -State $PlayerState
    
    # 4. Calculate Total Earned Resources
    $SecondsPassed = [math]::Floor($Delta.TotalSeconds)
    $EarnedCredits = $IncomePerSec.C * $SecondsPassed
    $EarnedBandwidth = $IncomePerSec.B * $SecondsPassed
    
    # 5. Apply to Player State
    $PlayerState.Resources.Credits += $EarnedCredits
    $PlayerState.Resources.Bandwidth += $EarnedBandwidth
    $PlayerState.LastLogin = $Now.ToString("yyyy-MM-dd HH:mm:ss")
    
    return $PlayerState
}

Export-ModuleMember -Function Invoke-PlayerEconomyTick