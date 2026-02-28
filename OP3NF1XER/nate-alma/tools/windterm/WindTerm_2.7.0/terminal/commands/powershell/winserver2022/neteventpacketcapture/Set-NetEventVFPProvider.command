description: Modifies a VFP provider for network events
synopses:
- Set-NetEventVFPProvider [[-SessionName] <String[]>] [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-VFPFlowDirection] <VFPFlowDirection>]
  [[-DestinationMACAddresses] <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts] <UInt16[]>]
  [[-SourceMACAddresses] <String[]>] [[-VLANIds] <UInt16[]>] [[-GREKeys] <UInt32[]>]
  [[-TenantIds] <UInt32[]>] [[-SourceIPAddresses] <String[]>] [[-DestinationIPAddresses]
  <String[]>] [[-IPProtocols] <Byte[]>] [[-SwitchName] <String>] [[-PortIds] <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetEventVFPProvider [-AssociatedEventSession <CimInstance>] [[-Level] <Byte>]
  [[-MatchAnyKeyword] <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-VFPFlowDirection]
  <VFPFlowDirection>] [[-DestinationMACAddresses] <String[]>] [[-TCPPorts] <UInt16[]>]
  [[-UDPPorts] <UInt16[]>] [[-SourceMACAddresses] <String[]>] [[-VLANIds] <UInt16[]>]
  [[-GREKeys] <UInt32[]>] [[-TenantIds] <UInt32[]>] [[-SourceIPAddresses] <String[]>]
  [[-DestinationIPAddresses] <String[]>] [[-IPProtocols] <Byte[]>] [[-SwitchName]
  <String>] [[-PortIds] <UInt32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventVFPProvider -InputObject <CimInstance[]> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-VFPFlowDirection] <VFPFlowDirection>]
  [[-DestinationMACAddresses] <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts] <UInt16[]>]
  [[-SourceMACAddresses] <String[]>] [[-VLANIds] <UInt16[]>] [[-GREKeys] <UInt32[]>]
  [[-TenantIds] <UInt32[]>] [[-SourceIPAddresses] <String[]>] [[-DestinationIPAddresses]
  <String[]>] [[-IPProtocols] <Byte[]>] [[-SwitchName] <String>] [[-PortIds] <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedEventSession CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -DestinationIPAddresses String[]: ~
  -DestinationMACAddresses String[]: ~
  -GREKeys UInt32[]: ~
  -InputObject CimInstance[]:
    required: true
  -IPProtocols Byte[]: ~
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -PassThru Switch: ~
  -PortIds UInt32[]: ~
  -SessionName String[]: ~
  -SourceIPAddresses String[]: ~
  -SourceMACAddresses String[]: ~
  -SwitchName String: ~
  -TCPPorts UInt16[]: ~
  -TenantIds UInt32[]: ~
  -ThrottleLimit Int32: ~
  -UDPPorts UInt16[]: ~
  -VFPFlowDirection VFPFlowDirection:
    values:
    - Inbound
    - Outbound
    - InboundAndOutbound
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
