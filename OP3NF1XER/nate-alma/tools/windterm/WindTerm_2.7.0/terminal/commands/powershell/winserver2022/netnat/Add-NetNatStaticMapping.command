description: Adds a static mapping to a NAT instance
synopses:
- Add-NetNatStaticMapping [-NatName] <String> -Protocol <Protocol> [-RemoteExternalIPAddressPrefix
  <String>] -ExternalIPAddress <String> -ExternalPort <UInt16> -InternalIPAddress
  <String> [-InternalPort <UInt16>] [-InternalRoutingDomainId <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ExternalIPAddress String:
    required: true
  -ExternalPort UInt16:
    required: true
  -InternalIPAddress String:
    required: true
  -InternalPort UInt16: ~
  -InternalRoutingDomainId String: ~
  -NatName String:
    required: true
  -Protocol Protocol:
    required: true
    values:
    - TCP
    - UDP
  -RemoteExternalIPAddressPrefix String: ~
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
