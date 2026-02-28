description: Modifies port filter objects, thereby modifying the protocol and port
  conditions using the Protocol, LocalPort, RemotePort, IcmpType, and DynamicTransport
  parameters of the firewall or IPsec rules
synopses:
- Set-NetFirewallPortFilter [-PolicyStore <String>] [-GPOSession <String>] [-Protocol
  <String>] [-LocalPort <String[]>] [-RemotePort <String[]>] [-IcmpType <String[]>]
  [-DynamicTarget <DynamicTransport>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetFirewallPortFilter -InputObject <CimInstance[]> [-Protocol <String>] [-LocalPort
  <String[]>] [-RemotePort <String[]>] [-IcmpType <String[]>] [-DynamicTarget <DynamicTransport>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DynamicTarget,-DynamicTransport DynamicTransport:
    values:
    - Any
    - ProximityApps
    - ProximitySharing
    - WifiDirectPrinting
    - WifiDirectDisplay
    - WifiDirectDevices
  -GPOSession String: ~
  -IcmpType String[]: ~
  -InputObject CimInstance[]:
    required: true
  -LocalPort String[]: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -Protocol String: ~
  -RemotePort String[]: ~
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
