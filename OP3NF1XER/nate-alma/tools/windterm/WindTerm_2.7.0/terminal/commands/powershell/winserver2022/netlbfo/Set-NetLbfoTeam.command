description: Sets parameters on the specified NIC team
synopses:
- Set-NetLbfoTeam [[-Name] <String[]>] [-TeamingMode <TeamingModes>] [-LoadBalancingAlgorithm
  <LBAlgos>] [-LacpTimer <LacpTimers>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetLbfoTeam [-MemberOfTheTeam <CimInstance>] [-TeamingMode <TeamingModes>] [-LoadBalancingAlgorithm
  <LBAlgos>] [-LacpTimer <LacpTimers>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetLbfoTeam [-TeamNicForTheTeam <CimInstance>] [-TeamingMode <TeamingModes>]
  [-LoadBalancingAlgorithm <LBAlgos>] [-LacpTimer <LacpTimers>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetLbfoTeam -InputObject <CimInstance[]> [-TeamingMode <TeamingModes>] [-LoadBalancingAlgorithm
  <LBAlgos>] [-LacpTimer <LacpTimers>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -LacpTimer,-lt LacpTimers:
    values:
    - Slow
    - Fast
  -LoadBalancingAlgorithm,-lba LBAlgos:
    values:
    - TransportPorts
    - IPAddresses
    - MacAddresses
    - HyperVPort
    - Dynamic
  -MemberOfTheTeam CimInstance: ~
  -Name String[]: ~
  -PassThru Switch: ~
  -TeamNicForTheTeam CimInstance: ~
  -TeamingMode,-tm TeamingModes:
    values:
    - Static
    - SwitchIndependent
    - Lacp
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
