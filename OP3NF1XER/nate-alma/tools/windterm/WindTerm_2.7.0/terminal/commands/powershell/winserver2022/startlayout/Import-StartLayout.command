description: Imports the layout of the Start into a mounted Windows image
synopses:
- Import-StartLayout [-LayoutPath] <String> [-MountPath] <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Import-StartLayout -LayoutLiteralPath <String> -MountLiteralPath <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -LayoutLiteralPath String:
    required: true
  -LayoutPath String:
    required: true
  -MountLiteralPath String:
    required: true
  -MountPath String:
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
