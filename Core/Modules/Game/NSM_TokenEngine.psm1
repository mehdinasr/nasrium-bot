function Use-NSMToken {
    param($Player, [decimal]$Amount, [ValidateSet("NSM_Soft", "NSM_Withdraw")]$TokenType = "NSM_Soft")
    if ($Player.Resources.$TokenType -lt $Amount) {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InsufficientTokens" }
    }
    $Player.Resources.$TokenType -= $Amount
    return [PSCustomObject]@{ Status = "SUCCESS"; Spent = $Amount; Type = $TokenType; Remaining = $Player.Resources.$TokenType }
}

function Grant-NSMToken {
    param($Player, [decimal]$Amount, [ValidateSet("NSM_Soft", "NSM_Withdraw")]$TokenType = "NSM_Soft")
    $Player.Resources.$TokenType += $Amount
    return [PSCustomObject]@{ Status = "SUCCESS"; Rewarded = $Amount; Type = $TokenType; Total = $Player.Resources.$TokenType }
}

Export-ModuleMember -Function Use-NSMToken, Grant-NSMToken