description: Changes a classification property definition
synopses:
- Set-FsrmClassificationPropertyDefinition [-Name] <String[]> [-DisplayName <String>]
  [-Description <String>] [-PossibleValue <CimInstance[]>] [-Parameters <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-FsrmClassificationPropertyDefinition -InputObject <CimInstance[]> [-DisplayName
  <String>] [-Description <String>] [-PossibleValue <CimInstance[]>] [-Parameters
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayName String: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -Parameters String[]: ~
  -PassThru Switch: ~
  -PossibleValue CimInstance[]: ~
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
