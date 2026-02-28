description: Modifies an Active Directory domain
synopses:
- Set-ADDomain [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AllowedDNSSuffixes <Hashtable>]
  [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Identity]
  <ADDomain> [-LastLogonReplicationInterval <TimeSpan>] [-ManagedBy <ADPrincipal>]
  [-PassThru] [-PublicKeyRequiredPasswordRolling <Boolean>] [-Remove <Hashtable>]
  [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADDomain [-WhatIf] [-Confirm] [-AllowedDNSSuffixes <Hashtable>] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] -Instance <ADDomain> [-LastLogonReplicationInterval
  <TimeSpan>] [-ManagedBy <ADPrincipal>] [-PassThru] [-PublicKeyRequiredPasswordRolling
  <Boolean>] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AllowedDNSSuffixes Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Identity ADDomain:
    required: true
  -Instance ADDomain:
    required: true
  -LastLogonReplicationInterval TimeSpan: ~
  -ManagedBy ADPrincipal: ~
  -PassThru Switch: ~
  -PublicKeyRequiredPasswordRolling Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
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
