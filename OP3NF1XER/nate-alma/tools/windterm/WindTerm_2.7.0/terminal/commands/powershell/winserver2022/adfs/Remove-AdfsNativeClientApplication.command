description: Removes a native client application role from an application in AD FS
synopses:
- Remove-AdfsNativeClientApplication [-TargetIdentifier] <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-AdfsNativeClientApplication [-TargetName] <String> [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-AdfsNativeClientApplication [-TargetApplication] <NativeClientApplication>
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
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
