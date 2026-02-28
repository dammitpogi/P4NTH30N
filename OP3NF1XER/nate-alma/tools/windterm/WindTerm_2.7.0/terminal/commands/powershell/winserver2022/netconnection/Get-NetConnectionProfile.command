description: Gets a connection profile
synopses:
- powershell Get-NetConnectionProfile [-Name <String[]>] [-InterfaceAlias <String[]>]
  [-InterfaceIndex <UInt32[]>] [-NetworkCategory <NetworkCategory[]>] [-IPv4Connectivity
  <IPv4Connectivity[]>] [-IPv6Connectivity <IPv6Connectivity[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -IPv4Connectivity IPv4Connectivity[]:
    values:
    - Disconnected
    - NoTraffic
    - Subnet
    - LocalNetwork
    - Internet
  -IPv6Connectivity IPv6Connectivity[]:
    values:
    - Disconnected
    - NoTraffic
    - Subnet
    - LocalNetwork
    - Internet
  -InterfaceAlias String[]: ~
  -InterfaceIndex UInt32[]: ~
  -Name String[]: ~
  -NetworkCategory NetworkCategory[]:
    values:
    - Public
    - Private
    - DomainAuthenticated
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
