# OPS_017: Jackpot Selector Discovery Script (Enhanced)
# Run this from the host machine or H4ND VM (192.168.56.10)
# Probes game page internals via CDP: window variables, Cocos2d engine,
# DOM elements, iframes, Canvas state, and WebSocket game objects.

param(
	[string]$CdpHost = "192.168.56.1",
	[int]$CdpPort = 9222,
	[string]$OutputDir = "C:\P4NTHE0N\STR4TEG15T\actions\ops017_results"
)

Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "OPS_017: Jackpot Selector Discovery (Enhanced)" -ForegroundColor Cyan
Write-Host "Target: Chrome CDP at ${CdpHost}:${CdpPort}" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $OutputDir)) {
	New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# --- CDP connectivity check ---
Write-Host "Testing CDP connectivity..." -ForegroundColor Yellow
try {
	$versionResp = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/version" -Method GET -TimeoutSec 5
	Write-Host "  Browser : $($versionResp.Browser)" -ForegroundColor Green
	Write-Host "  Protocol: $($versionResp.'Protocol-Version')" -ForegroundColor Green
} catch {
	Write-Host "Cannot connect to Chrome CDP at ${CdpHost}:${CdpPort}" -ForegroundColor Red
	Write-Host "  Ensure Chrome is running with --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0" -ForegroundColor Yellow
	exit 1
}

Write-Host ""
Write-Host "Listing CDP targets..." -ForegroundColor Yellow
try {
	$targets = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/list" -Method GET -TimeoutSec 5
	foreach ($t in $targets) {
		$icon = if ($t.type -eq "page") { "[page]" } else { "[$($t.type)]" }
		Write-Host "  $icon $($t.title) -> $($t.url)" -ForegroundColor Gray
	}
} catch {
	Write-Host "  Failed to list targets: $_" -ForegroundColor Red
}

Write-Host ""

# --- CDP evaluate helper with proper command-ID matching ---
function Invoke-CdpEvaluate {
	param([string]$Expression)
	try {
		$targets = Invoke-RestMethod -Uri "http://${CdpHost}:${CdpPort}/json/list" -Method GET -TimeoutSec 5
		$page = $targets | Where-Object { $_.type -eq "page" } | Select-Object -First 1
		if (-not $page) { return @{ success = $false; error = "No page target" } }

		$wsUrl = $page.webSocketDebuggerUrl
		if ($CdpHost -ne "localhost" -and $CdpHost -ne "127.0.0.1") {
			$wsUrl = $wsUrl -replace "ws://localhost:", "ws://${CdpHost}:"
			$wsUrl = $wsUrl -replace "ws://127\.0\.0\.1:", "ws://${CdpHost}:"
		}

		$ws = New-Object System.Net.WebSockets.ClientWebSocket
		$ws.Options.KeepAliveInterval = [TimeSpan]::FromSeconds(5)
		$ws.ConnectAsync([Uri]$wsUrl, [System.Threading.CancellationToken]::None).Wait(5000)
		if ($ws.State -ne [System.Net.WebSockets.WebSocketState]::Open) {
			return @{ success = $false; error = "WebSocket connect failed" }
		}

		$commandId = Get-Random -Minimum 1 -Maximum 99999
		$cmd = @{ id = $commandId; method = "Runtime.evaluate"; params = @{ expression = $Expression; returnByValue = $true; awaitPromise = $true } } | ConvertTo-Json -Compress -Depth 5
		$buf = [System.Text.Encoding]::UTF8.GetBytes($cmd)
		$ws.SendAsync((New-Object System.ArraySegment[byte](,$buf)), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [System.Threading.CancellationToken]::None).Wait(5000)

		# Read messages until we get our command response (skip CDP event notifications)
		$deadline = [DateTime]::UtcNow.AddSeconds(10)
		while ([DateTime]::UtcNow -lt $deadline) {
			$recvBuf = New-Object byte[] 65536
			$seg = New-Object System.ArraySegment[byte](,$recvBuf)
			$cts = New-Object System.Threading.CancellationTokenSource(5000)
			try {
				$recvTask = $ws.ReceiveAsync($seg, $cts.Token)
				$recvTask.Wait()
				$json = [System.Text.Encoding]::UTF8.GetString($recvBuf, 0, $recvTask.Result.Count)
				$obj = $json | ConvertFrom-Json
				if ($obj.id -eq $commandId) {
					try { $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "done", [System.Threading.CancellationToken]::None).Wait(1000) } catch {}
					$ws.Dispose()
					if ($obj.result.result.value -ne $null) {
						return @{ success = $true; value = $obj.result.result.value; type = $obj.result.result.type }
					} elseif ($obj.result.result.description) {
						return @{ success = $true; value = $obj.result.result.description; type = $obj.result.result.type }
					} elseif ($obj.result.result.type -eq "undefined") {
						return @{ success = $false; error = "undefined" }
					} else {
						return @{ success = $false; error = "No value (type=$($obj.result.result.type) subtype=$($obj.result.result.subtype))" }
					}
				}
				# else: CDP event notification, keep reading
			} catch {
				break
			}
		}
		try { $ws.Dispose() } catch {}
		return @{ success = $false; error = "Timeout waiting for response" }
	} catch {
		return @{ success = $false; error = $_.Exception.Message }
	}
}

