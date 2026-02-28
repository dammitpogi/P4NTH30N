description: Creates an Active Directory Domain Services authentication policy silo
  object
synopses:
- New-ADAuthenticationPolicySilo [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-ComputerAuthenticationPolicy
  <ADAuthenticationPolicy>] [-Credential <PSCredential>] [-Description <String>] [-Enforce]
  [-Instance <ADAuthenticationPolicySilo>] [-Name] <String> [-OtherAttributes <Hashtable>]
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>] [-ServiceAuthenticationPolicy
  <ADAuthenticationPolicy>] [-UserAuthenticationPolicy <ADAuthenticationPolicy>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -ComputerAuthenticationPolicy ADAuthenticationPolicy: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enforce Switch: ~
  -Instance ADAuthenticationPolicySilo: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Server String: ~
  -ServiceAuthenticationPolicy ADAuthenticationPolicy: ~
  -UserAuthenticationPolicy ADAuthenticationPolicy: ~
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
