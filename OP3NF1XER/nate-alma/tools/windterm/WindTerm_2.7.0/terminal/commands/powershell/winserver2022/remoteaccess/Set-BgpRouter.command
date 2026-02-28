description: Updates the configuration of the local BGP router for the specified tenant
  ID
synopses:
- Set-BgpRouter [-BgpIdentifier <IPAddress>] [-LocalASN <UInt32>] [-CompareMEDAcrossASN
  <Boolean>] [-DefaultGatewayRouting <Boolean>] [-IPv6Routing <IPv6RoutingState>]
  [-RoutingDomain <String>] [-PassThru] [-Force] [-LocalIPv6Address <IPAddress>] [-TransitRouting
  <TransitRouting>] [-RouteReflector <RouteReflector>] [-ClusterId <UInt32>] [-ClientToClientReflection
  <ClientToClientReflection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BgpIdentifier IPAddress: ~
  -CimSession,-Session CimSession[]: ~
  -ClientToClientReflection ClientToClientReflection:
    values:
    - Disabled
    - Enabled
  -ClusterId UInt32: ~
  -CompareMEDAcrossASN Boolean: ~
  -Confirm,-cf Switch: ~
  -DefaultGatewayRouting Boolean: ~
  -Force Switch: ~
  -IPv6Routing IPv6RoutingState:
    values:
    - Disabled
    - Enabled
  -LocalASN UInt32: ~
  -LocalIPv6Address IPAddress: ~
  -PassThru Switch: ~
  -RouteReflector RouteReflector:
    values:
    - Disabled
    - Enabled
  -RoutingDomain,-RoutingDomainName String: ~
  -ThrottleLimit Int32: ~
  -TransitRouting TransitRouting:
    values:
    - Disabled
    - Enabled
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
