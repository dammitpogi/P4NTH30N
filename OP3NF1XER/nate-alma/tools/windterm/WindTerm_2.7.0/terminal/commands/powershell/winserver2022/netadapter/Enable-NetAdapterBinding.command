description: Enables binding of a protocol or filter to a network adapter
synopses:
- Enable-NetAdapterBinding [-Name] <String[]> [-ComponentID <String[]>] [-DisplayName
  <String[]>] [-IncludeHidden] [-AllBindings] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-NetAdapterBinding -InterfaceDescription <String[]> [-ComponentID <String[]>]
  [-DisplayName <String[]>] [-IncludeHidden] [-AllBindings] [-PassThru] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-NetAdapterBinding -InputObject <CimInstance[]> [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllBindings Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComponentID String[]: ~
  -Confirm,-cf Switch: ~
  -DisplayName String[]: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -PassThru Switch: ~
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
