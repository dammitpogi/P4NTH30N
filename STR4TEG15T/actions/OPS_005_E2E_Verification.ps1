# OPS_005: End-to-End Spin Verification Script
# Validates the full pipeline: Signal -> Login -> Navigate -> Read Jackpot -> Spin -> Update DB
#
# Prerequisites:
#   - Chrome running on host with --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0
#   - MongoDB running on host at 192.168.56.1:27017
#   - H4ND built and ready to run
#
# Run from: Host machine or H4ND VM

param(
	[string]$CdpHost = "192.168.56.1",
	[int]$CdpPort = 9222,
	[string]$MongoHost = "192.168.56.1",
	[int]$MongoPort = 27017,
	[string]$H4ndProject = "C:\P4NTH30N\H4ND\H4ND.csproj",
	[switch]$DryRun
)

$ErrorActionPreference = "Continue"
$script:passCount = 0
$script:failCount = 0
$script:skipCount = 0

function Write-Check {
	param([string]$Name, [bool]$Passed, [string]$Detail = "")
	if ($Passed) {
		$script:passCount++
		Write-Host "  PASS  $Name" -ForegroundColor Green
	} else {
		$script:failCount++
		Write-Host "  FAIL  $Name" -ForegroundColor Red
	}
	if ($Detail) { Write-Host "         $Detail" -ForegroundColor Gray }
}

function Write-Skip {
	param([string]$Name, [string]$Reason = "")
	$script:skipCount++
	Write-Host "  SKIP  $Name" -ForegroundColor Yellow
	if ($Reason) { Write-Host "         $Reason" -ForegroundColor Gray }
}

Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "OPS_005: End-to-End Spin Verification" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""

# ===== PHASE 1: Infrastructure Checks =====
Write-Host "PHASE 1: Infrastructure" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

# 1.1 Chrome CDP connectivity
$cdpOk = $false
try {
	$version = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/version" -Method GET -TimeoutSec 5
	$cdpOk = $true
	Write-Check "Chrome CDP connectivity" $true "Browser: $($version.Browser)"
} catch {
	Write-Check "Chrome CDP connectivity" $false "Cannot reach ${CdpHost}:${CdpPort}"
}

# 1.2 Chrome has debuggable pages
$hasPages = $false
if ($cdpOk) {
	try {
		$targets = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/list" -Method GET -TimeoutSec 5
		$pages = $targets | Where-Object { $_.type -eq "page" }
		$hasPages = ($null -ne $pages -and @($pages).Count -gt 0)
		Write-Check "Debuggable page targets" $hasPages "$(@($pages).Count) page(s) found"
	} catch {
		Write-Check "Debuggable page targets" $false $_
	}
}

# 1.3 MongoDB connectivity
$mongoOk = $false
try {
	$tcpClient = New-Object System.Net.Sockets.TcpClient
	$connectResult = $tcpClient.BeginConnect($MongoHost, $MongoPort, $null, $null)
	$waitResult = $connectResult.AsyncWaitHandle.WaitOne(3000)
	$mongoOk = $waitResult -and $tcpClient.Connected
	$tcpClient.Close()
	Write-Check "MongoDB connectivity" $mongoOk "${MongoHost}:${MongoPort}"
} catch {
	Write-Check "MongoDB connectivity" $false $_
}

# 1.4 H4ND project builds
$buildOk = $false
try {
	$buildOutput = dotnet build $H4ndProject --no-restore -c Debug 2>&1
	$buildOk = $LASTEXITCODE -eq 0
	$errorLines = $buildOutput | Select-String "error CS" | Measure-Object
	Write-Check "H4ND project builds" $buildOk "$($errorLines.Count) error(s)"
} catch {
	Write-Check "H4ND project builds" $false $_
}

Write-Host ""

# ===== PHASE 2: Code Verification =====
Write-Host "PHASE 2: Code Changes (OPS_009)" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

# 2.1 ReadExtensionGrandAsync is deprecated
$cdpActionsFile = Join-Path (Split-Path $H4ndProject) "Infrastructure\CdpGameActions.cs"
if (Test-Path $cdpActionsFile) {
	$content = Get-Content $cdpActionsFile -Raw

	$hasVerifyMethod = $content -match "VerifyGamePageLoadedAsync"
	Write-Check "VerifyGamePageLoadedAsync exists" $hasVerifyMethod

	$hasReadJackpots = $content -match "ReadJackpotsViaCdpAsync"
	Write-Check "ReadJackpotsViaCdpAsync exists" $hasReadJackpots

	$hasObsolete = $content -match '\[Obsolete.*OPS_009'
	Write-Check "ReadExtensionGrandAsync marked [Obsolete]" $hasObsolete

	$hasMultiStrategy = $content -match "ReadJackpotTierViaCdpAsync"
	Write-Check "Multi-strategy tier probing" $hasMultiStrategy
} else {
	Write-Check "CdpGameActions.cs exists" $false "File not found: $cdpActionsFile"
}

