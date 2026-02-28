description: Creates a new claim type in Active Directory
synopses:
- New-ADClaimType [-WhatIf] [-Confirm] [-AppliesToClasses <String[]>] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Description <String>] [-DisplayName] <String> [-Enabled
  <Boolean>] [-ID <String>] [-Instance <ADClaimType>] [-IsSingleValued <Boolean>]
  [-OtherAttributes <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-RestrictValues <Boolean>] [-Server <String>] -SourceAttribute <String> [-SuggestedValues
  <ADSuggestedValueEntry[]>] [<CommonParameters>]
- New-ADClaimType [-WhatIf] [-Confirm] [-AppliesToClasses <String[]>] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Description <String>] [-DisplayName] <String> [-Enabled
  <Boolean>] [-ID <String>] [-Instance <ADClaimType>] [-IsSingleValued <Boolean>]
  [-OtherAttributes <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-RestrictValues <Boolean>] [-Server <String>] -SourceOID <String> [<CommonParameters>]
- New-ADClaimType [-WhatIf] [-Confirm] [-AppliesToClasses <String[]>] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Description <String>] [-DisplayName] <String> [-Enabled
  <Boolean>] [-ID <String>] [-Instance <ADClaimType>] [-IsSingleValued <Boolean>]
  [-OtherAttributes <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>]
  [-RestrictValues <Boolean>] [-Server <String>] [-SourceTransformPolicy] [-SuggestedValues
  <ADSuggestedValueEntry[]>] -ValueType <ADClaimValueType> [<CommonParameters>]
options:
  -AppliesToClasses String[]: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -Enabled Boolean: ~
  -ID String: ~
  -Instance ADClaimType: ~
  -IsSingleValued Boolean: ~
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -RestrictValues Boolean: ~
  -Server String: ~
  -SourceAttribute String:
    required: true
  -SourceOID String:
    required: true
  -SourceTransformPolicy Switch:
    required: true
  -SuggestedValues ADSuggestedValueEntry[]: ~
  -ValueType ADClaimValueType:
    required: true
    values:
    - Invalid
    - Int64
    - UInt64
    - String
    - FQBN
    - SID
    - Boolean
    - OctetString
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
