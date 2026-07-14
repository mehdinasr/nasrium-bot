# ================================================================================
# NASRIUM CHAT SERVICE MODULE
# ================================================================================
function New-NSMChatChannel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ChannelName,
        [Parameter(Mandatory=$true)][string]$ChannelType
    )
    process {
        if ($null -eq $global:NSM_ChatChannels) {
            $global:NSM_ChatChannels = @{}
        }
        $ChannelId = "CH_" + (Get-Date -Format "yyyyMMdd") + "_" + $ChannelName.ToUpper()
        $global:NSM_ChatChannels[$ChannelId] = [ordered]@{
            ChannelId   = $ChannelId
            ChannelName = $ChannelName
            ChannelType = $ChannelType
            CreatedTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Active      = $true
        }
        return [PSCustomObject]$global:NSM_ChatChannels[$ChannelId]
    }
}

function Send-NSMChatMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ChannelId,
        [Parameter(Mandatory=$true)][string]$UserId,
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$true)][string]$LogDirPath
    )
    process {
        # ارزیابی پیام توسط ماژول تعدیل چت در صورت در دسترس بودن
        if (Get-Command Test-NSMChatMessage -ErrorAction SilentlyContinue) {
            $ModerationResult = Test-NSMChatMessage -Message $Message -UserId $UserId
            if (-not $ModerationResult.IsValid) {
                return [PSCustomObject]@{
                    Status     = "REJECTED"
                    Reason     = $ModerationResult.Reason
                    Message    = $Message
                    Timestamp  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    AuditHash  = $null
                }
            }
        }

        $MsgId = [Guid]::NewGuid().ToString()
        $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $Payload = [ordered]@{
            MessageId = $MsgId
            ChannelId = $ChannelId
            UserId    = $UserId
            Message   = $Message
            Timestamp = $Timestamp
        }
        
        if (!(Test-Path $LogDirPath)) {
            New-Item -ItemType Directory -Path $LogDirPath -Force | Out-Null
        }
        
        $TargetLogFile = Join-Path $LogDirPath "$ChannelId`_History.json"
        $ChannelLogs = @()
        if (Test-Path $TargetLogFile) {
            $ChannelLogs = Get-Content $TargetLogFile -Raw | ConvertFrom-Json
        }
        
        $ChannelLogsList = [System.Collections.ArrayList]@($ChannelLogs)
        [void]$ChannelLogsList.Add($Payload)
        $ChannelLogsList | ConvertTo-Json -Depth 20 | Set-Content $TargetLogFile -Encoding UTF8 -Force

        return [PSCustomObject]@{
            Status     = "SUCCESS"
            Reason     = "APPROVED"
            Message    = $Message
            Timestamp  = $Timestamp
            AuditHash  = (Get-FileHash $TargetLogFile -Algorithm SHA256).Hash
        }
    }
}

Export-ModuleMember -Function New-NSMChatChannel, Send-NSMChatMessage
