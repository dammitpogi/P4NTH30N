description: Enables an endpoint in AD FS
synopses:
- Enable-AdfsEndpoint [[-TargetAddressPath] <String>] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-AdfsEndpoint [-TargetEndpoint] <Endpoint> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-AdfsEndpoint [-TargetFullUrl] <Uri> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
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
