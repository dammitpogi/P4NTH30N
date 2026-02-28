description: Creates a traffic class
synopses:
- New-NetQosTrafficClass [-Name] <String> [-Algorithm] <Algorithm> [-BandwidthPercentage
  <Byte>] [-Priority] <Byte[]> [-InterfaceAlias <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NetQosTrafficClass [-Name] <String> [-Algorithm] <Algorithm> [-BandwidthPercentage
  <Byte>] [-Priority] <Byte[]> [-InterfaceIndex <UInt32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Algorithm,-tsa Algorithm:
    required: true
    values:
    - Strict
    - ETS
  -AsJob Switch: ~
  -BandwidthPercentage,-Bandwidth,-bw Byte: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InterfaceAlias,-IfAlias String: ~
  -InterfaceIndex,-IfIndex UInt32: ~
  -Name String:
    required: true
  -Priority,-p,-pri Byte[]:
    required: true
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
