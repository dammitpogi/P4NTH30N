description: Modifies a resource property list in Active Directory
synopses:
- Set-ADResourcePropertyList [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>] [-Identity]
  <ADResourcePropertyList> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADResourcePropertyList [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADResourcePropertyList> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Identity ADResourcePropertyList:
    required: true
  -Instance ADResourcePropertyList:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
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
