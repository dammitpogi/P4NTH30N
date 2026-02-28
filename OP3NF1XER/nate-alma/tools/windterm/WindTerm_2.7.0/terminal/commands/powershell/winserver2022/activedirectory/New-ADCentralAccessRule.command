description: Creates a central access rule in Active Directory
synopses:
- New-ADCentralAccessRule [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential
  <PSCredential>] [-CurrentAcl <String>] [-Description <String>] [-Instance <ADCentralAccessRule>]
  [-Name] <String> [-PassThru] [-ProposedAcl <String>] [-ProtectedFromAccidentalDeletion
  <Boolean>] [-ResourceCondition <String>] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -CurrentAcl String: ~
  -Description String: ~
  -Instance ADCentralAccessRule: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProposedAcl String: ~
  -ProtectedFromAccidentalDeletion Boolean: ~
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
