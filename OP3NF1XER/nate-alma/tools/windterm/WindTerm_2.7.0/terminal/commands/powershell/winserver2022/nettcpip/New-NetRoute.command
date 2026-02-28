description: Creates a route in the IP routing table
synopses:
- New-NetRoute [-DestinationPrefix] <String> -InterfaceAlias <String> [-AddressFamily
  <AddressFamily>] [-NextHop <String>] [-PolicyStore <String>] [-Publish <Publish>]
  [-RouteMetric <UInt16>] [-Protocol <Protocol>] [-ValidLifetime <TimeSpan>] [-PreferredLifetime
  <TimeSpan>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-NetRoute [-DestinationPrefix] <String> [-AddressFamily <AddressFamily>] [-NextHop
  <String>] [-PolicyStore <String>] [-Publish <Publish>] [-RouteMetric <UInt16>] [-Protocol
  <Protocol>] [-ValidLifetime <TimeSpan>] [-PreferredLifetime <TimeSpan>] -InterfaceIndex
  <UInt32> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AddressFamily AddressFamily:
    values:
    - IPv4
    - IPv6
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DestinationPrefix String:
    required: true
  -InterfaceAlias,-ifAlias String:
    required: true
  -InterfaceIndex,-ifIndex UInt32:
    required: true
  -NextHop String: ~
  -PolicyStore String: ~
  -PreferredLifetime TimeSpan: ~
  -Protocol Protocol:
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
