description: Gets one or more lease records from the DHCP server service
synopses:
- Get-DhcpServerv4Lease [-ComputerName <String>] [-ScopeId] <IPAddress> [-AllLeases]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DhcpServerv4Lease [-ComputerName <String>] -IPAddress <IPAddress[]> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DhcpServerv4Lease [-ComputerName <String>] [-ScopeId] <IPAddress> [-ClientId]
  <String[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DhcpServerv4Lease [-ComputerName <String>] [-BadLeases] [[-ScopeId] <IPAddress>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AllLeases Switch: ~
  -AsJob Switch: ~
  -BadLeases Switch:
    required: true
  -CimSession,-Session CimSession[]: ~
  -ClientId String[]:
    required: true
  -ComputerName,-Cn String: ~
  -IPAddress IPAddress[]:
    required: true
  -ScopeId IPAddress:
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
