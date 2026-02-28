description: Modifies a resource property in Active Directory
synopses:
- Set-ADResourceProperty [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AppliesToResourceTypes
  <Hashtable>] [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-Enabled <Boolean>] [-Identity]
  <ADResourceProperty> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove
  <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [-SharesValuesWith <ADClaimType>]
  [-SuggestedValues <ADSuggestedValueEntry[]>] [<CommonParameters>]
- Set-ADResourceProperty [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADResourceProperty> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AppliesToResourceTypes Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -Enabled Boolean: ~
  -Identity ADResourceProperty:
    required: true
  -Instance ADResourceProperty:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -Server String: ~
  -SharesValuesWith ADClaimType: ~
  -SuggestedValues ADSuggestedValueEntry[]: ~
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
