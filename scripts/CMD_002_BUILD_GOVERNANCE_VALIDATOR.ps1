# ================================================================================
# NASRIUM PROJECT
# CMD_002_BUILD_GOVERNANCE_VALIDATOR
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

. "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

Invoke-NasriumCommand -CmdId "CMD_002" -Action {

    $Root = "D:\NASRIUM"
    $SystemPath = Join-Path $Root "Core\Modules\System"

@"
function Test-NSMGovernanceIntegrity {

    `$GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"
    `$ManifestPath = Join-Path `$GovPath "08_PROJECT_MANIFEST.json"

    if (!(Test-Path `$ManifestPath)) {
        throw "Governance Manifest missing."
    }

    `$manifest = Get-Content `$ManifestPath -Raw | ConvertFrom-Json

    foreach (`$file in `$manifest.files) {

        `$filePath = Join-Path `$GovPath `$file.name

        if (!(Test-Path `$filePath)) {
            throw "Required file missing: `$(`$file.name)"
        }

        `$bytes = [System.IO.File]::ReadAllBytes(`$filePath)
        `$hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash(`$bytes)
        `$hashStr = ([System.BitConverter]::ToString(`$hash)).Replace("-", "").ToLower()

        if (`$hashStr -ne `$file.sha256) {
            throw "Integrity violation detected in: `$(`$file.name)"
        }
    }

    return `$true
}
"@ | Set-Content (Join-Path $SystemPath "NSM_GovernanceValidator.ps1") -Encoding UTF8

}
# ================================================================================
# NASRIUM PROJECT
# CMD_002_BUILD_GOVERNANCE_VALIDATOR
# ================================================================================

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

. "D:\NASRIUM\Core\Builder\Governance\CMD_000_002_ORCHESTRATOR.ps1"

Invoke-NasriumCommand -CmdId "CMD_002" -Action {

    $Root = "D:\NASRIUM"
    $SystemPath = Join-Path $Root "Core\Modules\System"

    # ✅ ENSURE DIRECTORY EXISTS
    if (!(Test-Path $SystemPath)) {
        New-Item -ItemType Directory -Path $SystemPath -Force | Out-Null
    }

@"
function Test-NSMGovernanceIntegrity {

    `$GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"
    `$ManifestPath = Join-Path `$GovPath "08_PROJECT_MANIFEST.json"

    if (!(Test-Path `$ManifestPath)) {
        throw "Governance Manifest missing."
    }

    `$manifest = Get-Content `$ManifestPath -Raw | ConvertFrom-Json

    foreach (`$file in `$manifest.files) {

        `$filePath = Join-Path `$GovPath `$file.name

        if (!(Test-Path `$filePath)) {
            throw "Required file missing: `$(`$file.name)"
        }

        `$bytes = [System.IO.File]::ReadAllBytes(`$filePath)
        `$hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash(`$bytes)
        `$hashStr = ([System.BitConverter]::ToString(`$hash)).Replace("-", "").ToLower()

        if (`$hashStr -ne `$file.sha256) {
            throw "Integrity violation detected in: `$(`$file.name)"
        }
    }

    return `$true
}
"@ | Set-Content (Join-Path $SystemPath "NSM_GovernanceValidator.ps1") -Encoding UTF8

}
