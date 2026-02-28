description: Sets whether the WSUS server synchronizes from Microsoft Update or an
  upstream server
synopses:
- powershell Set-WsusServerSynchronization [-UpdateServer <IUpdateServer>] [-SyncFromMU]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Set-WsusServerSynchronization [-UpdateServer <IUpdateServer>] -UssServerName
  <String> [-PortNumber <Int32>] [-UseSsl] [-Replica] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -PortNumber Int32: ~
  -Replica Switch: ~
  -SyncFromMU Switch:
    required: true
  -UpdateServer IUpdateServer: ~
  -UseSsl Switch: ~
  -UssServerName String:
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
