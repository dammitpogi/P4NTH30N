description: Removes a global web content object
synopses:
- Remove-AdfsGlobalWebContent [[-Locale] <CultureInfo>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsGlobalWebContent [-TargetWebContent] <AdfsGlobalWebContent> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Locale CultureInfo: ~
  -TargetWebContent AdfsGlobalWebContent:
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
