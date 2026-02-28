description: Deletes the value of a variable
synopses:
- Clear-Variable [-Name] <String[]> [-Include <String[]>] [-Exclude <String[]>] [-Force]
  [-PassThru] [-Scope <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Exclude System.String[]: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -Name System.String[]:
    required: true
  -PassThru Switch: ~
  -Scope System.String: ~
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
