description: Modifies configuration settings for a server native client application
  role of an application in AD FS
synopses:
- Set-AdfsNativeClientApplication [-TargetIdentifier] <String> [-Identifier <String>]
  [-Name <String>] [-RedirectUri <String[]>] [-Description <String>] [-LogoutUri <String>]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsNativeClientApplication [-TargetName] <String> [-Identifier <String>] [-Name
  <String>] [-RedirectUri <String[]>] [-Description <String>] [-LogoutUri <String>]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsNativeClientApplication [-TargetApplication] <NativeClientApplication> [-Identifier
  <String>] [-Name <String>] [-RedirectUri <String[]>] [-Description <String>] [-LogoutUri
  <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Description String: ~
  -Identifier String: ~
  -LogoutUri String: ~
  -Name String: ~
  -PassThru Switch: ~
  -RedirectUri String[]: ~
  -TargetApplication NativeClientApplication:
    required: true
  -TargetIdentifier String:
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
