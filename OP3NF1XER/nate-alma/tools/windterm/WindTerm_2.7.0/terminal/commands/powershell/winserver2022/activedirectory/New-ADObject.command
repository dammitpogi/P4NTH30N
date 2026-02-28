description: Creates an Active Directory object
synopses:
- New-ADObject [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-Instance <ADObject>] [-Name] <String>
  [-OtherAttributes <Hashtable>] [-PassThru] [-Path <String>] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-Server <String>] [-Type] <String> [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -Instance ADObject: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -Path String: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Server String: ~
  -Type String:
    required: true
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
