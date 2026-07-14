function Request-NSMAiSupport {
    param($Player, [string]$Query, [string]$Tier = "simple")
    
    $Config = Get-NSMGameConfig
    if (-not $Config.ai_support.$Tier) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidAiTier" }
    }
    
    $Cost = $Config.ai_support.$Tier.cost_nsm_soft
    
    if ($Player.Resources.NSM_Soft -lt $Cost) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientSoftToken" }
    }
    
    # Deduct Cost
    $Player.Resources.NSM_Soft -= $Cost
    
    # Mock AI Response (Future: API Integration)
    $Response = "AI_RESPONSE ($Tier): Analysis of your query '$Query' is complete. Optimize your GoldMines first."
    
    return [PSCustomObject]@{ Status = "SUCCESS"; Response = $Response; TokensSpent = $Cost }
}

Export-ModuleMember -Function Request-NSMAiSupport