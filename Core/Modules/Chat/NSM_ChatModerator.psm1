function Verify-NSMChatMessage {
    param([string]$Message)
    $Config = Get-NSMChatConfig
    $Blacklist = $Config.blacklist
    $Result = [ordered]@{ Status = "PASS"; Reason = ""; Severity = 0 }
    foreach ($Word in $Blacklist) {
        if ($Message -match $Word) {
            $Result.Status = "BLOCKED"
            $Result.Reason = "BlacklistedWordDetected"
            $Result.Severity = 10
            break
        }
    }
    return [PSCustomObject]$Result
}

Export-ModuleMember -Function Verify-NSMChatMessage