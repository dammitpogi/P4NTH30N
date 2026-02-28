# MongoDB Connection Test Script
# More robust testing for MongoDB connectivity

param(
    [string]$MongoHost = "192.168.56.1",
    [int]$Port = 27017,
    [int]$TimeoutMs = 3000
)

Write-Host "Testing MongoDB connection to $MongoHost`:$Port..." -ForegroundColor Cyan

# Method 1: TCP Connection Test
Write-Host "1. TCP Connection Test..." -ForegroundColor Yellow
try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $connect = $tcpClient.BeginConnect($MongoHost, $Port, $null, $null)
    $wait = $connect.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
    
    if ($wait) {
        $tcpClient.EndConnect($connect)
        Write-Host "✓ TCP connection successful" -ForegroundColor Green
        $tcpClient.Close()
        $tcpSuccess = $true
    } else {
        Write-Host "✗ TCP connection timeout" -ForegroundColor Red
        $tcpClient.Close()
        $tcpSuccess = $false
    }
} catch {
    Write-Host "✗ TCP connection failed: $($_.Exception.Message)" -ForegroundColor Red
    $tcpSuccess = $false
}

# Method 2: Test-NetConnection with longer timeout
Write-Host "`n2. Test-NetConnection..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName $MongoHost -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
    if ($result) {
        Write-Host "✓ Test-NetConnection successful" -ForegroundColor Green
        $netSuccess = $true
    } else {
        Write-Host "✗ Test-NetConnection failed" -ForegroundColor Red
        $netSuccess = $false
    }
} catch {
    Write-Host "✗ Test-NetConnection error: $($_.Exception.Message)" -ForegroundColor Red
    $netSuccess = $false
}

# Method 3: Simple Socket Test
Write-Host "`n3. Socket Test..." -ForegroundColor Yellow
try {
    $socket = New-Object System.Net.Sockets.Socket([System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
    $socket.ReceiveTimeout = $TimeoutMs
    $socket.SendTimeout = $TimeoutMs
    
    $connectResult = $socket.BeginConnect($MongoHost, $Port, $null, $null)
    $success = $connectResult.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
    
    if ($success) {
        $socket.EndConnect($connectResult)
        Write-Host "✓ Socket connection successful" -ForegroundColor Green
        $socket.Close()
        $socketSuccess = $true
    } else {
        Write-Host "✗ Socket connection timeout" -ForegroundColor Red
        $socket.Close()
        $socketSuccess = $false
    }
} catch {
    Write-Host "✗ Socket connection failed: $($_.Exception.Message)" -ForegroundColor Red
    $socketSuccess = $false
}

Write-Host "`n=== Connection Test Summary ===" -ForegroundColor Cyan
$overallSuccess = $tcpSuccess -or $netSuccess -or $socketSuccess

if ($overallSuccess) {
    Write-Host "✓ MongoDB is ACCESSIBLE at $MongoHost`:$Port" -ForegroundColor Green
    Write-Host "The startup script should work properly." -ForegroundColor Gray
} else {
    Write-Host "✗ MongoDB is NOT ACCESSIBLE at $MongoHost`:$Port" -ForegroundColor Red
    Write-Host "Check:" -ForegroundColor Yellow
    Write-Host "  - MongoDB service is running" -ForegroundColor Gray
    Write-Host "  - Firewall allows port 27017" -ForegroundColor Gray
    Write-Host "  - Network connectivity to $MongoHost" -ForegroundColor Gray
}

exit (if ($overallSuccess) { 0 } else { 1 })
