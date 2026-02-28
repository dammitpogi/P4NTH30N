description: Removes an app package from one or more user accounts
synopses:
- Remove-AppxPackage [-Package] <String> [-PreserveApplicationData] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AppxPackage [-Package] <String> [-PreserveRoamableApplicationData] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-AppxPackage [-Package] <String> [-AllUsers] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AppxPackage [-Package] <String> -User <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllUsers Switch: ~
  -Confirm,-cf Switch: ~
  -Package String:
    required: true
  -WhatIf,-wi Switch: ~
  -PreserveApplicationData Switch: ~
  -PreserveRoamableApplicationData Switch: ~
  -User String:
    required: true
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
