description: Modifies application permissions
synopses:
- Set-AdfsApplicationPermission [-TargetIdentifier] <String> [-ScopeNames <String[]>]
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [-TargetIdentifier] <String> -AddScope <String[]>
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [-TargetIdentifier] <String> -RemoveScope <String[]>
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [-InputObject] <OAuthPermission> [-ScopeNames <String[]>]
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [-InputObject] <OAuthPermission> -AddScope <String[]>
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [-InputObject] <OAuthPermission> -RemoveScope <String[]>
  [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [[-TargetClientRoleIdentifier] <String>] [[-TargetServerRoleIdentifier]
  <String>] [-ScopeNames <String[]>] [-Description <String>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-AdfsApplicationPermission [[-TargetClientRoleIdentifier] <String>] [[-TargetServerRoleIdentifier]
  <String>] -AddScope <String[]> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationPermission [[-TargetClientRoleIdentifier] <String>] [[-TargetServerRoleIdentifier]
  <String>] -RemoveScope <String[]> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddScope String[]:
    required: true
  -Description String: ~
  -InputObject OAuthPermission:
    required: true
  -RemoveScope String[]:
    required: true
  -ScopeNames String[]: ~
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
