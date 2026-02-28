description: Creates a WFP capture provider
synopses:
- Add-NetEventWFPCaptureProvider [-SessionName] <String> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-CaptureLayerSet] <WFPCaptureSet>] [[-IPAddresses]
  <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts] <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CaptureLayerSet WFPCaptureSet:
    values:
    - IPv4Inbound
    - IPv4Outbound
    - IPv6Inbound
    - IPv6Outbound
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPAddresses String[]: ~
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -SessionName String:
    required: true
  -TCPPorts UInt16[]: ~
  -ThrottleLimit Int32: ~
  -UDPPorts UInt16[]: ~
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
