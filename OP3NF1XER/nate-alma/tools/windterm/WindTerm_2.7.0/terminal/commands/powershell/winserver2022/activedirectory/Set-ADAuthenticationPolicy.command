description: Modifies an Active Directory Domain Services authentication policy object
synopses:
- Set-ADAuthenticationPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-ComputerAllowedToAuthenticateTo <String>] [-ComputerTGTLifetimeMins
  <Int32>] [-Credential <PSCredential>] [-Description <String>] [-Enforce <Boolean>]
  [-Identity] <ADAuthenticationPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-RollingNTLMSecret <ADStrongNTLMPolicyType>]
  [-Server <String>] [-ServiceAllowedToAuthenticateFrom <String>] [-ServiceAllowedToAuthenticateTo
  <String>] [-ServiceAllowedNTLMNetworkAuthentication <Boolean>] [-ServiceTGTLifetimeMins
  <Int32>] [-UserAllowedToAuthenticateFrom <String>] [-UserAllowedToAuthenticateTo
  <String>] [-UserAllowedNTLMNetworkAuthentication <Boolean>] [-UserTGTLifetimeMins
  <Int32>] [<CommonParameters>]
- Set-ADAuthenticationPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADAuthenticationPolicy> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -ComputerAllowedToAuthenticateTo String: ~
  -ComputerTGTLifetimeMins Int32: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enforce Boolean: ~
  -Identity ADAuthenticationPolicy:
    required: true
  -Instance ADAuthenticationPolicy:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -RollingNTLMSecret ADStrongNTLMPolicyType:
    values:
    - Disabled
    - Optional
    - Required
  -Server String: ~
  -ServiceAllowedNTLMNetworkAuthentication Boolean: ~
  -ServiceAllowedToAuthenticateFrom String: ~
  -ServiceAllowedToAuthenticateTo String: ~
  -ServiceTGTLifetimeMins Int32: ~
  -UserAllowedNTLMNetworkAuthentication Boolean: ~
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
