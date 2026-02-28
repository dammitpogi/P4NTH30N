description: Sets the properties of a claims transformation policy in Active Directory
synopses:
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] -DenyAllExcept <ADClaimType[]>
  [-Description <String>] [-Identity] <ADClaimTransformPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-DenyAll] [-Description <String>]
  [-Identity] <ADClaimTransformPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>]
  [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>] [-Identity]
  <ADClaimTransformPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-Remove <Hashtable>] [-Replace <Hashtable>] [-Rule <String>] [-Server <String>]
  [<CommonParameters>]
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AllowAll] [-AuthType
  <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>] [-Description <String>]
  [-Identity] <ADClaimTransformPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-Add <Hashtable>] -AllowAllExcept
  <ADClaimType[]> [-AuthType <ADAuthType>] [-Clear <String[]>] [-Credential <PSCredential>]
  [-Description <String>] [-Identity] <ADClaimTransformPolicy> [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Remove <Hashtable>] [-Replace <Hashtable>] [-Server <String>] [<CommonParameters>]
- Set-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -Instance <ADClaimTransformPolicy> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AllowAll Switch:
    required: true
    values:
    - 'true'
  -AllowAllExcept ADClaimType[]:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DenyAll Switch:
    required: true
    values:
    - 'true'
  -DenyAllExcept ADClaimType[]:
    required: true
  -Description String: ~
  -Identity ADClaimTransformPolicy:
    required: true
  -Instance ADClaimTransformPolicy:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
  -Rule String: ~
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
