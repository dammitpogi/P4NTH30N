description: Removes the templates from the CA which were set for issuance of certificates
synopses:
- Remove-CATemplate [-Name] <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-CATemplate [-AllTemplates] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllTemplates Switch:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -Name String:
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
