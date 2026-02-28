description: Configures properties for existing ODBC DSNs
synopses:
- Set-OdbcDsn [-PassThru] [-SetPropertyValue <String[]>] [-RemovePropertyValue <String[]>]
  [-InputObject] <CimInstance[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-OdbcDsn [-PassThru] [-SetPropertyValue <String[]>] [-RemovePropertyValue <String[]>]
  [-Name] <String> [-DriverName <String>] [-Platform <String>] -DsnType <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DriverName String: ~
  -DsnType String:
    required: true
    values:
    - User
    - System
    - All
  -InputObject,-Dsn CimInstance[]:
    required: true
  -Name,-DsnName String:
    required: true
  -PassThru Switch: ~
  -Platform String:
    values:
    - 32-bit
    - 64-bit
    - All
  -RemovePropertyValue String[]: ~
  -SetPropertyValue String[]: ~
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
