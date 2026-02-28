description: Adds a new BGP peer
synopses:
- Add-BgpPeer [-Name] <String> -LocalIPAddress <IPAddress> -PeerIPAddress <IPAddress>
  [-LocalASN <UInt32>] -PeerASN <UInt32> [-OperationMode <OperationMode>] [-PeeringMode
  <PeeringMode>] [-HoldTimeSec <UInt16>] [-IdleHoldTimeSec <UInt16>] [-MaxAllowedPrefix
  <UInt32>] [-PassThru] [-RoutingDomain <String>] [-Weight <UInt16>] [-RouteReflectorClient
  <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -HoldTimeSec UInt16: ~
  -IdleHoldTimeSec UInt16: ~
  -LocalASN UInt32: ~
  -LocalIPAddress IPAddress:
    required: true
  -MaxAllowedPrefix UInt32: ~
  -Name,-PeerName,-PeerId String:
    required: true
  -OperationMode OperationMode:
    values:
    - Mixed
    - Server
  -PassThru Switch: ~
  -PeerASN UInt32:
    required: true
  -PeerIPAddress IPAddress:
    required: true
  -PeeringMode PeeringMode:
    values:
    - Automatic
    - Manual
  -RouteReflectorClient Boolean: ~
  -RoutingDomain,-RoutingDomainName String: ~
  -ThrottleLimit Int32: ~
  -Weight UInt16: ~
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
