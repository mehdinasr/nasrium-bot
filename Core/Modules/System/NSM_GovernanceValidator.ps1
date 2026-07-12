function Test-NSMGovernanceIntegrity {
    $GovPath = "D:\NASRIUM\Core\Knowledge\AI Governance Package"
    $ManifestPath = Join-Path $GovPath "08_PROJECT_MANIFEST.json"
    if (!(Test-Path $ManifestPath)) { throw "Governance Manifest missing." }
    $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json

    foreach ($file in $manifest.files) {
        $filePath = Join-Path $GovPath $file.name
        if (!(Test-Path $filePath)) { throw "Required file missing: $($file.name)" }
        
        # Self-Hash Paradox Exception
        if ($file.name -eq "08_PROJECT_MANIFEST.json") {
            continue
        }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        $hashStr = ([System.BitConverter]::ToString($hash) -replace "-", "").ToLower()
        if ($hashStr -ne $file.sha256) { throw "Integrity violation in: $($file.name)" }
    }
    return $true
}