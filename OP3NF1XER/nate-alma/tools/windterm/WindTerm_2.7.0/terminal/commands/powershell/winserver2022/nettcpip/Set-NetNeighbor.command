description: Modifies a neighbor cache entry
synopses:
- Set-NetNeighbor [[-IPAddress] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-State <State[]>] [-AddressFamily <AddressFamily[]>] [-PolicyStore
  <String>] [-IncludeAllCompartments] [-LinkLayerAddress <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetNeighbor -InputObject <CimInstance[]> [-LinkLayerAddress <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPAddress String[]: ~
  -IncludeAllCompartments Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -LinkLayerAddress String: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -State State[]:
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