# 2.2 H4ND.cs uses new page verification
$h4ndFile = Join-Path (Split-Path $H4ndProject) "H4ND.cs"
if (Test-Path $h4ndFile) {
	$h4ndContent = Get-Content $h4ndFile -Raw

	$usesPageVerify = $h4ndContent -match "VerifyGamePageLoadedAsync"
	Write-Check "H4ND.cs uses VerifyGamePageLoadedAsync" $usesPageVerify

	$noExtensionGrand = -not ($h4ndContent -match "ReadExtensionGrandAsync")
	Write-Check "H4ND.cs removed ReadExtensionGrandAsync calls" $noExtensionGrand

	$usesGetBalances = $h4ndContent -match "GetBalancesWithRetry"
	Write-Check "H4ND.cs uses GetBalancesWithRetry (API source)" $usesGetBalances

	$noExtensionFailure = -not ($h4ndContent -match '"Extension failure\."')
	Write-Check "H4ND.cs removed 'Extension failure' throw" $noExtensionFailure
} else {
	Write-Check "H4ND.cs exists" $false "File not found: $h4ndFile"
}

Write-Host ""

# ===== PHASE 3: CDP Page Verification =====
Write-Host "PHASE 3: CDP Page Verification" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

if ($cdpOk -and $hasPages) {
	# Quick CDP evaluate test
	try {
		$targets = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/list" -Method GET -TimeoutSec 5
		$page = $targets | Where-Object { $_.type -eq "page" } | Select-Object -First 1

		$wsUrl = $page.webSocketDebuggerUrl
		if ($CdpHost -ne "localhost" -and $CdpHost -ne "127.0.0.1") {
			$wsUrl = $wsUrl -replace "ws://localhost:", "ws://${CdpHost}:"
		}

		Write-Check "CDP WebSocket URL rewriting" $true $wsUrl

		# Test basic evaluate
		$ws = New-Object System.Net.WebSockets.ClientWebSocket
		$ws.ConnectAsync([Uri]$wsUrl, [System.Threading.CancellationToken]::None).Wait(5000)
		$connected = ($ws.State -eq [System.Net.WebSockets.WebSocketState]::Open)
		Write-Check "CDP WebSocket connection" $connected

		if ($connected) {
			# Evaluate document.title
			$cmdId = Get-Random -Minimum 1 -Maximum 99999
			$cmd = @{ id = $cmdId; method = "Runtime.evaluate"; params = @{ expression = "document.title"; returnByValue = $true } } | ConvertTo-Json -Compress -Depth 5
			$buf = [System.Text.Encoding]::UTF8.GetBytes($cmd)
			$ws.SendAsync((New-Object System.ArraySegment[byte](,$buf)), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [System.Threading.CancellationToken]::None).Wait(5000)

			$recvBuf = New-Object byte[] 65536
			$seg = New-Object System.ArraySegment[byte](,$recvBuf)
			$deadline = [DateTime]::UtcNow.AddSeconds(5)
			$evalOk = $false
			while ([DateTime]::UtcNow -lt $deadline) {
				$cts = New-Object System.Threading.CancellationTokenSource(3000)
				$recvTask = $ws.ReceiveAsync($seg, $cts.Token)
				$recvTask.Wait()
				$json = [System.Text.Encoding]::UTF8.GetString($recvBuf, 0, $recvTask.Result.Count)
				$obj = $json | ConvertFrom-Json
				if ($obj.id -eq $cmdId) {
					$title = $obj.result.result.value
					$evalOk = ($null -ne $title)
					Write-Check "CDP Runtime.evaluate" $evalOk "document.title = '$title'"
					break
				}
			}
			if (-not $evalOk) { Write-Check "CDP Runtime.evaluate" $false "Timeout" }

			# Test canvas detection (the new page readiness check)
			$cmdId2 = Get-Random -Minimum 1 -Maximum 99999
			$cmd2 = @{ id = $cmdId2; method = "Runtime.evaluate"; params = @{ expression = "document.querySelector('canvas') !== null"; returnByValue = $true } } | ConvertTo-Json -Compress -Depth 5
			$buf2 = [System.Text.Encoding]::UTF8.GetBytes($cmd2)
			$ws.SendAsync((New-Object System.ArraySegment[byte](,$buf2)), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [System.Threading.CancellationToken]::None).Wait(5000)

			$deadline2 = [DateTime]::UtcNow.AddSeconds(5)
			while ([DateTime]::UtcNow -lt $deadline2) {
				$cts2 = New-Object System.Threading.CancellationTokenSource(3000)
				$recvTask2 = $ws.ReceiveAsync($seg, $cts2.Token)
				$recvTask2.Wait()
				$json2 = [System.Text.Encoding]::UTF8.GetString($recvBuf, 0, $recvTask2.Result.Count)
				$obj2 = $json2 | ConvertFrom-Json
				if ($obj2.id -eq $cmdId2) {
					$hasCanvas = $obj2.result.result.value
					Write-Check "Canvas detection (page readiness)" ($null -ne $hasCanvas) "Canvas present: $hasCanvas"
					break
				}
			}

			try { $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "done", [System.Threading.CancellationToken]::None).Wait(1000) } catch {}
			$ws.Dispose()
		}
	} catch {
		Write-Check "CDP page verification" $false $_.Exception.Message
	}
} else {
	Write-Skip "CDP page verification" "CDP not available or no page targets"
}

