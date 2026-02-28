description: Modifies an IP-HTTPS configuration
synopses:
- Set-NetIPHttpsConfiguration [-Profile <String[]>] [-ProfileActivated <Boolean[]>]
  [-PolicyStore <String>] [-State <State>] [-Type <Type>] [-AuthMode <AuthMode>] [-StrongCRLRequired
  <Boolean>] [-ServerURL <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPHttpsConfiguration [-Profile <String[]>] [-ProfileActivated <Boolean[]>]
  [-GPOSession <String>] [-State <State>] [-Type <Type>] [-AuthMode <AuthMode>] [-StrongCRLRequired
  <Boolean>] [-ServerURL <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetIPHttpsConfiguration -InputObject <CimInstance[]> [-State <State>] [-Type
  <Type>] [-AuthMode <AuthMode>] [-StrongCRLRequired <Boolean>] [-ServerURL <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthMode AuthMode:
    values:
    - None
    - Certificates
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -PolicyStore String: ~
  -Profile,-IPHttpsProfile String[]: ~
  -ProfileActivated Boolean[]: ~
  -ServerURL String: ~
  -State State:
    values:
    - Default
    - Enabled
    - Disabled
    - OutsideEnabled
  -StrongCRLRequired Boolean: ~
  -ThrottleLimit Int32: ~
  -Type Type:
    values:
    - Client
    - Server
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
