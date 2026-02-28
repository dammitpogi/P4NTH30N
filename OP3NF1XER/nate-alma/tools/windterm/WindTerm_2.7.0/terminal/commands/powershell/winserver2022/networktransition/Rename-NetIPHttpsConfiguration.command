description: Renames an IP-HTTPS profile
synopses:
- Rename-NetIPHttpsConfiguration [-Profile <String[]>] [-ProfileActivated <Boolean[]>]
  [-PolicyStore <String>] -NewName <String> [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-NetIPHttpsConfiguration [-Profile <String[]>] [-ProfileActivated <Boolean[]>]
  [-GPOSession <String>] -NewName <String> [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Rename-NetIPHttpsConfiguration -InputObject <CimInstance[]> -NewName <String> [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
  -NewName String:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -Profile,-IPHttpsProfile String[]: ~
  -ProfileActivated Boolean[]: ~
  -ThrottleLimit Int32: ~
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
