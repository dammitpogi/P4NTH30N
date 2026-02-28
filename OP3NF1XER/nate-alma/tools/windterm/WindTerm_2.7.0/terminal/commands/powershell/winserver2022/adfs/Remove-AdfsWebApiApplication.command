description: Removes a Web API application role from an application in AD FS
synopses:
- Remove-AdfsWebApiApplication [-TargetIdentifier] <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-AdfsWebApiApplication [-TargetName] <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsWebApiApplication [-TargetApplication] <WebApiApplication> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetApplication WebApiApplication:
    required: true
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
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
