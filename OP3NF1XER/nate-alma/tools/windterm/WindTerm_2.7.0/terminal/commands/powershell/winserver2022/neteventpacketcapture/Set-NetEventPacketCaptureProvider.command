description: Modifies the configuration for a Remote Packet Capture provider
synopses:
- Set-NetEventPacketCaptureProvider [[-SessionName] <String[]>] [-Level <Byte>] [-MatchAnyKeyword
  <UInt64>] [-MatchAllKeyword <UInt64>] [-CaptureType <CaptureType>] [-MultiLayer
  <Boolean>] [-LinkLayerAddress <String[]>] [-EtherType <UInt16[]>] [-IpAddresses
  <String[]>] [-IpProtocols <Byte[]>] [-TruncationLength <UInt16>] [-VmCaptureDirection
  <VmCaptureDirection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventPacketCaptureProvider [-AssociatedEventSession <CimInstance>] [-Level
  <Byte>] [-MatchAnyKeyword <UInt64>] [-MatchAllKeyword <UInt64>] [-CaptureType <CaptureType>]
  [-MultiLayer <Boolean>] [-LinkLayerAddress <String[]>] [-EtherType <UInt16[]>] [-IpAddresses
  <String[]>] [-IpProtocols <Byte[]>] [-TruncationLength <UInt16>] [-VmCaptureDirection
  <VmCaptureDirection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventPacketCaptureProvider [-AssociatedCaptureTarget <CimInstance>] [-Level
  <Byte>] [-MatchAnyKeyword <UInt64>] [-MatchAllKeyword <UInt64>] [-CaptureType <CaptureType>]
  [-MultiLayer <Boolean>] [-LinkLayerAddress <String[]>] [-EtherType <UInt16[]>] [-IpAddresses
  <String[]>] [-IpProtocols <Byte[]>] [-TruncationLength <UInt16>] [-VmCaptureDirection
  <VmCaptureDirection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventPacketCaptureProvider -InputObject <CimInstance[]> [-Level <Byte>] [-MatchAnyKeyword
  <UInt64>] [-MatchAllKeyword <UInt64>] [-CaptureType <CaptureType>] [-MultiLayer
  <Boolean>] [-LinkLayerAddress <String[]>] [-EtherType <UInt16[]>] [-IpAddresses
  <String[]>] [-IpProtocols <Byte[]>] [-TruncationLength <UInt16>] [-VmCaptureDirection
  <VmCaptureDirection>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedCaptureTarget CimInstance: ~
  -AssociatedEventSession CimInstance: ~
  -CaptureType CaptureType:
    values:
    - Physical
    - Switch
    - BothPhysicalAndSwitch
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EtherType UInt16[]: ~
  -InputObject CimInstance[]:
    required: true
  -IpAddresses String[]: ~
  -IpProtocols Byte[]: ~
  -Level Byte: ~
  -LinkLayerAddress String[]: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -MultiLayer Boolean: ~
  -PassThru Switch: ~
  -SessionName String[]: ~
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
