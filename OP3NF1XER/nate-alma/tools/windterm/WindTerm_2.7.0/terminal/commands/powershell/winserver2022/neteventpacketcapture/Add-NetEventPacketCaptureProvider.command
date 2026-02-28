description: Adds a Remote Packet Capture provider
synopses:
- Add-NetEventPacketCaptureProvider [-SessionName] <String> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-CaptureType] <CaptureType>] [[-MultiLayer]
  <Boolean>] [[-LinkLayerAddress] <String[]>] [[-EtherType] <UInt16[]>] [[-IpAddresses]
  <String[]>] [[-IpProtocols] <Byte[]>] [[-TruncationLength] <UInt16>] [[-VmCaptureDirection]
  <VmCaptureDirection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CaptureType CaptureType:
    values:
    - Physical
    - Switch
    - BothPhysicalAndSwitch
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EtherType UInt16[]: ~
  -IpAddresses String[]: ~
  -IpProtocols Byte[]: ~
  -Level Byte: ~
  -LinkLayerAddress String[]: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -MultiLayer Boolean: ~
  -SessionName String:
    required: true
  -ThrottleLimit Int32: ~
  -TruncationLength UInt16: ~
  -VmCaptureDirection VmCaptureDirection:
    values:
    - Ingress
    - Egress
    - IngressAndEgress
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
