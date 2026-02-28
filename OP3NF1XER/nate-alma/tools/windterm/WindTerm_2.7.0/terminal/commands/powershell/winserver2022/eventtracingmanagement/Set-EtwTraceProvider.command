description: Modifies a provider's enablement settings in an ETW or AutoLogger session
synopses:
- Set-EtwTraceProvider [[-Guid] <String[]>] [-AutologgerName <String[]>] [-Level <Byte>]
  [-MatchAnyKeyword <UInt64>] [-MatchAllKeyword <UInt64>] [-Property <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-EtwTraceProvider [[-Guid] <String[]>] [-SessionName <String[]>] [-Level <Byte>]
  [-MatchAnyKeyword <UInt64>] [-MatchAllKeyword <UInt64>] [-Property <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-EtwTraceProvider -InputObject <CimInstance[]> [-Level <Byte>] [-MatchAnyKeyword
  <UInt64>] [-MatchAllKeyword <UInt64>] [-Property <UInt32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutologgerName String[]: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Guid String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Level Byte: ~
  -MatchAllKeyword UInt64: ~
  -MatchAnyKeyword UInt64: ~
  -PassThru Switch: ~
  -Property UInt32: ~
  -SessionName String[]: ~
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