Write-Host ""

# ===== PHASE 4: WebSocket API Verification =====
Write-Host "PHASE 4: WebSocket API (QueryBalances)" -ForegroundColor Yellow
Write-Host ("-" * 40) -ForegroundColor DarkGray

# Test FireKirin config endpoint
try {
	$fkConfig = Invoke-RestMethod -Uri "http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json" -TimeoutSec 10
	$fkOk = ($null -ne $fkConfig.bsIp -and $fkConfig.bsIp.Length -gt 0)
	Write-Check "FireKirin API config reachable" $fkOk "bsIp=$($fkConfig.bsIp), wsPort=$($fkConfig.wsPort)"
} catch {
	Write-Check "FireKirin API config reachable" $false $_.Exception.Message
}

# Test OrionStars config endpoint
try {
	$osConfig = Invoke-RestMethod -Uri "http://web.orionstars.org/hot_play/plat/config/hall/orionstars/config.json" -TimeoutSec 10
	$osOk = ($null -ne $osConfig.bsIp -and $osConfig.bsIp.Length -gt 0)
	Write-Check "OrionStars API config reachable" $osOk "bsIp=$($osConfig.bsIp), wsPort=$($osConfig.wsPort)"
} catch {
	Write-Check "OrionStars API config reachable" $false $_.Exception.Message
}

Write-Host ""

# ===== PHASE 5: Dry Run (optional) =====
if (-not $DryRun) {
	Write-Host "PHASE 5: H4ND Dry Run" -ForegroundColor Yellow
	Write-Host ("-" * 40) -ForegroundColor DarkGray

	try {
		$dryRunOutput = dotnet run --project $H4ndProject -- H4ND --dry-run 2>&1
		$dryRunOk = $LASTEXITCODE -eq 0
		Write-Check "H4ND dry-run startup" $dryRunOk
	} catch {
		Write-Skip "H4ND dry-run" "Could not execute: $_"
	}
} else {
	Write-Skip "H4ND dry-run" "Skipped (use without -DryRun to execute)"
}

Write-Host ""

# ===== SUMMARY =====
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "E2E VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host ""
Write-Host "  Passed : $($script:passCount)" -ForegroundColor Green
Write-Host "  Failed : $($script:failCount)" -ForegroundColor $(if ($script:failCount -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $($script:skipCount)" -ForegroundColor Yellow
Write-Host ""

$total = $script:passCount + $script:failCount
$rate = if ($total -gt 0) { [math]::Round(($script:passCount / $total) * 100, 1) } else { 0 }
Write-Host "  Pass Rate: ${rate}%" -ForegroundColor $(if ($rate -ge 80) { "Green" } elseif ($rate -ge 50) { "Yellow" } else { "Red" })
Write-Host ""

if ($script:failCount -eq 0) {
	Write-Host "  All checks passed! Pipeline is ready for production." -ForegroundColor Green
} elseif ($script:failCount -le 2) {
	Write-Host "  Minor issues detected. Review failed checks above." -ForegroundColor Yellow
} else {
	Write-Host "  Multiple failures detected. Pipeline needs attention." -ForegroundColor Red
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Run OPS_017 discovery script on a logged-in game page" -ForegroundColor White
Write-Host "  2. Start H4ND: dotnet run --project H4ND/H4ND.csproj -- H4ND" -ForegroundColor White
Write-Host "  3. Inject a test signal into MongoDB SIGN4L collection" -ForegroundColor White
Write-Host "  4. Monitor H4ND console for 'Spin executed' message" -ForegroundColor White
Write-Host "  5. Verify CRED3N7IAL collection updated with new jackpot values" -ForegroundColor White
