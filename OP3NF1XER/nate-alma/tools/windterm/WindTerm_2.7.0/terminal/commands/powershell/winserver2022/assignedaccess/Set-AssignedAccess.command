description: Configures a user to launch only one app
synopses:
- Set-AssignedAccess -UserName <String> -AppName <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AssignedAccess -UserName <String> -AppUserModelId <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-AssignedAccess -UserSID <String> -AppUserModelId <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-AssignedAccess -UserSID <String> -AppName <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AppName String:
    required: true
  -AppUserModelId,-AUMID String:
    required: true
  -Confirm,-cf Switch: ~
  -UserName String:
    required: true
  -UserSID String:
    required: true
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
