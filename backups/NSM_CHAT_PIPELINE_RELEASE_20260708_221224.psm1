function Process-NSMChatMessage {
    param(
        [string]$Message
    )
    [PSCustomObject]@{
        Status="RECEIVED"
        Message=$Message
        Time=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

function Route-NSMChatMessage {
    param(
        [string]$Channel,
        [string]$Message
    )
    [PSCustomObject]@{
        Channel=$Channel
        Message=$Message
        Status="ACCEPTED"
        Time=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

function Validate-NSMChatMessage {
    param(
        [string]$Message
    )
    [PSCustomObject]@{
        Valid=($Message.Length -le 2000)
        Length=$Message.Length
        Reason=""
    }
}

function Invoke-NSMChatModeration {
    param(
        [string]$Message
    )
    [PSCustomObject]@{
        Status="PASS"
        Message=$Message
    }
}

function Send-NSMChatPipeline {
    param(
        [string]$Channel,
        [string]$Message
    )

    $Validation=Validate-NSMChatMessage -Message $Message

    if($Validation.Valid -eq $false){
        return [PSCustomObject]@{
            Status="REJECTED"
            Reason="MaximumLengthExceeded"
        }
    }

    return Route-NSMChatMessage -Channel $Channel -Message $Message
}

Export-ModuleMember -Function Process-NSMChatMessage,Route-NSMChatMessage,Validate-NSMChatMessage,Invoke-NSMChatModeration,Send-NSMChatPipeline
