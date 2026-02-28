description: Creates an Active Directory Domain Services authentication policy object
synopses:
- New-ADAuthenticationPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-ComputerAllowedToAuthenticateTo
  <String>] [-ComputerTGTLifetimeMins <Int32>] [-Credential <PSCredential>] [-Description
  <String>] [-Enforce] [-Instance <ADAuthenticationPolicy>] [-Name] <String> [-OtherAttributes
  <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-RollingNTLMSecret
  <ADStrongNTLMPolicyType>] [-Server <String>] [-ServiceAllowedToAuthenticateFrom
  <String>] [-ServiceAllowedToAuthenticateTo <String>] [-ServiceAllowedNTLMNetworkAuthentication]
  [-ServiceTGTLifetimeMins <Int32>] [-UserAllowedToAuthenticateFrom <String>] [-UserAllowedToAuthenticateTo
  <String>] [-UserAllowedNTLMNetworkAuthentication] [-UserTGTLifetimeMins <Int32>]
  [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -ComputerAllowedToAuthenticateTo String: ~
  -ComputerTGTLifetimeMins Int32: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enforce Switch: ~
  -Instance ADAuthenticationPolicy: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -RollingNTLMSecret ADStrongNTLMPolicyType:
    values:
    - Disabled
    - Optional
    - Required
  -Server String: ~
  -ServiceAllowedNTLMNetworkAuthentication Switch: ~
  -ServiceAllowedToAuthenticateFrom String: ~
  -ServiceAllowedToAuthenticateTo String: ~
  -ServiceTGTLifetimeMins Int32: ~
  -UserAllowedNTLMNetworkAuthentication Switch: ~
  -UserAllowedToAuthenticateFrom String: ~
  -UserAllowedToAuthenticateTo String: ~
  -UserTGTLifetimeMins Int32: ~
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
