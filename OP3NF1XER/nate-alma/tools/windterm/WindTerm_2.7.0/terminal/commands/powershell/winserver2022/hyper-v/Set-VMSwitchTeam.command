description: Configures a virtual switch team
synopses:
- Set-VMSwitchTeam [-ComputerName <String[]>] [-Name] <String[]> [-NetAdapterName
  <String[]>] [-TeamingMode <VMSwitchTeamingMode>] [-LoadBalancingAlgorithm <VMSwitchLoadBalancingAlgorithm>]
  [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMSwitchTeam [-ComputerName <String[]>] [-Name] <String[]> [-NetAdapterInterfaceDescription
  <String[]>] [-TeamingMode <VMSwitchTeamingMode>] [-LoadBalancingAlgorithm <VMSwitchLoadBalancingAlgorithm>]
  [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMSwitchTeam [-ComputerName <String[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterInterfaceDescription
  <String[]>] [-TeamingMode <VMSwitchTeamingMode>] [-LoadBalancingAlgorithm <VMSwitchLoadBalancingAlgorithm>]
  [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMSwitchTeam [-ComputerName <String[]>] [-VMSwitch] <VMSwitch[]> [-NetAdapterName
  <String[]>] [-TeamingMode <VMSwitchTeamingMode>] [-LoadBalancingAlgorithm <VMSwitchLoadBalancingAlgorithm>]
  [-Passthru] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -LoadBalancingAlgorithm VMSwitchLoadBalancingAlgorithm:
    values:
    - HyperVPort
    - Dynamic
  -Name,-SwitchName String[]:
    required: true
  -NetAdapterInterfaceDescription String[]: ~
  -NetAdapterName,-InterfaceAlias String[]: ~
  -Passthru Switch: ~
  -TeamingMode VMSwitchTeamingMode:
    values:
    - SwitchIndependent
  -VMSwitch VMSwitch[]:
    required: true
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
