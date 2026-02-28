description: Creates a VFP provider for network events
synopses:
- Add-NetEventVFPProvider [-SessionName] <String> [[-Level] <Byte>] [[-UDPPorts] <UInt16[]>]
  [[-MatchAllKeywords] <UInt64>] [[-TCPPorts] <UInt16[]>] [[-MatchAnyKeyword] <UInt64>]
  [[-IPProtocols] <Byte[]>] [[-DestinationIPAddresses] <String[]>] [[-SourceMACAddresses]
  <String[]>] [[-VFPFlowDirection] <UInt32>] [[-VLANIds] <UInt16[]>] [[-SourceIPAddresses]
  <String[]>] [[-TenantIds] <UInt32[]>] [[-GREKeys] <UInt32[]>] [[-DestinationMACAddresses]
  <String[]>] [[-SwitchName] <String>] [[-PortIds] <UInt32[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationIPAddresses String[]: ~
  -DestinationMACAddresses String[]: ~
  -GREKeys UInt32[]: ~
  -IPProtocols Byte[]: ~
  -Level Byte: ~
  -MatchAllKeywords UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -PortIds UInt32[]: ~
  -SessionName String:
    required: true
  -SourceIPAddresses String[]: ~
  -SourceMACAddresses String[]: ~
  -SwitchName String: ~
  -TCPPorts UInt16[]: ~
  -TenantIds UInt32[]: ~
  -ThrottleLimit Int32: ~
  -UDPPorts UInt16[]: ~
  -VFPFlowDirection UInt32: ~
  -VLANIds UInt16[]: ~
  -Confirm,-cf Switch: ~
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
