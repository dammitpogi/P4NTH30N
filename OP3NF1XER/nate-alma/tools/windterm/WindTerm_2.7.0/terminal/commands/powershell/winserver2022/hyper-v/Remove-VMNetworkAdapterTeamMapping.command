description: ''
synopses:
- Remove-VMNetworkAdapterTeamMapping [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String> [-Name <String>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterTeamMapping [-ManagementOS] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-Name <String>] [-SwitchName
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterTeamMapping [-VMNetworkAdapter] <VMNetworkAdapterBase> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterTeamMapping [-VM] <VirtualMachine> [-Name <String>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
  -Name,-VMNetworkAdapterName String: ~
  -Passthru Switch: ~
  -SwitchName String: ~
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase:
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
