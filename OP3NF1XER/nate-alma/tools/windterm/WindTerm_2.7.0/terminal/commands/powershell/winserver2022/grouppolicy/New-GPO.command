description: Creates a GPO
synopses:
- New-GPO [-Name] <String> [-Comment <String>] [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-GPO [-Name] <String> -StarterGpoGuid <Guid> [-Comment <String>] [-Domain <String>]
  [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-GPO [-Name] <String> -StarterGpoName <String> [-Comment <String>] [-Domain <String>]
  [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Comment String: ~
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
  -StarterGpoGuid,-Id Guid:
    required: true
  -StarterGpoName String:
    required: true
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
