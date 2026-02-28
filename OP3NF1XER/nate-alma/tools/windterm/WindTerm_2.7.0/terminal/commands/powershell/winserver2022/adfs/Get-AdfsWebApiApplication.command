description: Gets Web API application roles in AD FS
synopses:
- Get-AdfsWebApiApplication [[-Identifier] <String[]>] [<CommonParameters>]
- Get-AdfsWebApiApplication [-Name] <String[]> [<CommonParameters>]
- Get-AdfsWebApiApplication [-PrefixIdentifier] <String> [<CommonParameters>]
- Get-AdfsWebApiApplication [-Application] <WebApiApplication> [<CommonParameters>]
- Get-AdfsWebApiApplication [-ApplicationGroupIdentifier] <String> [<CommonParameters>]
- Get-AdfsWebApiApplication [-ApplicationGroup] <ApplicationGroup> [<CommonParameters>]
options:
  -Application WebApiApplication:
    required: true
  -ApplicationGroup ApplicationGroup:
    required: true
  -ApplicationGroupIdentifier String:
    required: true
  -Identifier String[]: ~
  -Name String[]:
    required: true
  -PrefixIdentifier String:
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
