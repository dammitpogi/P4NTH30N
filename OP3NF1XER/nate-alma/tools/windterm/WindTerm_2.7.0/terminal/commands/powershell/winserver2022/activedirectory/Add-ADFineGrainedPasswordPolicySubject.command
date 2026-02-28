description: Applies a fine-grained password policy to one more users and groups
synopses:
- Add-ADFineGrainedPasswordPolicySubject [-WhatIf] [-Confirm] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Identity] <ADFineGrainedPasswordPolicy> [-Partition
  <String>] [-PassThru] [-Server <String>] [-Subjects] <ADPrincipal[]> [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADFineGrainedPasswordPolicy:
    required: true
  -Partition String: ~
  -PassThru Switch: ~
  -Server String: ~
  -Subjects ADPrincipal[]:
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
