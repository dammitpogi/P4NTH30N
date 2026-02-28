description: ''
synopses:
- Set-VMNetworkAdapterTeamMapping [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String> [-VMNetworkAdapterName <String>]
  -PhysicalNetAdapterName <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterTeamMapping [-ManagementOS] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-VMNetworkAdapterName <String>] [-SwitchName
  <String>] -PhysicalNetAdapterName <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterTeamMapping [-VMNetworkAdapter] <VMNetworkAdapterBase> -PhysicalNetAdapterName
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterTeamMapping [-VM] <VirtualMachine> [-VMNetworkAdapterName <String>]
  -PhysicalNetAdapterName <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
  -PhysicalNetAdapterName String:
    required: true
  -SwitchName String: ~
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase:
    required: true
  -VMNetworkAdapterName String: ~
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
