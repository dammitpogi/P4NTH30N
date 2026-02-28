description: Removes an attribute store from the Federation Service
synopses:
- Remove-AdfsAttributeStore [-TargetName] <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsAttributeStore [-TargetAttributeStore] <AttributeStore> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetAttributeStore AttributeStore:
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
