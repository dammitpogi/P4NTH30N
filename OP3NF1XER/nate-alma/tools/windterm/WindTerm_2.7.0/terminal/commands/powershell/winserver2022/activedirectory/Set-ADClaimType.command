description: Modify a claim type in Active Directory
synopses:
- Set-ADClaimType [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AppliesToClasses <String[]>]
  [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description
  <String>] [-DisplayName <String>] [-Enabled <Boolean>] [-Identity] <ADClaimType>
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-RestrictValues <Boolean>] [-Server <String>] [-SuggestedValues <ADSuggestedValueEntry[]>]
  [<CommonParameters>]
- Set-ADClaimType [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AppliesToClasses <String[]>]
  [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description
  <String>] [-DisplayName <String>] [-Enabled <Boolean>] [-Identity] <ADClaimType>
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-RestrictValues <Boolean>] [-Server <String>] [-SourceTransformPolicy]
  [-SuggestedValues <ADSuggestedValueEntry[]>] [<CommonParameters>]
- Set-ADClaimType [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AppliesToClasses <String[]>]
  [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description
  <String>] [-DisplayName <String>] [-Enabled <Boolean>] [-Identity] <ADClaimType>
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-RestrictValues <Boolean>] [-Server <String>] -SourceAttribute <String>
  [-SuggestedValues <ADSuggestedValueEntry[]>] [<CommonParameters>]
- Set-ADClaimType [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AppliesToClasses <String[]>]
  [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description
  <String>] [-DisplayName <String>] [-Enabled <Boolean>] [-Identity] <ADClaimType>
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Remove <Hashtable>] [-Replace
  <Hashtable>] [-RestrictValues <Boolean>] [-Server <String>] -SourceOID <String>
  [<CommonParameters>]
- Set-ADClaimType [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Instance <ADClaimType> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AppliesToClasses String[]: ~
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
  -Identity ADClaimType:
    required: true
  -Instance ADClaimType:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -RestrictValues Boolean: ~
  -Server String: ~
  -SourceAttribute String:
    required: true
  -SourceOID String:
    required: true
  -SourceTransformPolicy Switch:
    required: true
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
