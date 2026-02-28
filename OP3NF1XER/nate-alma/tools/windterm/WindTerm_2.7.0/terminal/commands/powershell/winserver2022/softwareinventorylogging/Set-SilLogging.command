description: Applies configuration settings for Software Inventory Logging
synopses:
- Set-SilLogging -TimeOfDay <DateTime> [-CimSession <CimSession[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-SilLogging [-TimeOfDay <DateTime>] [-TargetUri <String>] [-CertificateThumbprint
  <String>] [-CimSession <CimSession[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -CimSession CimSession[]: ~
  -Confirm,-cf Switch: ~
  -TargetUri String: ~
  -TimeOfDay DateTime:
    required: true
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
