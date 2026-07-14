function New-NSMAgent {
    param([string]$Name, [string[]]$Capabilities)
    return [PSCustomObject]@{
        AgentId = [guid]::NewGuid().ToString()
        Name = $Name
        Capabilities = $Capabilities
        Status = "IDLE"
        CreatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

function Invoke-NSMAgentTask {
    param($Agent, [string]$TaskPrompt)
    
    if ($Agent.Status -ne "IDLE") {
        return [PSCustomObject]@{ Status = "FAILED"; Reason = "AgentBusy" }
    }
    
    $ConfigPath = "D:\NASRIUM\Core\Config\NSM_AiConfig.json"
    if (!(Test-Path $ConfigPath)) { throw "AI config missing." }
    $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    
    if ($Config.api_key -eq "YOUR_AI_API_KEY_HERE") {
        # Mock execution for infrastructure testing
        $Agent.Status = "PROCESSING"
        Start-Sleep -Milliseconds 100
        $Agent.Status = "IDLE"
        return [PSCustomObject]@{ Status = "SUCCESS"; Result = "MOCK_RESPONSE: Processed task for $($Agent.Name)"; TokensUsed = 0 }
    }
    
    # Future: Actual API Integration (OpenAI, Gemini, etc.)
    return [PSCustomObject]@{ Status = "FAILED"; Reason = "ProviderNotImplemented" }
}

Export-ModuleMember -Function New-NSMAgent, Invoke-NSMAgentTask