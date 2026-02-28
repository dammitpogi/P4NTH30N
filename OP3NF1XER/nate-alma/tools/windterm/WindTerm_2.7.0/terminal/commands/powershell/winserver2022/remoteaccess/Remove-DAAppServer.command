description: Removes the specified list of application server security groups (SGs)
  from the DirectAccess (DA) deployment, removes the specified application servers
  from the specified DA application server SG,and removes the application server Group
  Policy Objects (GPOs) in the specified domains
synopses:
- Remove-DAAppServer [-ComputerName <String>] [-PassThru] [-DomainName <String[]>]
  [-SecurityGroupNameList <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-DAAppServer [-SecurityGroupName] <String> [-Name] <String[]> [-ComputerName
  <String>] [-PassThru] [-DomainName <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DomainName String[]: ~
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
