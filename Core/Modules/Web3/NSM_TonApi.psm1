function Get-NSMTonWalletBalance {
    param([string]$WalletAddress)
    
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_TonConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "TON config missing." }
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    
    if ($Config.api_key -eq "YOUR_TONCENTER_API_KEY_HERE") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "TonApiKeyNotConfigured" }
    }
    
    $Url = "$($Config.api_base_url)getAddressBalance"
    $Query = @{ address = $WalletAddress; api_key = $Config.api_key }
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Get -Body $Query -ErrorAction Stop
        if ($Response.ok) {
            $BalanceNanoTon = $Response.result
            $BalanceTon = [math]::Round($BalanceNanoTon / 1000000000, 9)
            return [PSCustomObject]@{ Status = "SUCCESS"; Balance = $BalanceTon; Address = $WalletAddress }
        } else {
            return [PSCustomObject]@{ Status = "FAILED"; Reason = "API returned error" }
        }
    } catch {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = $_.Exception.Message }
    }
}

Export-ModuleMember -Function Get-NSMTonWalletBalance