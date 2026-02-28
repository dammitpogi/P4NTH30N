description: Displays the Edit Access Control Conditions window update or create security
  descriptor definition language (SDDL) security descriptors
synopses:
- Show-ADAuthenticationPolicyExpression [-WhatIf] [-Confirm] [-AllowedToAuthenticateFrom]
  [-AuthType <ADAuthType>] [-Credential <PSCredential>] [[-SDDL] <String>] [-Server
  <String>] [[-Title] <String>] [<CommonParameters>]
- Show-ADAuthenticationPolicyExpression [-WhatIf] [-Confirm] [-AllowedToAuthenticateTo]
  [-AuthType <ADAuthType>] [-Credential <PSCredential>] [[-SDDL] <String>] [-Server
  <String>] [[-Title] <String>] [<CommonParameters>]
options:
  -AllowedToAuthenticateFrom Switch:
    required: true
  -AllowedToAuthenticateTo Switch:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -SDDL String: ~
  -Server String: ~
  -Title String: ~
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
