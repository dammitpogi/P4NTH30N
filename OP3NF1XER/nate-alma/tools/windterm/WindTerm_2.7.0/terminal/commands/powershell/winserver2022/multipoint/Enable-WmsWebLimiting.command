description: Enables web limiting for a session
synopses:
- Enable-WmsWebLimiting [-SessionId] <UInt32[]> [-Server <String>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-WmsWebLimiting [-All] [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Confirm,-cf Switch: ~
  -Server,-ComputerName String: ~
  -SessionId UInt32[]:
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
