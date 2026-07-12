function Register-NSMWallet {
    param($Player, [string]$WalletAddress)
    
    if ($Player.WalletAddress -ne "") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "WalletAlreadyLinked" }
    }
    
    if ($WalletAddress -notmatch "^EQ" -and $WalletAddress -notmatch "^UQ") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "InvalidTonAddressFormat" }
    }
    
    $Player.WalletAddress = $WalletAddress
    return [PSCustomObject]@{ Status = "SUCCESS"; LinkedWallet = $WalletAddress }
}

Export-ModuleMember -Function Register-NSMWallet