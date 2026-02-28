description: Grants application permission
synopses:
- Grant-AdfsApplicationPermission [-ClientRoleIdentifier] <String> [-ServerRoleIdentifier]
  <String> [[-ScopeNames] <String[]>] [-Description <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Grant-AdfsApplicationPermission [-AllowAllRegisteredClients] [-ServerRoleIdentifier]
  <String> [[-ScopeNames] <String[]>] [-Description <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowAllRegisteredClients Switch:
    required: true
    values:
    - 'true'
  -ClientRoleIdentifier String:
    required: true
  -Description String: ~
  -PassThru Switch: ~
  -ScopeNames String[]: ~
  -ServerRoleIdentifier String:
    required: true
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
