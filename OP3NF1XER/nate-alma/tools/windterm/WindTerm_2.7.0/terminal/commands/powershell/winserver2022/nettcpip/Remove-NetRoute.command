description: Removes IP routes from the IP routing table
synopses:
- Remove-NetRoute [[-DestinationPrefix] <String[]>] [-InterfaceIndex <UInt32[]>] [-InterfaceAlias
  <String[]>] [-NextHop <String[]>] [-AddressFamily <AddressFamily[]>] [-Publish <Publish[]>]
  [-RouteMetric <UInt16[]>] [-Protocol <Protocol[]>] [-CompartmentId <UInt32[]>] [-ValidLifetime
  <TimeSpan[]>] [-PreferredLifetime <TimeSpan[]>] [-State <State[]>] [-InterfaceMetric
  <UInt32[]>] [-AssociatedIPInterface <CimInstance>] [-PolicyStore <String>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-NetRoute -InputObject <CimInstance[]> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -AssociatedIPInterface CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -CompartmentId UInt32[]: ~
  -Confirm,-cf Switch: ~
  -DestinationPrefix String[]: ~
  -IncludeAllCompartments Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -InterfaceMetric UInt32[]: ~
  -NextHop String[]: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -PreferredLifetime TimeSpan[]: ~
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
  -Publish Publish[]:
    values:
    - No
    - Age
    - Yes
  -RouteMetric UInt16[]: ~
  -State State[]: ~
  -ThrottleLimit Int32: ~
  -ValidLifetime TimeSpan[]: ~
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
