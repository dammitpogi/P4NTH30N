description: Disables an endpoint of AD FS
synopses:
- Disable-AdfsEndpoint [[-TargetAddressPath] <String>] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-AdfsEndpoint [-TargetEndpoint] <Endpoint> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-AdfsEndpoint [-TargetFullUrl] <Uri> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetAddressPath String: ~
  -TargetEndpoint Endpoint:
    required: true
  -TargetFullUrl Uri:
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
