description: Adds a BGP router for the specified Tenant ID
synopses:
- Add-BgpRouter -BgpIdentifier <IPAddress> -LocalASN <UInt32> [-IPv6Routing <IPv6RoutingState>]
  [-CompareMEDAcrossASN <Boolean>] [-DefaultGatewayRouting <Boolean>] [-PassThru]
  [-Force] [-RoutingDomain <String>] [-LocalIPv6Address <IPAddress>] [-TransitRouting
  <TransitRouting>] [-RouteReflector <RouteReflector>] [-ClusterId <UInt32>] [-ClientToClientReflection
  <ClientToClientReflection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BgpIdentifier IPAddress:
    required: true
  -CimSession,-Session CimSession[]: ~
  -ClientToClientReflection ClientToClientReflection:
    values:
    - Disabled
    - Enabled
  -ClusterId UInt32: ~
  -CompareMEDAcrossASN Boolean: ~
  -DefaultGatewayRouting Boolean: ~
  -Force Switch: ~
  -IPv6Routing IPv6RoutingState:
    values:
    - Disabled
    - Enabled
  -LocalASN UInt32:
    required: true
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
