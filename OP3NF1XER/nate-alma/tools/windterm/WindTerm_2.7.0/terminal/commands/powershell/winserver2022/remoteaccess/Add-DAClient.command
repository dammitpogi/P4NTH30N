description: Adds one or more client computer security groups (SGs) to the DirectAccess
  (DA) deployment, adds one or more DA client Group Policy Objects (GPOs) in one or
  more domains, adds one or more SGs of down-level clients to the DA deployment in
  a multi-site deployment, or adds one or more down-level DA client GPOs in one or
  more domains in a multi-site deployment
synopses:
- Add-DAClient [-ComputerName <String>] [-PassThru] [-SecurityGroupNameList <String[]>]
  [-GpoName <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DAClient [-DownlevelGpoName <String[]>] [-DownlevelSecurityGroupNameList <String[]>]
  [-EntrypointName <String>] [-ComputerName <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DownlevelGpoName,-DownlevelGpoNameList String[]: ~
  -DownlevelSecurityGroupNameList String[]: ~
  -EntrypointName String: ~
  -GpoName String[]: ~
  -PassThru Switch: ~
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
