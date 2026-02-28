description: Changes configuration settings of a file screen template
synopses:
- Set-FsrmFileScreenTemplate [-Name] <String[]> [-Description <String>] [-IncludeGroup
  <String[]>] [-Active] [-UpdateDerived] [-UpdateDerivedMatching] [-Notification <CimInstance[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-FsrmFileScreenTemplate -InputObject <CimInstance[]> [-Description <String>]
  [-IncludeGroup <String[]>] [-Active] [-UpdateDerived] [-UpdateDerivedMatching] [-Notification
  <CimInstance[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Active Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -IncludeGroup String[]: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -Notification CimInstance[]: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -UpdateDerived Switch: ~
  -UpdateDerivedMatching Switch: ~
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
