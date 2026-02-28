description: Exports one or more Updating Run reports into an HTML or CSV-formatted
  document
synopses:
- Export-CauReport [-InputReport] <CauReport[]> [-Format] <OutputType> [-Path] <String>
  [-PassThru] [-Force] [-TimeZone <TimeZoneInfo>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -Format OutputType:
    required: true
    values:
    - Csv
    - Html
  -InputReport CauReport[]:
    required: true
  -PassThru Switch: ~
  -Path String:
    required: true
  -TimeZone TimeZoneInfo: ~
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
