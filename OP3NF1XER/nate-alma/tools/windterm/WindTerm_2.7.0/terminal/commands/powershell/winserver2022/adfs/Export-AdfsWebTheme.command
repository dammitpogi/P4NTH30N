description: Exports a web theme to a folder
synopses:
- Export-AdfsWebTheme -Name <String> -DirectoryPath <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Export-AdfsWebTheme -RelyingPartyName <String> -DirectoryPath <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Export-AdfsWebTheme -WebTheme <WebThemeBase> -DirectoryPath <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -DirectoryPath String:
    required: true
  -Name String:
    required: true
  -RelyingPartyName String:
    required: true
  -WebTheme WebThemeBase:
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
