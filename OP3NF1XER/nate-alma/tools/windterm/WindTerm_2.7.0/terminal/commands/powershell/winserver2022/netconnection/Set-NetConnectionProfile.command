description: Changes the network category of a connection profile
synopses:
- powershell Set-NetConnectionProfile [-Name <String[]>] [-InterfaceAlias <String[]>]
  [-InterfaceIndex <UInt32[]>] [-IPv4Connectivity <IPv4Connectivity[]>] [-IPv6Connectivity
  <IPv6Connectivity[]>] [-NetworkCategory <NetworkCategory>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Set-NetConnectionProfile -InputObject <CimInstance[]> [-NetworkCategory
  <NetworkCategory>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
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
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias String[]: ~
  -InterfaceIndex UInt32[]: ~
  -Name String[]: ~
  -NetworkCategory NetworkCategory:
    values:
    - Public
    - Private
    - DomainAuthenticated
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
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
