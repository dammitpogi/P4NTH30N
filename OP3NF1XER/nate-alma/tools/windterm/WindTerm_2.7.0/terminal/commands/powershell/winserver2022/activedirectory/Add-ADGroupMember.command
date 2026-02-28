description: Adds one or more members to an Active Directory group
synopses:
- Add-ADGroupMember [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Identity] <ADGroup> [-Members] <ADPrincipal[]> [-MemberTimeToLive <TimeSpan>]
  [-Partition <String>] [-PassThru] [-Server <String>] [-DisablePermissiveModify]
  [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DisablePermissiveModify Switch: ~
  -Identity ADGroup:
    required: true
  -MemberTimeToLive TimeSpan: ~
  -Members ADPrincipal[]:
    required: true
  -Partition String: ~
  -PassThru Switch: ~
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
