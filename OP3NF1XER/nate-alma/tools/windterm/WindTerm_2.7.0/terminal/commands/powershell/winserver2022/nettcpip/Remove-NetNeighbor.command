description: Removes neighbor cache entries
synopses:
- Remove-NetNeighbor [[-IPAddress] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-LinkLayerAddress <String[]>] [-State <State[]>] [-AddressFamily <AddressFamily[]>]
  [-AssociatedIPInterface <CimInstance>] [-PolicyStore <String>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-NetNeighbor -InputObject <CimInstance[]> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -AssociatedIPInterface CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPAddress String[]: ~
  -IncludeAllCompartments Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -LinkLayerAddress String[]: ~
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
