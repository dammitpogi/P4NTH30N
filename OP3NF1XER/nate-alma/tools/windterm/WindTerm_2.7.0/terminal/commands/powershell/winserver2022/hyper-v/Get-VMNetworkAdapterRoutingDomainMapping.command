description: Gets members of a routing domain
synopses:
- Get-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID <Guid>] [-RoutingDomainName
  <String>] [[-VMName] <String[]>] [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID <Guid>] [-RoutingDomainName
  <String>] [-VMSnapshot] <VMSnapshot> [<CommonParameters>]
- Get-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID <Guid>] [-RoutingDomainName
  <String>] [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [<CommonParameters>]
- Get-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID <Guid>] [-RoutingDomainName
  <String>] [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [<CommonParameters>]
- Get-VMNetworkAdapterRoutingDomainMapping [-RoutingDomainID <Guid>] [-RoutingDomainName
  <String>] [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]> [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
  -RoutingDomainID Guid: ~
  -RoutingDomainName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]: ~
  -VMNetworkAdapter VMNetworkAdapterBase[]:
    required: true
  -VMNetworkAdapterName String: ~
  -VMSnapshot,-VMCheckpoint VMSnapshot:
    required: true
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
