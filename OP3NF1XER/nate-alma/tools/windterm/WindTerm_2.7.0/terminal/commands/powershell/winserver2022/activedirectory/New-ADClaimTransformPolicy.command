description: Creates a new claim transformation policy object in Active Directory
synopses:
- New-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-AllowAll] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Description <String>] [-Name] <String> [-PassThru]
  [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>] [<CommonParameters>]
- New-ADClaimTransformPolicy [-WhatIf] [-Confirm] -AllowAllExcept <ADClaimType[]>
  [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Description <String>] [-Name]
  <String> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>]
  [<CommonParameters>]
- New-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-DenyAll] [-Description <String>] [-Name] <String> [-PassThru]
  [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>] [<CommonParameters>]
- New-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] -DenyAllExcept <ADClaimType[]> [-Description <String>] [-Name] <String>
  [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] [-Server <String>] [<CommonParameters>]
- New-ADClaimTransformPolicy [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-Description <String>] [-Instance <ADClaimTransformPolicy>] [-Name]
  <String> [-PassThru] [-ProtectedFromAccidentalDeletion <Boolean>] -Rule <String>
  [-Server <String>] [<CommonParameters>]
options:
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
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DenyAll Switch:
    required: true
    values:
    - 'true'
  -DenyAllExcept ADClaimType[]:
    required: true
  -Description String: ~
  -Instance ADClaimTransformPolicy: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
  -Rule String:
    required: true
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
