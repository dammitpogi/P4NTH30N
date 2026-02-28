description: Updates an existing deployment of AD RMS Server
synopses:
- Update-ADRMS [-ServiceAccount] <PSCredential> [[-PrivateKeyPassword] <SecureString>]
  [[-NewCspName] <String>] [-UpdateCryptographicModeOnly] [-Credential <PSCredential>]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -NewCspName String: ~
  -PrivateKeyPassword SecureString: ~
  -ServiceAccount PSCredential:
    required: true
  -UpdateCryptographicModeOnly Switch: ~
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
