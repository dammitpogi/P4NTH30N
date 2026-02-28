description: Modifies the configuration of a WFP capture provider
synopses:
- Set-NetEventWFPCaptureProvider [[-SessionName] <String[]>] [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-CaptureLayerSet] <WFPCaptureSet>] [[-IPAddresses]
  <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts] <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventWFPCaptureProvider [-AssociatedEventSession <CimInstance>] [[-Level]
  <Byte>] [[-MatchAnyKeyword] <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-CaptureLayerSet]
  <WFPCaptureSet>] [[-IPAddresses] <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts]
  <UInt16[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventWFPCaptureProvider -InputObject <CimInstance[]> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-CaptureLayerSet] <WFPCaptureSet>] [[-IPAddresses]
  <String[]>] [[-TCPPorts] <UInt16[]>] [[-UDPPorts] <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedEventSession CimInstance: ~
  -CaptureLayerSet WFPCaptureSet:
    values:
    - IPv4Inbound
    - IPv4Outbound
    - IPv6Inbound
    - IPv6Outbound
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -IPAddresses String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -PassThru Switch: ~
  -SessionName String[]: ~
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