# --- Probe categories ---

# 1. Extension-injected variables (legacy, expected to fail without extension)
$extensionVars = @(
	"window.parent.Grand",
	"window.parent.Major",
	"window.parent.Minor",
	"window.parent.Mini",
	"window.parent.Balance",
	"window.parent.Page"
)

# 2. Cocos2d-x / Cocos Creator engine globals
$engineVars = @(
	"typeof cc",
	"typeof cc !== 'undefined' && cc.director ? cc.director.getScene().name : null",
	"typeof cc !== 'undefined' && cc.game ? cc.game._paused : null",
	"typeof cc !== 'undefined' ? Object.keys(cc).slice(0,20).join(',') : null",
	"typeof Cocos2dGame",
	"typeof egret",
	"typeof PIXI",
	"typeof Phaser",
	"typeof createjs",
	"typeof CanvasRenderingContext2D"
)

# 3. Common game window properties
$windowVars = @(
	"window.game",
	"window.jackpot",
	"window.Hall",
	"window.Grand",
	"window.Major",
	"window.Minor",
	"window.Mini",
	"window.jackpots",
	"window.bonus",
	"window.prizes",
	"window.app",
	"window.vm",
	"window.store",
	"window.state",
	"window.gameData",
	"window.GameManager",
	"window.SlotGame",
	"window.hallData",
	"window.userData",
	"window.playerData",
	"window.netMgr",
	"window.NetMgr",
	"window.gameMgr",
	"window.GameMgr"
)

# 4. DOM selectors
$domSelectors = @(
	"[data-jackpot]",
	"[class*='jackpot']",
	"[id*='jackpot']",
	".grand-value",
	".major-value",
	".minor-value",
	".mini-value",
	".jackpot-grand",
	".jackpot-major",
	".jackpot-minor",
	".jackpot-mini",
	"[class*='grand']",
	"[class*='major']",
	"[class*='minor']",
	"[class*='mini']",
	"canvas",
	"iframe",
	".hall-container",
	".game-list",
	".home-container",
	"[class*='hall']"
)

# --- Results ---
$results = @{
	timestamp     = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
	cdpHost       = $CdpHost
	cdpPort       = $CdpPort
	pageUrl       = ""
	pageTitle     = ""
	extensionVars = @{}
	engineVars    = @{}
	windowVars    = @{}
	domSelectors  = @{}
	iframeCount   = 0
	canvasCount   = 0
	windowKeys    = @()
}

# Get current page info
$pageInfo = Invoke-CdpEvaluate -Expression "JSON.stringify({url: location.href, title: document.title})"
if ($pageInfo.success) {
	try {
		$pi = $pageInfo.value | ConvertFrom-Json
		$results.pageUrl = $pi.url
		$results.pageTitle = $pi.title
		Write-Host "Current page: $($pi.title) ($($pi.url))" -ForegroundColor White
	} catch {}
}
Write-Host ""

