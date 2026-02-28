description: Stops one or more running services
synopses:
- Stop-Service [-Force] [-NoWait] [-InputObject] <ServiceController[]> [-PassThru]
  [-Include <String[]>] [-Exclude <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Stop-Service [-Force] [-NoWait] [-Name] <String[]> [-PassThru] [-Include <String[]>]
  [-Exclude <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Stop-Service [-Force] [-NoWait] [-PassThru] -DisplayName <String[]> [-Include <String[]>]
  [-Exclude <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -DisplayName System.String[]:
    required: true
  -Exclude System.String[]: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -InputObject System.ServiceProcess.ServiceController[]:
    required: true
  -Name,-ServiceName System.String[]:
    required: true
  -NoWait Switch: ~
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
