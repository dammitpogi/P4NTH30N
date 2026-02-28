description: Creates a classification property definition
synopses:
- New-FsrmClassificationPropertyDefinition [-Name] <String> [-DisplayName <String>]
  [-Description <String>] -Type <PropertyDefinitionTypeEnum> [-PossibleValue <CimInstance[]>]
  [-Parameters <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DisplayName String: ~
  -Name String:
    required: true
  -Parameters String[]: ~
  -PossibleValue CimInstance[]: ~
  -ThrottleLimit Int32: ~
  -Type PropertyDefinitionTypeEnum:
    required: true
    values:
    - OrderedList
    - MultiChoice
    - SingleChoice
    - String
    - MultiString
    - Integer
    - YesNo
    - DateTime
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
