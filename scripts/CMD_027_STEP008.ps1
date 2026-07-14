Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$History="D:\NASRIUM\Core\Knowledge\PROJECT_MASTER_HISTORY.json"

if(Test-Path $History){

    $json=Get-Content $History -Raw | ConvertFrom-Json

    if($json.history){

        $json.history += [pscustomobject]@{

            id="CMD_027"

            title="Skill Schema"

            date=(Get-Date).ToString("yyyy-MM-dd")

            status="SUCCESS"

            desc="Initial Skill Schema generated."

        }

    }

    $json.last_update=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    $json |
    ConvertTo-Json -Depth 100 |
    Set-Content $History -Encoding UTF8

    Write-Host "PROJECT_MASTER_HISTORY UPDATED" -ForegroundColor Green

}
else{

    Write-Host "PROJECT_MASTER_HISTORY.json NOT FOUND" -ForegroundColor Yellow

}

Write-Host ""
Write-Host "CMD_027 COMPLETED" -ForegroundColor Cyan

