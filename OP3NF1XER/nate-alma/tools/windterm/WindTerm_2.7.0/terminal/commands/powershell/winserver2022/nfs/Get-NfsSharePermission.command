description: Gets information about permissions that an NFS server grants to exported
  NFS shares
synopses:
- Get-NfsSharePermission [[-ClientName] <String>] [[-ClientType] <String>] [[-Permission]
  <String>] [-Name] <String> [-NetworkName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NfsSharePermission [-Path] <String> [[-ClientName] <String>] [[-ClientType]
  <String>] [[-Permission] <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientName,-Client String: ~
  -ClientType,-Type String:
    values:
    - host
    - netgroup
    - clientgroup
    - builtin
  -Name,-ShareName String:
    required: true
  -NetworkName,-netname String: ~
  -Path,-SharePath String:
    required: true
  -Permission,-Access String:
    values:
    - no-access
    - readonly
    - readwrite
  -ThrottleLimit Int32: ~
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
