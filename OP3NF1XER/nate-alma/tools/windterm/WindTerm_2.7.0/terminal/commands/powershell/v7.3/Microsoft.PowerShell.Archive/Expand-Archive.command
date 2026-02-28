description: Extracts files from a specified archive (zipped) file
synopses:
- Expand-Archive [-Path] <String> [[-DestinationPath] <String>] [-Force] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Expand-Archive -LiteralPath <String> [[-DestinationPath] <String>] [-Force] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -DestinationPath System.String: ~
  -Force Switch: ~
  -LiteralPath,-PSPath System.String:
    required: true
  -PassThru Switch: ~
  -Path System.String:
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
