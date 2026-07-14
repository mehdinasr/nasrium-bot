function Find-NSMTonDeposit {
    param([string]$PlayerId)
    
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TonConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "TON config missing." }
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    
    if ($Config.api_key -eq "YOUR_TONCENTER_API_KEY_HERE") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TonApiKeyNotConfigured" }
    }
    
    $Wallet = $Config.project_treasury_wallet
    $Url = "$($Config.api_base_url)getTransactions"
    $Query = @{ address = $Wallet; api_key = $Config.api_key; limit = 10 }
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Get -Body $Query -ErrorAction Stop
        if ($Response.ok) {
            foreach ($tx in $Response.result) {
                # Check if memo matches PlayerId and amount is valid
                if ($tx.in_msg.message -eq $PlayerId -and $tx.in_msg.value -gt 0) {
                    $TonAmount = $tx.in_msg.value / 1000000000
                    return [PSCustomObject]@{ Status = "SUCCESS"; AmountTON = $TonAmount; TxHash = $tx.transaction_id.hash }
                }
            }
            return [PSCustomObject]@{ Status = "PENDING"; Reason = "TransactionNotFoundYet" }
        } else {
            return [PSCustomObject]@{ Status = "FAILED"; Reason = "API Error" }
        }
    } catch {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }
    }
}

Export-ModuleMember -Function Find-NSMTonDeposit