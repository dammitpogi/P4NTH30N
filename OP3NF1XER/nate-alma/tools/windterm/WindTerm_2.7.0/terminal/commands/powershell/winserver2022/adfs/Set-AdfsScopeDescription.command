description: Modifies a scope description in AD FS
synopses:
- Set-AdfsScopeDescription [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsScopeDescription [-Description <String>] [-TargetName] <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsScopeDescription [-Description <String>] [-InputObject] <OAuthScopeDescription>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description String: ~
  -InputObject OAuthScopeDescription:
    required: true
  -TargetName String:
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
