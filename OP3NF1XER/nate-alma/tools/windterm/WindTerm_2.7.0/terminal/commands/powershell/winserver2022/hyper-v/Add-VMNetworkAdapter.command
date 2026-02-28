description: Adds a virtual network adapter to a virtual machine
synopses:
- Add-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-SwitchName <String>] [-IsLegacy <Boolean>]
  [-Name <String>] [-DynamicMacAddress] [-StaticMacAddress <String>] [-Passthru] [-ResourcePoolName
  <String>] [-DeviceNaming <OnOffState>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-ManagementOS] [-SwitchName <String>] [-Name <String>] [-DynamicMacAddress]
  [-StaticMacAddress <String>] [-Passthru] [-DeviceNaming <OnOffState>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapter [-SwitchName <String>] [-IsLegacy <Boolean>] [-Name <String>]
  [-DynamicMacAddress] [-StaticMacAddress <String>] [-Passthru] [-ResourcePoolName
  <String>] [-VM] <VirtualMachine[]> [-DeviceNaming <OnOffState>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DeviceNaming OnOffState:
    values:
    - On
    - Off
  -DynamicMacAddress Switch: ~
  -IsLegacy Boolean: ~
  -ManagementOS Switch: ~
  -Name,-VMNetworkAdapterName String: ~
  -Passthru Switch: ~
  -ResourcePoolName String: ~
  -StaticMacAddress String: ~
  -SwitchName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
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
