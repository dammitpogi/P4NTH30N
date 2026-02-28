description: Revokes permission to access shares that an NFS server exports
synopses:
- Revoke-NfsSharePermission [-ClientName] <String> [-ClientType] <String> [-Name]
  <String> [-NetworkName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Revoke-NfsSharePermission [-Path] <String> [-ClientName] <String> [-ClientType]
  <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientName,-Client String:
    required: true
  -ClientType,-Type String:
    required: true
    values:
    - host
    - netgroup
    - clientgroup
    - builtin
  -Confirm,-cf Switch: ~
  -Name,-ShareName String:
    required: true
  -NetworkName,-netname String: ~
  -Path,-SharePath String:
    required: true
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
