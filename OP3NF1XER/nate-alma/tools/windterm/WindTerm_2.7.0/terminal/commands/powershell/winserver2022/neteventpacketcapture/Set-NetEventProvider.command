description: Modifies settings for an ETW provider
synopses:
- Set-NetEventProvider [[-Name] <String[]>] [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventProvider [-AssociatedEventSession <CimInstance>] [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventProvider [-AssociatedCaptureTarget <CimInstance>] [[-Level] <Byte>]
  [[-MatchAnyKeyword] <UInt64>] [[-MatchAllKeyword] <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventProvider -InputObject <CimInstance[]> [[-Level] <Byte>] [[-MatchAnyKeyword]
  <UInt64>] [[-MatchAllKeyword] <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedCaptureTarget CimInstance: ~
  -AssociatedEventSession CimInstance: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -Name String[]: ~
  -PassThru Switch: ~
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
