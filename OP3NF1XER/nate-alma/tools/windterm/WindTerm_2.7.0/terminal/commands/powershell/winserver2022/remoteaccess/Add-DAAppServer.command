description: Adds a new application server security group to the DirectAccess (DA)
  deployment, adds an application servers to an application server security group
  that is already part of the DirectAccess deployment, and adds or updates application
  server Group Policy Object (GPO) in a domain
synopses:
- Add-DAAppServer [-SecurityGroupNameList <String[]>] [-GpoName <String[]>] [-ComputerName
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DAAppServer [-GpoName <String[]>] [-ComputerName <String>] [-PassThru] [-SecurityGroupName]
  <String> [-Name] <String[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -GpoName String[]: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -SecurityGroupName String:
    required: true
  -SecurityGroupNameList String[]: ~
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
