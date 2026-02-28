description: Modifies an Active Directory group
synopses:
- Set-ADGroup [-WhatIf] [-Confirm] [-Add <Hashtable>] [-AuthType <ADAuthType>] [-Clear
  <String[]>] [-Credential <PSCredential>] [-Description <String>] [-DisplayName <String>]
  [-GroupCategory <ADGroupCategory>] [-GroupScope <ADGroupScope>] [-HomePage <String>]
  [-Identity] <ADGroup> [-ManagedBy <ADPrincipal>] [-Partition <String>] [-PassThru]
  [-Remove <Hashtable>] [-Replace <Hashtable>] [-SamAccountName <String>] [-Server
  <String>] [<CommonParameters>]
- Set-ADGroup [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Instance <ADGroup> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -Add Hashtable: ~
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Clear String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Description String: ~
  -DisplayName String: ~
  -GroupCategory ADGroupCategory:
    values:
    - Distribution
    - Security
  -GroupScope ADGroupScope:
    values:
    - DomainLocal
    - Global
    - Universal
  -HomePage String: ~
  -Identity ADGroup:
    required: true
  -Instance ADGroup:
    required: true
  -ManagedBy ADPrincipal: ~
  -Partition String: ~
  -PassThru Switch: ~
  -Remove Hashtable: ~
  -Replace Hashtable: ~
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
