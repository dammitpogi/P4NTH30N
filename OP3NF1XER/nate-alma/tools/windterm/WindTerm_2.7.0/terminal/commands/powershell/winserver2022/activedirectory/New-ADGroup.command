description: Creates an Active Directory group
synopses:
- New-ADGroup [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Description <String>] [-DisplayName <String>] [-GroupCategory <ADGroupCategory>]
  [-GroupScope] <ADGroupScope> [-HomePage <String>] [-Instance <ADGroup>] [-ManagedBy
  <ADPrincipal>] [-Name] <String> [-OtherAttributes <Hashtable>] [-PassThru] [-Path
  <String>] [-SamAccountName <String>] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -GroupCategory ADGroupCategory:
    values:
    - Distribution
    - Security
  -GroupScope ADGroupScope:
    required: true
    values:
    - DomainLocal
    - Global
    - Universal
  -HomePage String: ~
  -Instance ADGroup: ~
  -ManagedBy ADPrincipal: ~
  -Name String:
    required: true
  -OtherAttributes Hashtable: ~
  -PassThru Switch: ~
  -Path String: ~
  -SamAccountName String: ~
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
