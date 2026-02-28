description: Grants permission to access shares that an NFS server exports
synopses:
- Grant-NfsSharePermission [-ClientName] <String> [-ClientType] <String> [[-Permission]
  <String>] [[-LanguageEncoding] <String>] [[-AllowRootAccess] <Boolean>] [-Name]
  <String> [-NetworkName <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Grant-NfsSharePermission [-Path] <String> [-ClientName] <String> [-ClientType] <String>
  [[-Permission] <String>] [[-LanguageEncoding] <String>] [[-AllowRootAccess] <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AllowRootAccess Boolean: ~
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
  -LanguageEncoding,-Lang,-Encoding String:
    values:
    - euc-jp
    - euc-tw
    - euc-kr
    - shift-jis
    - big5
    - ksc5601
    - gb2312-80
    - ansi
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
