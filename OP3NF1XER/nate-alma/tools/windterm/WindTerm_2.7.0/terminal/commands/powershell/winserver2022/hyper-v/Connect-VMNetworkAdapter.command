description: Connects a virtual network adapter to a virtual switch
synopses:
- Connect-VMNetworkAdapter [[-Name] <String[]>] [-SwitchName] <String> [-Passthru]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-VMName] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapter[]> [-SwitchName]
  <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapter[]> [-VMSwitch] <VMSwitch>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-VMNetworkAdapter [-VMNetworkAdapter] <VMNetworkAdapter[]> [-UseAutomaticConnection]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-VMNetworkAdapter [[-Name] <String[]>] [-VMSwitch] <VMSwitch> [-Passthru]
  [-VMName] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Connect-VMNetworkAdapter [[-Name] <String[]>] [-UseAutomaticConnection] [-Passthru]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-VMName] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name,-VMNetworkAdapterName String[]: ~
  -Passthru Switch: ~
  -SwitchName String:
    required: true
  -UseAutomaticConnection Switch:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapter[]:
    required: true
  -VMSwitch VMSwitch:
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
