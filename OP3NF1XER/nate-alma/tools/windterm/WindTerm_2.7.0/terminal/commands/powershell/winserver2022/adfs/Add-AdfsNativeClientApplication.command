description: Adds a native client application role to an application in AD FS
synopses:
- Add-AdfsNativeClientApplication [-ApplicationGroupIdentifier] <String> [-Name] <String>
  [-Identifier] <String> [[-RedirectUri] <String[]>] [-Description <String>] [-LogoutUri
  <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsNativeClientApplication [-ApplicationGroup] <ApplicationGroup> [-Name] <String>
  [-Identifier] <String> [[-RedirectUri] <String[]>] [-Description <String>] [-LogoutUri
  <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ApplicationGroup ApplicationGroup:
    required: true
  -ApplicationGroupIdentifier String:
    required: true
  -Description String: ~
  -Identifier String:
    required: true
  -LogoutUri String: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -RedirectUri String[]: ~
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
