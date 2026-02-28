description: Adds an ETW trace provider to an ETW trace session or AutoLogger session
  configuration
synopses:
- Add-EtwTraceProvider [-Guid] <String> [-Level <Byte>] [-MatchAnyKeyword <UInt64>]
  [-MatchAllKeyword <UInt64>] [-Property <UInt32>] -SessionName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-EtwTraceProvider [-Guid] <String> -AutologgerName <String> [-Level <Byte>] [-MatchAnyKeyword
  <UInt64>] [-MatchAllKeyword <UInt64>] [-Property <UInt32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutologgerName String:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Guid String:
    required: true
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -Property UInt32: ~
  -SessionName String:
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
