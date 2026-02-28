description: Creates a resource property in Active Directory
synopses:
- New-ADResourceProperty [-WhatIf] [-Confirm] [-AppliesToResourceTypes <String[]>]
  [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Description <String>] [-DisplayName]
  <String> [-Enabled <Boolean>] [-ID <String>] [-Instance <ADResourceProperty>] [-IsSecured
  <Boolean>] [-OtherAttributes <Hashtable>] [-PassThru] [-ProtectedFromAccidentalDeletion
  <Boolean>] -ResourcePropertyValueType <ADResourcePropertyValueType> [-Server <String>]
  [-SharesValuesWith <ADClaimType>] [-SuggestedValues <ADSuggestedValueEntry[]>] [<CommonParameters>]
options:
  -AppliesToResourceTypes String[]: ~
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
  -Instance ADResourceProperty: ~
  -IsSecured Boolean: ~
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -ResourcePropertyValueType ADResourcePropertyValueType:
    required: true
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
