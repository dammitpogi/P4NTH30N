description: Adds users, computers, and groups to the allowed or denied list of a
  read-only domain controller password replication policy
synopses:
- Add-ADDomainControllerPasswordReplicationPolicy [-WhatIf] [-Confirm] -AllowedList
  <ADPrincipal[]> [-AuthType <ADAuthType>] [-Credential <PSCredential>] [[-Identity]
  <ADDomainController>] [-Server <String>] [<CommonParameters>]
- Add-ADDomainControllerPasswordReplicationPolicy [-WhatIf] [-Confirm] [-AuthType
  <ADAuthType>] [-Credential <PSCredential>] -DeniedList <ADPrincipal[]> [[-Identity]
  <ADDomainController>] [-Server <String>] [<CommonParameters>]
options:
  -AllowedList ADPrincipal[]:
    required: true
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DeniedList ADPrincipal[]:
    required: true
  -Identity ADDomainController: ~
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
