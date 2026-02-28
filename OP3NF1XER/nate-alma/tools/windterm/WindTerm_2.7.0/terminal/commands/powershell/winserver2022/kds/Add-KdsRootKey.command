description: Generates a new root key for the Microsoft Group KdsSvc within Active
  Directory
synopses:
- Add-KdsRootKey [-LocalTestOnly] [[-EffectiveTime] <DateTime>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-KdsRootKey [-LocalTestOnly] [-EffectiveImmediately] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -EffectiveImmediately Switch:
    required: true
  -EffectiveTime DateTime: ~
  -LocalTestOnly Switch: ~
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
