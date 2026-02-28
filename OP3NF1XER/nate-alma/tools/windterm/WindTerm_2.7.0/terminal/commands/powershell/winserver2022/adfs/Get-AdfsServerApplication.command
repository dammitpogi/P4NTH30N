description: Gets configuration settings for a server application role for an application
  in AD FS
synopses:
- Get-AdfsServerApplication [[-Identifier] <String[]>] [<CommonParameters>]
- Get-AdfsServerApplication [-Name] <String[]> [<CommonParameters>]
- Get-AdfsServerApplication [-Application] <ServerApplication> [<CommonParameters>]
- Get-AdfsServerApplication [-ApplicationGroupIdentifier] <String> [<CommonParameters>]
- Get-AdfsServerApplication [-ApplicationGroup] <ApplicationGroup> [<CommonParameters>]
options:
  -Application ServerApplication:
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
