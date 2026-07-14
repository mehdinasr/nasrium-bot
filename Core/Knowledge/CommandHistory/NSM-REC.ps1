param(
[string]$Title,
[string]$Command
)

$Root = "D:\NASRIUM\Core\Knowledge\CommandHistory"

$Last = Get-ChildItem $Root -Filter "CMD_*.ps1" -ErrorAction SilentlyContinue |
Sort-Object Name |
Select-Object -Last 1


if($Last){
    $Number=[int]($Last.BaseName.Replace("CMD_",""))+1
}
else{
    $Number=1
}


$ID="CMD_{0:D3}" -f $Number

$File="$Root\$ID.ps1"


$content=@"
# NASRIUM COMMAND RECORD

ID:
$ID

TITLE:
$Title

DATE:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")


COMMAND:

$Command


STATUS:
EXECUTED

"@

$content | Out-File $File -Encoding UTF8


$IndexFile="$Root\INDEX.json"

$Index=Get-Content $IndexFile -Raw | ConvertFrom-Json

$item=[PSCustomObject]@{
ID=$ID
Title=$Title
File="$ID.ps1"
Date=(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status="Executed"
}


$Index=@($Index)+$item

$Index | ConvertTo-Json -Depth 5 | Out-File $IndexFile -Encoding UTF8


@{
Project="NASRIUM"
LastCommand=$ID
LastUpdate=(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status="Running"
} | ConvertTo-Json | Out-File "$Root\CURRENT_STATE.json" -Encoding UTF8


Write-Host "[OK] $ID CREATED" -ForegroundColor Green
