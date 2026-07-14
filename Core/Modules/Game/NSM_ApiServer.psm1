<#
 دروازه ارتباطی بازی ناسریوم v4.0 (Bulletproof Edition)
 ویژگی‌ها: مقاوم در برابر خطا، CORS، ارائه فایل‌های استاتیک
#>

function Start-NSMGameServer {
    param([int]$Port = 8080)
    
    $listener = [System.Net.HttpListener]::new()
    $prefix = "http://+:$Port/"
    $listener.Prefixes.Add($prefix)
    
    $FrontendDir = "D:\NASRIUM\Core\Modules/Game/Frontend"
    
    try {
        $listener.Start()
        Write-Host "NASRIUM Server running on $prefix" -ForegroundColor Green
        
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            # اعمال قانون CORS
            $response.Headers.Add("Access-Control-Allow-Origin", "*")
            $response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")
            
            if ($request.HttpMethod -eq "OPTIONS") {
                $response.StatusCode = 200
                $response.Close()
                continue
            }
            
            $url = $request.Url.AbsolutePath
            
            try {
                # ارائه فایل‌های ظاهری بازی
                if ($url -eq "/" -or $url -eq "/index.html") {
                    $filePath = Join-Path $FrontendDir "index.html"
                    $buffer = [System.IO.File]::ReadAllBytes($filePath)
                    $response.ContentType = "text/html; charset=utf-8"
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                    $response.Close()
                }
                elseif ($url -eq "/app.js") {
                    $filePath = Join-Path $FrontendDir "app.js"
                    $buffer = [System.IO.File]::ReadAllBytes($filePath)
                    $response.ContentType = "application/javascript; charset=utf-8"
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                    $response.Close()
                }
                # مسیرهای API بازی
                else {
                    $segments = $request.Url.Segments | Where-Object { $_ -ne "/" }
                    $result = @{ Status="Error"; Message="Unknown Endpoint" }
                    
                    if ($segments[0] -eq "api/" -and $segments[1] -eq "auth/") {
                        $id = $segments[2].TrimEnd("/")
                        $name = $request.QueryString["name"]
                        if (-not $name) { $name = "NewNode" }
                        $result = Initialize-NSMPlayer -TelegramId $id -Username $name
                    }
                    elseif ($segments[0] -eq "api/" -and $segments[1] -eq "player/") {
                        $id = $segments[2].TrimEnd("/")
                        $player = Get-NSMPlayer -Id $id
                        if ($player) { $result = $player } 
                        else { $result = @{ Status="Fail"; Message="Player Not Found" } }
                    }
                    elseif ($segments[0] -eq "api/" -and $segments[1] -eq "upgrade/") {
                        $id = $segments[2].TrimEnd("/")
                        $building = $request.QueryString["building"]
                        $result = Start-NSMBuildingUpgrade -PlayerId $id -BuildingType $building
                    }
                    
                    $json = $result | ConvertTo-Json -Depth 3
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
                    $response.ContentType = "application/json"
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                    $response.Close()
                }
            } catch {
                # اگر در پردازش یک درخواست خطایی رخ داد، سرور خاموش نمی‌شود، فقط خطا را نشان می‌دهد
                Write-Host "Request Error: $_" -ForegroundColor Red
                try { $response.StatusCode = 500; $response.Close() } catch {}
            }
        }
    } catch {
        Write-Host "Server stopped entirely: $_" -ForegroundColor Red
    } finally {
        $listener.Stop()
    }
}

Export-ModuleMember -Function Start-NSMGameServer



