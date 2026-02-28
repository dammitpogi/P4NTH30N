description: Modifies a virtual machine switch provider for network events
synopses:
- Set-NetEventVmSwitchProvider [[-SessionName] <String[]>] [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-SwitchName] <String>] [[-PortIds] <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetEventVmSwitchProvider [-AssociatedEventSession <CimInstance>] [[-Level] <Byte>]
  [[-MatchAnyKeyword] <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-SwitchName] <String>]
  [[-PortIds] <UInt32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventVmSwitchProvider -InputObject <CimInstance[]> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [[-SwitchName] <String>] [[-PortIds] <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedEventSession CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -PassThru Switch: ~
  -PortIds UInt32[]: ~
  -SessionName String[]: ~
  -SwitchName String: ~
  -ThrottleLimit Int32: ~
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
