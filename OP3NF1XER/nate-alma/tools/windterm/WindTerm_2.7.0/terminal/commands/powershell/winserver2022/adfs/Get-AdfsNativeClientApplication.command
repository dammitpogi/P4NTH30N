description: Gets native client application roles from an application in AD FS
synopses:
- Get-AdfsNativeClientApplication [[-Identifier] <String[]>] [<CommonParameters>]
- Get-AdfsNativeClientApplication [-Name] <String[]> [<CommonParameters>]
- Get-AdfsNativeClientApplication [-Application] <NativeClientApplication> [<CommonParameters>]
- Get-AdfsNativeClientApplication [-ApplicationGroupIdentifier] <String> [<CommonParameters>]
- Get-AdfsNativeClientApplication [-ApplicationGroup] <ApplicationGroup> [<CommonParameters>]
options:
  -Application NativeClientApplication:
    required: true
  -ApplicationGroup ApplicationGroup:
    required: true
  -ApplicationGroupIdentifier String:
    required: true
  -Identifier String[]: ~
  -Name String[]:
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
