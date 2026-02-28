description: Creates a neighbor cache entry
synopses:
- New-NetNeighbor [-IPAddress] <String> -InterfaceAlias <String> [-LinkLayerAddress
  <String>] [-PolicyStore <String>] [-State <State>] [-AddressFamily <AddressFamily>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetNeighbor [-IPAddress] <String> [-LinkLayerAddress <String>] [-PolicyStore
  <String>] [-State <State>] [-AddressFamily <AddressFamily>] -InterfaceIndex <UInt32>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AddressFamily AddressFamily:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPAddress String:
    required: true
  -InterfaceAlias,-ifAlias String:
    required: true
  -InterfaceIndex,-ifIndex UInt32:
    required: true
  -LinkLayerAddress String: ~
  -PolicyStore String: ~
  -State State:
    values:
    - Unreachable
    - Incomplete
    - Probe
    - Delay
    - Stale
    - Reachable
    - Permanent
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
