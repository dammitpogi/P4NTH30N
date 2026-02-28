description: Sets a restore flag for the user settings
synopses:
- Restore-UevUserSetting [-Force] -Application <String> [-LastKnownGood] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Restore-UevUserSetting [-TemplateId] <String> [-LastKnownGood] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Application String:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -LastKnownGood Switch: ~
  -TemplateId String:
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
