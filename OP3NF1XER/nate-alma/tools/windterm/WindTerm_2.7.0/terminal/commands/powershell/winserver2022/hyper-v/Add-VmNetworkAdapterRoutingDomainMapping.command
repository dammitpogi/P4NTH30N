description: Adds a routing domain and virtual subnets to a virtual network adapter
synopses:
- Add-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID] <Guid> [-RoutingDomainName]
  <String> [-IsolationID] <Int32[]> [[-IsolationName] <String[]>] [-Passthru] [-VMNetworkAdapterName
  <String>] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-VMName] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID] <Guid> [-RoutingDomainName]
  <String> [-IsolationID] <Int32[]> [[-IsolationName] <String[]>] [-Passthru] [-VMNetworkAdapter]
  <VMNetworkAdapterBase[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID] <Guid> [-RoutingDomainName]
  <String> [-IsolationID] <Int32[]> [[-IsolationName] <String[]>] [-Passthru] [-ManagementOS]
  [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID] <Guid> [-RoutingDomainName]
  <String> [-IsolationID] <Int32[]> [[-IsolationName] <String[]>] [-Passthru] [-VMNetworkAdapterName
  <String>] [-VM] <VirtualMachine[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -IsolationID Int32[]:
    required: true
  -IsolationName String[]: ~
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
  -RoutingDomainID Guid:
    required: true
  -RoutingDomainName String:
    required: true
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
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
