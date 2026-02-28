description: Gets IPv4 reservations for IP addresses or client IDs
synopses:
- Get-DhcpServerv4Reservation [-ComputerName <String>] [-ScopeId] <IPAddress> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DhcpServerv4Reservation [-ComputerName <String>] -IPAddress <IPAddress[]> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DhcpServerv4Reservation [-ComputerName <String>] [-ClientId] <String[]> [-ScopeId]
  <IPAddress> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientId String[]:
    required: true
  -ComputerName,-Cn,-ReservationServer String: ~
  -IPAddress,-ReservedIP IPAddress[]:
    required: true
  -ScopeId,-ReservationScopeID IPAddress:
    required: true
  -ThrottleLimit Int32: ~
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~
