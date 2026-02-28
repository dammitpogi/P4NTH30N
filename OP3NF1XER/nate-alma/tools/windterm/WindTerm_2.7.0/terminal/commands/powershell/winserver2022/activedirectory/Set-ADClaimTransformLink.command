description: Applies a claims transformation to one or more cross-forest trust relationships
  in Active Directory
synopses:
- Set-ADClaimTransformLink [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Identity] <ADTrust> [-PassThru] [-Policy] <ADClaimTransformPolicy>
  [-Server <String>] -TrustRole <ADTrustRole> [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADTrust:
    required: true
  -PassThru Switch: ~
  -Policy ADClaimTransformPolicy:
    required: true
  -Server String: ~
  -TrustRole ADTrustRole:
    required: true
    values:
    - Trusted
    - Trusting
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
