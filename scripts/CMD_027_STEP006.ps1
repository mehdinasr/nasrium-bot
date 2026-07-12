Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$Root="D:\NASRIUM\Data\Balance\Skills"

$Schema="$Root\NSM_SKILL_SCHEMA_V1.json"

$MetadataFile="$Root\NSM_SKILL_METADATA_V1.json"

$Hash=(Get-FileHash $Schema -Algorithm SHA256).Hash

$Meta=[ordered]@{

    Module="CMD_027"

    SchemaVersion="1.0.0"

    BuilderVersion="4.0.0"

    GameVersion="0.1.0-alpha"

    Compatibility="0.1.x"

    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    SHA256=$Hash

}

$Meta |
ConvertTo-Json -Depth 10 |
Set-Content $MetadataFile -Encoding UTF8

Write-Host ""
Write-Host "CMD_027 STEP-006 SUCCESS" -ForegroundColor Green

