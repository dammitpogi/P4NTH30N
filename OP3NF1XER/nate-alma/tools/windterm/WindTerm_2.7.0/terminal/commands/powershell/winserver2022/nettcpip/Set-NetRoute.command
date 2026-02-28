description: Modifies an entry or entries in the IP routing table
synopses:
- Set-NetRoute [[-DestinationPrefix] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-NextHop <String[]>] [-AddressFamily <AddressFamily[]>] [-Protocol
  <Protocol[]>] [-PolicyStore <String>] [-IncludeAllCompartments] [-Publish <Publish>]
  [-RouteMetric <UInt16>] [-ValidLifetime <TimeSpan>] [-PreferredLifetime <TimeSpan>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetRoute -InputObject <CimInstance[]> [-Publish <Publish>] [-RouteMetric <UInt16>]
  [-ValidLifetime <TimeSpan>] [-PreferredLifetime <TimeSpan>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationPrefix String[]: ~
  -IncludeAllCompartments Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -NextHop String[]: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -PreferredLifetime TimeSpan: ~
  -Protocol Protocol[]:
    values:
    - Other
    - Local
    - NetMgmt
    - Icmp
    - Egp
    - Ggp
    - Hello
    - Rip
    - IsIs
    - EsIs
    - Igrp
    - Bbn
    - Ospf
    - Bgp
    - Idpr
    - Eigrp
    - Dvmrp
    - Rpl
    - Dhcp
  -Publish Publish:
    values:
    - No
    - Age
    - Yes
  -RouteMetric UInt16: ~
  -ThrottleLimit Int32: ~
  -ValidLifetime TimeSpan: ~
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
