description: Disables an OAuth 2.0 client that is currently registered with AD FS
synopses:
- Disable-AdfsClient [[-TargetName] <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsClient [-TargetClientId] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Disable-AdfsClient [-TargetClient] <AdfsClient> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetClient AdfsClient:
    required: true
  -TargetClientId String:
    required: true
  -TargetName String: ~
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
