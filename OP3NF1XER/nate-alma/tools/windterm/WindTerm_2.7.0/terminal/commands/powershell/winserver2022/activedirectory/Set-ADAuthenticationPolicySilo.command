description: Modifies an Active Directory Domain Services authentication policy silo
  object
synopses:
- Set-ADAuthenticationPolicySilo [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType
  <ADAuthType>] [-Clear <String[]>] [-ComputerAuthenticationPolicy <ADAuthenticationPolicy>]
  [-Credential <PSCredential>] [-Description <String>] [-Enforce <Boolean>] [-Identity]
  <ADAuthenticationPolicySilo> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [-ServiceAuthenticationPolicy
  <ADAuthenticationPolicy>] [-UserAuthenticationPolicy <ADAuthenticationPolicy>] [<CommonParameters>]
- Set-ADAuthenticationPolicySilo [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADAuthenticationPolicySilo> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -ComputerAuthenticationPolicy ADAuthenticationPolicy: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enforce Boolean: ~
  -Identity ADAuthenticationPolicySilo:
    required: true
  -Instance ADAuthenticationPolicySilo:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
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
