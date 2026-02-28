description: Deletes registration information for an OAuth 2.0 client that is currently
  registered with AD FS
synopses:
- Remove-AdfsClient [-TargetName] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsClient [-TargetClientId] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsClient [-TargetClient] <AdfsClient> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetClient AdfsClient:
    required: true
  -TargetClientId String:
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
