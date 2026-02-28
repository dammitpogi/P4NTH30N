description: Suspends (pauses) one or more running services
synopses:
- Suspend-Service [-InputObject] <ServiceController[]> [-PassThru] [-Include <String[]>]
  [-Exclude <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Suspend-Service [-Name] <String[]> [-PassThru] [-Include <String[]>] [-Exclude <String[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Suspend-Service [-PassThru] -DisplayName <String[]> [-Include <String[]>] [-Exclude
  <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -DisplayName System.String[]:
    required: true
  -Exclude System.String[]: ~
  -Include System.String[]: ~
  -InputObject System.ServiceProcess.ServiceController[]:
    required: true
  -Name,-ServiceName System.String[]:
    required: true
  -PassThru Switch: ~
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
