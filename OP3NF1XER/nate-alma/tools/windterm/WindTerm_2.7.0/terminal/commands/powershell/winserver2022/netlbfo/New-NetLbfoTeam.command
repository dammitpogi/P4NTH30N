description: Creates a new NIC team
synopses:
- New-NetLbfoTeam [-Name] <String> [-TeamMembers] <WildcardPattern[]> [[-TeamNicName]
  <String>] [[-TeamingMode] <TeamingModes>] [[-LoadBalancingAlgorithm] <LBAlgos>]
  [[-LacpTimer] <LacpTimers>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
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
  -Name String:
    required: true
  -TeamMembers WildcardPattern[]:
    required: true
  -TeamNicName String: ~
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