# --- Phase 1: Extension variables ---
Write-Host "Phase 1: Extension-injected variables (legacy)..." -ForegroundColor Yellow
foreach ($v in $extensionVars) {
	$r = Invoke-CdpEvaluate -Expression "(() => { try { var x = $v; return x !== undefined && x !== null ? String(x) : null; } catch(e) { return null; } })()"
	if ($r.success -and $r.value -ne $null) {
		Write-Host "  HIT $v = $($r.value)" -ForegroundColor Green
		$results.extensionVars[$v] = $r.value
	} else {
		Write-Host "  MISS $v" -ForegroundColor DarkGray
	}
}

# --- Phase 2: Game engine globals ---
Write-Host ""
Write-Host "Phase 2: Game engine globals..." -ForegroundColor Yellow
foreach ($v in $engineVars) {
	$r = Invoke-CdpEvaluate -Expression "(() => { try { return $v; } catch(e) { return null; } })()"
	if ($r.success -and $r.value -ne $null -and $r.value -ne "undefined") {
		Write-Host "  HIT $v = $($r.value)" -ForegroundColor Green
		$results.engineVars[$v] = $r.value
	} else {
		Write-Host "  MISS $v" -ForegroundColor DarkGray
	}
}

# --- Phase 3: Window variables ---
Write-Host ""
Write-Host "Phase 3: Window variables..." -ForegroundColor Yellow
foreach ($v in $windowVars) {
	$r = Invoke-CdpEvaluate -Expression "(() => { try { var x = $v; if (x === undefined || x === null) return null; return typeof x === 'object' ? JSON.stringify(Object.keys(x).slice(0,10)) : String(x); } catch(e) { return null; } })()"
	if ($r.success -and $r.value -ne $null) {
		Write-Host "  HIT $v = $($r.value)" -ForegroundColor Green
		$results.windowVars[$v] = $r.value
	} else {
		Write-Host "  MISS $v" -ForegroundColor DarkGray
	}
}

# Enumerate all non-default window properties
Write-Host ""
Write-Host "Phase 3b: Enumerating custom window properties..." -ForegroundColor Yellow
$enumResult = Invoke-CdpEvaluate -Expression @"
(() => {
	try {
		var iframe = document.createElement('iframe');
		document.body.appendChild(iframe);
		var defaultKeys = new Set(Object.getOwnPropertyNames(iframe.contentWindow));
		document.body.removeChild(iframe);
		var custom = Object.getOwnPropertyNames(window).filter(k => !defaultKeys.has(k) && !k.startsWith('__'));
		return JSON.stringify(custom.slice(0, 50));
	} catch(e) { return JSON.stringify([]); }
})()
"@
if ($enumResult.success -and $enumResult.value) {
	try {
		$customKeys = $enumResult.value | ConvertFrom-Json
		$results.windowKeys = $customKeys
		if ($customKeys.Count -gt 0) {
			Write-Host "  Custom window properties ($($customKeys.Count)):" -ForegroundColor Green
			foreach ($k in $customKeys) {
				Write-Host "    - $k" -ForegroundColor Cyan
			}
		} else {
			Write-Host "  No custom window properties found" -ForegroundColor DarkGray
		}
	} catch {}
}

# --- Phase 4: DOM selectors ---
Write-Host ""
Write-Host "Phase 4: DOM selectors..." -ForegroundColor Yellow
foreach ($sel in $domSelectors) {
	$escaped = $sel -replace "'", "\\'"
	$r = Invoke-CdpEvaluate -Expression "(() => { var els = document.querySelectorAll('$escaped'); if (els.length === 0) return null; return JSON.stringify({ count: els.length, first: { tag: els[0].tagName, class: els[0].className, text: (els[0].textContent || '').substring(0, 100) } }); })()"
	if ($r.success -and $r.value -ne $null) {
		Write-Host "  HIT $sel -> $($r.value)" -ForegroundColor Green
		$results.domSelectors[$sel] = $r.value
	} else {
		Write-Host "  MISS $sel" -ForegroundColor DarkGray
	}
}

