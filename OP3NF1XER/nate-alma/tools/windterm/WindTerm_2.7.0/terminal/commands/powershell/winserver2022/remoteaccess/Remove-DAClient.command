description: Removes one or more client computer security groups (SGs) from the DirectAccess
  (DA) deployment, removes one or more DA client Group Policy Objects (GPOs) from
  domains, removes one or more SGs of down-level clients (down-level clients can connect
  only to the specified site) from the DA deployment in a multi-site deployment, and
  removes one or more down-level DA client GPOs from domains in a multi-site deployment
synopses:
- Remove-DAClient [-ComputerName <String>] [-PassThru] [-SecurityGroupNameList <String[]>]
  [-DomainName <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-DAClient [-ComputerName <String>] [-PassThru] [-DownlevelSecurityGroupNameList
  <String[]>] [-EntrypointName <String>] [-DownlevelDomainName <String[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DomainName String[]: ~
  -DownlevelDomainName String[]: ~
  -DownlevelSecurityGroupNameList String[]: ~
  -EntrypointName String: ~
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
