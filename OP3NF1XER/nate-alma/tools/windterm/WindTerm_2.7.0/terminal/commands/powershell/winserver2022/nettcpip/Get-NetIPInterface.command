description: Gets an IP interface
synopses:
- Get-NetIPInterface [-InterfaceIndex <UInt32[]>] [[-InterfaceAlias] <String[]>] [-AddressFamily
  <AddressFamily[]>] [-Forwarding <Forwarding[]>] [-ClampMss <ClampMss[]>] [-Advertising
  <Advertising[]>] [-NlMtuBytes <UInt32[]>] [-InterfaceMetric <UInt32[]>] [-NeighborUnreachabilityDetection
  <NeighborUnreachabilityDetection[]>] [-BaseReachableTimeMs <UInt32[]>] [-ReachableTimeMs
  <UInt32[]>] [-RetransmitTimeMs <UInt32[]>] [-DadTransmits <UInt32[]>] [-DadRetransmitTimeMs
  <UInt32[]>] [-RouterDiscovery <RouterDiscovery[]>] [-ManagedAddressConfiguration
  <ManagedAddressConfiguration[]>] [-OtherStatefulConfiguration <OtherStatefulConfiguration[]>]
  [-WeakHostSend <WeakHostSend[]>] [-WeakHostReceive <WeakHostReceive[]>] [-IgnoreDefaultRoutes
  <IgnoreDefaultRoutes[]>] [-AdvertisedRouterLifetime <TimeSpan[]>] [-AdvertiseDefaultRoute
  <AdvertiseDefaultRoute[]>] [-CurrentHopLimit <UInt32[]>] [-ForceArpNdWolPattern
  <ForceArpNdWolPattern[]>] [-DirectedMacWolPattern <DirectedMacWolPattern[]>] [-EcnMarking
  <EcnMarking[]>] [-Dhcp <Dhcp[]>] [-ConnectionState <ConnectionState[]>] [-AutomaticMetric
  <AutomaticMetric[]>] [-NeighborDiscoverySupported <NeighborDiscoverySupported[]>]
  [-CompartmentId <UInt32[]>] [-PolicyStore <String>] [-IncludeAllCompartments] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPInterface [-AssociatedRoute <CimInstance>] [-IncludeAllCompartments] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPInterface [-AssociatedIPAddress <CimInstance>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPInterface [-AssociatedNeighbor <CimInstance>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetIPInterface [-AssociatedAdapter <CimInstance>] [-IncludeAllCompartments]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddressFamily AddressFamily[]:
    values:
    - IPv4
    - IPv6
  -AdvertiseDefaultRoute AdvertiseDefaultRoute[]:
    values:
    - Disabled
    - Enabled
  -AdvertisedRouterLifetime TimeSpan[]: ~
  -Advertising Advertising[]:
    values:
    - Disabled
    - Enabled
  -AsJob Switch: ~
  -AssociatedAdapter CimInstance: ~
  -AssociatedIPAddress CimInstance: ~
  -AssociatedNeighbor CimInstance: ~
  -AssociatedRoute CimInstance: ~
  -AutomaticMetric AutomaticMetric[]:
    values:
    - Disabled
    - Enabled
  -BaseReachableTimeMs,-BaseReachableTime UInt32[]: ~
  -CimSession,-Session CimSession[]: ~
  -ClampMss ClampMss[]:
    values:
    - Disabled
    - Enabled
  -CompartmentId UInt32[]: ~
  -ConnectionState ConnectionState[]:
    values:
    - Disconnected
    - Connected
  -CurrentHopLimit UInt32[]: ~
  -DadRetransmitTimeMs,-DadRetransmitTime UInt32[]: ~
  -DadTransmits UInt32[]: ~
  -Dhcp Dhcp[]:
    values:
    - Disabled
    - Enabled
  -DirectedMacWolPattern DirectedMacWolPattern[]:
    values:
    - Disabled
    - Enabled
  -EcnMarking EcnMarking[]:
    values:
    - Disabled
    - UseEct1
    - UseEct0
    - AppDecide
  -ForceArpNdWolPattern ForceArpNdWolPattern[]:
    values:
    - Disabled
    - Enabled
  -Forwarding Forwarding[]:
    values:
    - Disabled
    - Enabled
  -IgnoreDefaultRoutes IgnoreDefaultRoutes[]:
    values:
    - Disabled
    - Enabled
  -IncludeAllCompartments Switch: ~
  -InterfaceAlias,-ifAlias String[]: ~
  -InterfaceIndex,-ifIndex UInt32[]: ~
  -InterfaceMetric UInt32[]: ~
  -ManagedAddressConfiguration ManagedAddressConfiguration[]:
    values:
    - Disabled
    - Enabled
  -NeighborDiscoverySupported NeighborDiscoverySupported[]:
    values:
    - No
    - Yes
  -NeighborUnreachabilityDetection NeighborUnreachabilityDetection[]:
    values:
    - Disabled
    - Enabled
  -NlMtuBytes UInt32[]: ~
  -OtherStatefulConfiguration OtherStatefulConfiguration[]:
    values:
    - Disabled
    - Enabled
  -PolicyStore String: ~
  -ReachableTimeMs,-ReachableTime UInt32[]: ~
  -RetransmitTimeMs,-RetransmitTime UInt32[]: ~
  -RouterDiscovery RouterDiscovery[]:
    values:
    - Disabled
    - Enabled
    - ControlledByDHCP
  -ThrottleLimit Int32: ~
  -WeakHostReceive WeakHostReceive[]:
    values:
    - Disabled
    - Enabled
  -WeakHostSend WeakHostSend[]:
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
