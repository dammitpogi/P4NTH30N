description: Sets the endpoint on a Web Application Proxy
synopses:
- Set-AdfsEndpoint [[-TargetAddressPath] <String>] -Proxy <Boolean> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsEndpoint -TargetEndpoint <Endpoint> -Proxy <Boolean> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsEndpoint [-TargetFullUrl] <Uri> -Proxy <Boolean> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -PassThru Switch: ~
  -Proxy Boolean:
    required: true
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
