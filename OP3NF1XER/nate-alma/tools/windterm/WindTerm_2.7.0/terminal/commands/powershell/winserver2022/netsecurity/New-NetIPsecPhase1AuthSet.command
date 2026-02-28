description: Creates a phase 1 authentication set that specifies the methods offered
  for main mode first authentication during IPsec negotiations
synopses:
- New-NetIPsecPhase1AuthSet [-PolicyStore <String>] [-GPOSession <String>] [-Name
  <String>] -DisplayName <String> [-Description <String>] [-Group <String>] -Proposal
  <CimInstance[]> [-Default] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Default Switch: ~
  -Description String: ~
  -DisplayName String:
    required: true
  -GPOSession String: ~
  -Group String: ~
  -Name,-ID String: ~
  -PolicyStore String: ~
  -Proposal CimInstance[]:
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
