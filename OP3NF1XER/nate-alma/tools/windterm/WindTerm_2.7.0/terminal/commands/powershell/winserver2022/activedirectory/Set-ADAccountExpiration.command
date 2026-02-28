description: Sets the expiration date for an Active Directory account
synopses:
- Set-ADAccountExpiration [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [[-DateTime] <DateTime>] [-Identity] <ADAccount> [-Partition <String>]
  [-PassThru] [-Server <String>] [-TimeSpan <TimeSpan>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DateTime DateTime: ~
  -Identity ADAccount:
    required: true
  -Partition String: ~
  -PassThru Switch: ~
  -Server String: ~
  -TimeSpan TimeSpan: ~
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
