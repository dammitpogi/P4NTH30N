description: Installs an Active Directory managed service account on a computer or
  caches a group managed service account on a computer
synopses:
- Install-ADServiceAccount [-WhatIf] [-Confirm] [-AccountPassword <SecureString>]
  [-AuthType <ADAuthType>] [-Force] [-Identity] <ADServiceAccount> [-PromptForPassword]
  [<CommonParameters>]
options:
  -AccountPassword SecureString: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -Identity ADServiceAccount:
    required: true
  -PromptForPassword Switch: ~
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
