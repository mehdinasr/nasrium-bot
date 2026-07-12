function Process-NSMChatMessage {
    param([string]$Message)
    return [PSCustomObject]@{ Status = "RECEIVED"; Message = $Message; ProcessedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }
}

function Route-NSMChatMessage {
    param([string]$Channel, [string]$Message)
    return [PSCustomObject]@{ Channel = $Channel; Message = $Message; RouteStatus = "ACCEPTED"; RoutedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }
}

function Validate-NSMChatMessage {
    param([string]$Message)
    $Config = Get-NSMChatConfig
    $MaxLength = $Config.max_message_length
    $Result = [ordered]@{ Valid = $true; Length = $Message.Length; Reason = "" }
    if ([string]::IsNullOrWhiteSpace($Message)) { $Result.Valid = $false; $Result.Reason = "EmptyMessage" }
    elseif ($Message.Length -gt $MaxLength) { $Result.Valid = $false; $Result.Reason = "MaximumLengthExceeded" }
    return [PSCustomObject]$Result
}

function Invoke-NSMChatModeration {
    param([string]$Message)
    $ModeratorPath = "D:\NASRIUM\Core\Modules\Chat\NSM_ChatModerator.psm1"
    if (Test-Path $ModeratorPath) {
        Import-Module $ModeratorPath -Force
        return Verify-NSMChatMessage -Message $Message
    }
    return [PSCustomObject]@{ Status = "SKIPPED"; Reason = "ModeratorModuleNotFound" }
}

function Send-NSMChatPipeline {
    param([string]$Channel, [string]$Message)
    $Config = Get-NSMChatConfig
    if ($Config.channels -notcontains $Channel) {
        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = "InvalidChannel" }
    }
    $Validation = Validate-NSMChatMessage -Message $Message
    if ($Validation.Valid -eq $false) {
        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = $Validation.Reason }
    }
    $Moderation = Invoke-NSMChatModeration -Message $Message
    if ($Moderation.Status -eq "BLOCKED") {
        return [PSCustomObject]@{ Status = "REJECTED"; Channel = $Channel; Reason = $Moderation.Reason }
    }
    $Route = Route-NSMChatMessage -Channel $Channel -Message $Message
    return [PSCustomObject]@{ Status = "DELIVERED"; Channel = $Route.Channel; Message = $Route.Message; Time = $Route.RoutedTime }
}

Export-ModuleMember -Function Process-NSMChatMessage, Route-NSMChatMessage, Validate-NSMChatMessage, Invoke-NSMChatModeration, Send-NSMChatPipeline