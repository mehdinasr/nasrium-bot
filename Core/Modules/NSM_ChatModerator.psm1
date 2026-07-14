# ================================================================================
# NASRIUM CHAT MODERATOR MODULE (PATCHED v1.2 - UNICODE COMPATIBLE)
# ================================================================================
function Initialize-NSMChatModerator {
    [CmdletBinding()]
    param ([Parameter(Mandatory=$true)][string]$SchemaPath)
    process {
        if (!(Test-Path $SchemaPath)) {
            throw "Schema file not found: $SchemaPath"
        }
        $global:NSM_ChatSchema = Get-Content $SchemaPath -Raw | ConvertFrom-Json
        Write-Verbose "NASRIUM Chat Moderator initialized successfully with Unicode Patch v1.2."
    }
}

function Test-NSMChatMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$true)][string]$UserId
    )
    process {
        if (!$global:NSM_ChatSchema) {
            throw "Moderator engine is not initialized. Run Initialize-NSMChatModerator first."
        }

        # تحلیل طول پیام
        $MaxLen = 100
        if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["MaxMessageLength"]) {
            $MaxLen = $global:NSM_ChatSchema.MaxMessageLength
        } elseif ($null -ne $global:NSM_ChatSchema.PSObject.Properties["max_message_length"]) {
            $MaxLen = $global:NSM_ChatSchema.max_message_length
        }

        # استخراج کلمات ممنوعه
        $Words = @()
        if ($null -ne $global:NSM_ChatSchema.PSObject.Properties["BlockedWords"]) {
            $Words = $global:NSM_ChatSchema.BlockedWords
        } elseif ($null -ne $global:NSM_ChatSchema.PSObject.Properties["blocked_words"]) {
            $Words = $global:NSM_ChatSchema.blocked_words
        }

        $Result = [ordered]@{
            IsValid = $true
            Reason  = "APPROVED"
            Message = $Message
        }

        # بررسی طول پیام
        if ($Message.Length -gt $MaxLen) {
            $Result.IsValid = $false
            $Result.Reason = "MESSAGE_TOO_LONG"
            return [PSCustomObject]$Result
        }

        # بررسی کلمات ممنوعه (پشتیبانی کامل از کاراکترهای یونیکد و فارسی بدون وابستگی به \b)
        foreach ($Word in $Words) {
            if ($null -ne $Word -and $Word.Trim() -ne "") {
                # استفاده از متد بومی حاوی بودن رشته بدون حساسیت به حروف کوچک و بزرگ و سازگار با یونیکد
                if ($Message.ToLower().Contains($Word.ToLower())) {
                    $Result.IsValid = $false
                    $Result.Reason = "CONTAIN_BLOCKED_WORDS"
                    return [PSCustomObject]$Result
                }
            }
        }

        return [PSCustomObject]$Result
    }
}

Export-ModuleMember -Function Initialize-NSMChatModerator, Test-NSMChatMessage
