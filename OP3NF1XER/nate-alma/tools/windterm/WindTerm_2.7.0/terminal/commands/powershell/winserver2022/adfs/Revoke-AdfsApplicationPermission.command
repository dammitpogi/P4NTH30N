description: Revokes permission for an application
synopses:
- Revoke-AdfsApplicationPermission [-TargetIdentifier] <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Revoke-AdfsApplicationPermission [[-TargetClientRoleIdentifier] <String>] [[-TargetServerRoleIdentifier]
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Revoke-AdfsApplicationPermission [-InputObject] <OAuthPermission> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -InputObject OAuthPermission:
    required: true
  -TargetClientRoleIdentifier String: ~
  -TargetIdentifier String:
    required: true
  -TargetServerRoleIdentifier String: ~
  -Confirm,-cf Switch: ~
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
