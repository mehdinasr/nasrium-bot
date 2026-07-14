<#
  NASRIUM GAME DOMAIN MODULE v2.0 (Cyberpunk Edition)
  Defines core objects: Player, Resource, Building, Syndicate.
#>

function New-NSMPlayer {
    param([string]$Username)
    return [PSCustomObject]@{
        Id            = [guid]::NewGuid().ToString()
        Username      = $Username
        Level         = 1
        XP            = 0
        Resources     = New-NSMResource
        Buildings     = @{} 
        WalletAddress = ""
        Firewalls     = 0  
        Nfts          = @()
        SyndicateId   = "" 
        VipTier       = "Free"
        VipExpiry     = $null
        CreatedAt     = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

function New-NSMResource {
    return [PSCustomObject]@{
        Credits       = 500   
        Bandwidth     = 100   
        DataShards    = 0     
        NSM_Token     = 0     
    }
}

function New-NSMBuilding {
    param(
        [string]$Type,
        [int]$Level = 1,
        [bool]$IsUpgrading = $false
    )
    return [PSCustomObject]@{
        Type        = $Type
        Level       = $Level
        IsUpgrading = $IsUpgrading
        UpgradeEnds = $null
    }
}

function New-NSMSyndicate {
    param([string]$Name, [string]$LeaderId)
    return [PSCustomObject]@{
        Id           = [guid]::NewGuid().ToString()
        Name         = $Name
        LeaderId     = $LeaderId
        Members      = @($LeaderId)
        BankCredits  = 0
        BankData     = 0
        Level        = 1
        CreatedAt    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

Export-ModuleMember -Function New-NSMPlayer, New-NSMResource, New-NSMBuilding, New-NSMSyndicate