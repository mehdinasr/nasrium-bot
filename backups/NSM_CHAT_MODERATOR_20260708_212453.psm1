
function Verify-NSMChatMessage {

    param(
        [string]$Message
    )


    $Result=[ordered]@{

        Status="PASS"

        Message=$Message

        Violations=@()

        Time=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }


    if([string]::IsNullOrWhiteSpace($Message)){

        $Result.Status="BLOCK"

        $Result.Violations+= "EmptyMessage"

    }


    return [PSCustomObject]$Result

}

function Get-NSMChatReport {
    return [PSCustomObject]@{
        Checked=0
        Warning=0
        Blocked=0
        Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}


function Load-NSMModerationSchema {

    param()

    if(!(Test-Path "D:\NASRIUM\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json")){
        
        throw "Moderation schema not found"

    }


    return Get-Content "D:\NASRIUM\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_SCHEMA_V1.json" -Raw | ConvertFrom-Json

}


function Test-NSMSpam {

    param(
        [string]$Message,
        [int]$Limit=5
    )


    $Result=[ordered]@{

        IsSpam=$false

        Reason=""

    }


    if($Message.Length -gt 500){

        $Result.IsSpam=$true

        $Result.Reason="MessageLengthExceeded"

    }


    return [PSCustomObject]$Result

}


function Test-NSMBadWords {

    param(
        [string]$Message
    )


    $Schema=Load-NSMModerationSchema


    $Result=[ordered]@{

        Detected=$false

        Words=@()

    }


    if($null -ne $Schema.Rules){

        foreach($Rule in $Schema.Rules){

            if($Rule.Name -eq "BadWordFilter"){

                # Reserved for word list integration

                break

            }

        }

    }


    return [PSCustomObject]$Result

}


function Get-NSMChatReport {

    param()


    $Report=[ordered]@{

        Module="CMD_092"

        Checked=0

        Warning=0

        Blocked=0

        Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    }


    if(!(Test-Path "D:\NASRIUM\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_REPORT_V1.json")){

        $Report |
        ConvertTo-Json -Depth 20 |
        Set-Content "D:\NASRIUM\Data\Systems\Chat\Moderation\NSM_CHAT_MODERATION_REPORT_V1.json" -Encoding UTF8

    }


    return [PSCustomObject]$Report

}

Export-ModuleMember -Function Verify-NSMChatMessage,Get-NSMChatReport





