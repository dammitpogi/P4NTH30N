description: Modifies a central access rule in Active Directory
synopses:
- Set-ADCentralAccessRule [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-CurrentAcl <String>] [-Description
  <String>] [-Identity] <ADCentralAccessRule> [-PassThru] [-ProposedAcl <String>]
  [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>]
  [-ResourceCondition <String>] [-Server <String>] [<CommonParameters>]
- Set-ADCentralAccessRule [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADCentralAccessRule> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -CurrentAcl String: ~
  -Description String: ~
  -Identity ADCentralAccessRule:
    required: true
  -Instance ADCentralAccessRule:
    required: true
  -PassThru Switch: ~
  -ProposedAcl String: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -ResourceCondition String: ~
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
