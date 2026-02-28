description: Runs validation tests for failover cluster hardware and settings
synopses:
- Test-Cluster [[-Node] <StringCollection>] [-Disk <Object[]>] [-Pool <Object[]>]
  [-ReportName <String>] [-List] [-Include <StringCollection>] [-Ignore <StringCollection>]
  [-Force] [-InputObject <PSObject>] [-Cluster <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -Disk Object[]: ~
  -Force Switch: ~
  -Ignore StringCollection: ~
  -Include StringCollection: ~
  -InputObject PSObject: ~
  -List Switch: ~
  -Node StringCollection: ~
  -Pool Object[]: ~
  -ReportName String: ~
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