# Canvas and iframe counts
$canvasR = Invoke-CdpEvaluate -Expression "document.querySelectorAll('canvas').length"
if ($canvasR.success) { $results.canvasCount = $canvasR.value }
$iframeR = Invoke-CdpEvaluate -Expression "document.querySelectorAll('iframe').length"
if ($iframeR.success) { $results.iframeCount = $iframeR.value }

Write-Host ""
Write-Host "  Canvas elements: $($results.canvasCount)" -ForegroundColor White
Write-Host "  Iframe elements: $($results.iframeCount)" -ForegroundColor White

# --- Phase 5: Deep probe iframes ---
if ($results.iframeCount -gt 0) {
	Write-Host ""
	Write-Host "Phase 5: Probing iframes for jackpot data..." -ForegroundColor Yellow
	$iframeProbe = Invoke-CdpEvaluate -Expression @"
(() => {
	try {
		var results = [];
		var iframes = document.querySelectorAll('iframe');
		for (var i = 0; i < iframes.length; i++) {
			try {
				var w = iframes[i].contentWindow;
				var vars = {};
				['Grand','Major','Minor','Mini','Balance','Page','game','jackpot'].forEach(function(k) {
					try { if (w[k] !== undefined) vars[k] = String(w[k]); } catch(e) {}
				});
				results.push({ index: i, src: iframes[i].src || '(no src)', vars: vars });
			} catch(e) {
				results.push({ index: i, src: iframes[i].src || '(no src)', error: e.message });
			}
		}
		return JSON.stringify(results);
	} catch(e) { return JSON.stringify([]); }
})()
"@
	if ($iframeProbe.success -and $iframeProbe.value) {
		try {
			$iframeData = $iframeProbe.value | ConvertFrom-Json
			foreach ($f in $iframeData) {
				Write-Host "  iframe[$($f.index)]: $($f.src)" -ForegroundColor White
				if ($f.vars) {
					$f.vars.PSObject.Properties | ForEach-Object {
						Write-Host "    HIT $($_.Name) = $($_.Value)" -ForegroundColor Green
					}
				}
				if ($f.error) {
					Write-Host "    Cross-origin: $($f.error)" -ForegroundColor DarkGray
				}
			}
		} catch {}
	}
}

# --- Save results ---
$jsonPath = Join-Path $OutputDir "discovery_results.json"
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "Discovery complete!" -ForegroundColor Cyan
Write-Host "Results saved to: $jsonPath" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

# --- Summary ---
Write-Host ""
Write-Host "SUMMARY:" -ForegroundColor Yellow
$hitCount = $results.extensionVars.Count + $results.engineVars.Count + $results.windowVars.Count + $results.domSelectors.Count
Write-Host "  Extension vars found : $($results.extensionVars.Count)" -ForegroundColor White
Write-Host "  Engine globals found : $($results.engineVars.Count)" -ForegroundColor White
Write-Host "  Window vars found   : $($results.windowVars.Count)" -ForegroundColor White
Write-Host "  DOM selectors found : $($results.domSelectors.Count)" -ForegroundColor White
Write-Host "  Custom window keys  : $($results.windowKeys.Count)" -ForegroundColor White
Write-Host "  Canvas elements     : $($results.canvasCount)" -ForegroundColor White
Write-Host "  Iframe elements     : $($results.iframeCount)" -ForegroundColor White
Write-Host ""

if ($hitCount -eq 0) {
	Write-Host "No jackpot selectors found in current page state." -ForegroundColor Red
	Write-Host "Architecture note: These games use Canvas rendering (Cocos2d-x)." -ForegroundColor Yellow
	Write-Host "Jackpot values are NOT in DOM elements - they come from the" -ForegroundColor Yellow
	Write-Host "game server WebSocket API (QueryBalances). The CDP page check" -ForegroundColor Yellow
	Write-Host "should verify page readiness, not read jackpot values." -ForegroundColor Yellow
	Write-Host ""
	Write-Host "Recommended approach:" -ForegroundColor Cyan
	Write-Host "  1. Use canvas/iframe presence as page-load gate" -ForegroundColor White
	Write-Host "  2. Read jackpots via WebSocket API (QueryBalances)" -ForegroundColor White
	Write-Host "  3. Remove dependency on window.parent.Grand" -ForegroundColor White
}
