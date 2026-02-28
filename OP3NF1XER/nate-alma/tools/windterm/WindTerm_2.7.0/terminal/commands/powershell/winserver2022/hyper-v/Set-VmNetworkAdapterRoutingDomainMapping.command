description: Sets virtual subnets on a routing domain
synopses:
- Set-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName]
  <String[]> [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-NewRoutingDomainName
  <String>] [-IsolationID <Int32[]>] [-IsolationName <String[]>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapter] <VMNetworkAdapterBase[]>
  [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-NewRoutingDomainName <String>]
  [-IsolationID <Int32[]>] [-IsolationName <String[]>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-VMNetworkAdapterRoutingDomainMapping [-ManagementOS] [-VMNetworkAdapterName
  <String>] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-NewRoutingDomainName <String>]
  [-IsolationID <Int32[]>] [-IsolationName <String[]>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapterName <String>] [-VM]
  <VirtualMachine[]> [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-NewRoutingDomainName
  <String>] [-IsolationID <Int32[]>] [-IsolationName <String[]>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterRoutingDomainMapping [-InputObject] <VMNetworkAdapterRoutingDomainSetting>
  [-NewRoutingDomainName <String>] [-IsolationID <Int32[]>] [-IsolationName <String[]>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -InputObject VMNetworkAdapterRoutingDomainSetting:
    required: true
  -IsolationID Int32[]: ~
  -IsolationName String[]: ~
  -ManagementOS Switch:
    required: true
  -NewRoutingDomainName String: ~
  -Passthru Switch: ~
  -RoutingDomainID Guid: ~
  -RoutingDomainName String: ~
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
