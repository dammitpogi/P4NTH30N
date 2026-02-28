description: Exports the layout of the Start screen
synopses:
- Export-StartLayout [-Path] <String> [-UseDesktopApplicationID] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Export-StartLayout -LiteralPath <String> [-UseDesktopApplicationID] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -LiteralPath String:
    required: true
  -Path String:
    required: true
  -UseDesktopApplicationID Switch: ~
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
