description: Removes a routing domain from a virtual network adapter
synopses:
- Remove-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName]
  <String[]> [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapter] <VMNetworkAdapterBase[]>
  [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-VMNetworkAdapterRoutingDomainMapping [-ManagementOS] [-VMNetworkAdapterName
  <String>] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-Passthru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-VMNetworkAdapterRoutingDomainMapping [-VMNetworkAdapterName <String>] [-VM]
  <VirtualMachine[]> [-RoutingDomainID <Guid>] [-RoutingDomainName <String>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterRoutingDomainMapping [-InputObject] <VMNetworkAdapterRoutingDomainSetting[]>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -InputObject VMNetworkAdapterRoutingDomainSetting[]:
    required: true
  -ManagementOS Switch:
    required: true
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
