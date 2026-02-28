description: Sets the traffic class settings
synopses:
- Set-NetQosTrafficClass [[-Name] <String[]>] [[-InterfaceAlias] <String>] [-Algorithm
  <Algorithm>] [-BandwidthPercentage <Byte>] [-Priority <Byte[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetQosTrafficClass [[-Name] <String[]>] [[-InterfaceIndex] <UInt32>] [-Algorithm
  <Algorithm>] [-BandwidthPercentage <Byte>] [-Priority <Byte[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetQosTrafficClass -InputObject <CimInstance[]> [-Algorithm <Algorithm>] [-BandwidthPercentage
  <Byte>] [-Priority <Byte[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Algorithm,-tsa Algorithm:
    values:
    - Strict
    - ETS
  -AsJob Switch: ~
  -BandwidthPercentage,-Bandwidth,-bw Byte: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias,-IfAlias String: ~
  -InterfaceIndex,-IfIndex UInt32: ~
  -Name String[]: ~
  -PassThru Switch: ~
  -Priority,-p,-pri Byte[]: ~
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
