description: Hides the identification window for a station or session
synopses:
- Hide-WmsIdentifier [-SessionId <UInt32[]>] [-Server <String>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Hide-WmsIdentifier [-StationId <UInt32[]>] [-Server <String>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Hide-WmsIdentifier [-All] [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Confirm,-cf Switch: ~
  -Server,-ComputerName String: ~
  -SessionId UInt32[]: ~
  -StationId UInt32[]: ~
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
