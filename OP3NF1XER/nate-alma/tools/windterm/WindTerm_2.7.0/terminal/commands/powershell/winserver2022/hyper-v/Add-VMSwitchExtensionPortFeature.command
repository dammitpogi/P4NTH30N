description: Adds a feature to a virtual network adapter
synopses:
- Add-VMSwitchExtensionPortFeature [-VMName] <String[]> [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  -VMSwitchExtensionFeature <VMSwitchExtensionPortFeature[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMSwitchExtensionPortFeature [-VMNetworkAdapter] <VMNetworkAdapterBase[]> -VMSwitchExtensionFeature
  <VMSwitchExtensionPortFeature[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMSwitchExtensionPortFeature [-ManagementOS] [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  -VMSwitchExtensionFeature <VMSwitchExtensionPortFeature[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMSwitchExtensionPortFeature [-ExternalPort] [-SwitchName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] -VMSwitchExtensionFeature
  <VMSwitchExtensionPortFeature[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMSwitchExtensionPortFeature [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  -VMSwitchExtensionFeature <VMSwitchExtensionPortFeature[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ExternalPort Switch:
    required: true
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
  -SwitchName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
    required: true
  -VMNetworkAdapterName String: ~
  -VMSwitchExtensionFeature VMSwitchExtensionPortFeature[]:
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
