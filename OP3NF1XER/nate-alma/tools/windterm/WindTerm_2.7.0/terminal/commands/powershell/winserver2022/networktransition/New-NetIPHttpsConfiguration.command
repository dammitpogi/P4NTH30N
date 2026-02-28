description: Creates an IP-HTTPS configuration
synopses:
- New-NetIPHttpsConfiguration [-PolicyStore] <String> [-Profile <String>] [-Type <Type>]
  -ServerURL <String> [-State <State>] [-AuthMode <AuthMode>] [-StrongCRLRequired
  <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-NetIPHttpsConfiguration [-Profile <String>] [-Type <Type>] -ServerURL <String>
  [-State <State>] [-AuthMode <AuthMode>] [-StrongCRLRequired <Boolean>] [-GPOSession]
  <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthMode AuthMode:
    values:
    - None
    - Certificates
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -GPOSession String:
    required: true
  -PolicyStore String:
    required: true
  -Profile,-IPHttpsProfile String: ~
  -ServerURL String:
    required: true
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
