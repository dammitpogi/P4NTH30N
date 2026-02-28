description: Restores the CA database and private key information
synopses:
- Restore-CARoleService [-Path] <String> [-Force] [-KeyOnly] [-Password <SecureString>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Restore-CARoleService [-Path] <String> [-Force] [-DatabaseOnly] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Restore-CARoleService [-Path] <String> [-Force] [-Password <SecureString>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DatabaseOnly Switch:
    required: true
  -Force Switch: ~
  -KeyOnly Switch:
    required: true
  -Password SecureString: ~
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
