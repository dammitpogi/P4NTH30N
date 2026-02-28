description: Configures a new deployment of AD RMS Server
synopses:
- Install-ADRMS [-Path] <String> [-Credential <PSCredential>] [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Install-ADRMS [-ADFSUrl] <String> [-Credential <PSCredential>] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -ADFSUrl String:
    required: true
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -Path String:
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
