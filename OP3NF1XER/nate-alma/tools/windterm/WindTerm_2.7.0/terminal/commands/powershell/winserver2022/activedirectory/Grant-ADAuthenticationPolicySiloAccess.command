description: Grants permission to join an authentication policy silo
synopses:
- Grant-ADAuthenticationPolicySiloAccess [-WhatIf] [-Confirm] [-Account] <ADAccount>
  [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Identity] <ADAuthenticationPolicySilo>
  [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Account ADAccount:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADAuthenticationPolicySilo:
    required: true
  -PassThru Switch: ~
  -Server String: ~
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
