description: Grants access to a file share
synopses:
- Grant-FileShareAccess -Name <String[]> [-FileServer <CimInstance>] -AccountName
  <String[]> -AccessRight <AccessRight> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Grant-FileShareAccess -UniqueId <String[]> -AccountName <String[]> -AccessRight
  <AccessRight> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Grant-FileShareAccess -InputObject <CimInstance[]> -AccountName <String[]> -AccessRight
  <AccessRight> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessRight AccessRight:
    required: true
    values:
    - Full
    - Modify
    - Read
    - Custom
  -AccountName String[]:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -FileServer CimInstance: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
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
