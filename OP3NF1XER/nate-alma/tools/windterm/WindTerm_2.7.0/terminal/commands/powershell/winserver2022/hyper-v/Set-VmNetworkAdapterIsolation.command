description: Modifies isolation settings for a virtual network adapter
synopses:
- Set-VMNetworkAdapterIsolation [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> [-IsolationMode
  <VMNetworkAdapterIsolationMode>] [-AllowUntaggedTraffic <Boolean>] [-DefaultIsolationID
  <Int32>] [-MultiTenantStack <OnOffState>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterIsolation [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [-IsolationMode
  <VMNetworkAdapterIsolationMode>] [-AllowUntaggedTraffic <Boolean>] [-DefaultIsolationID
  <Int32>] [-MultiTenantStack <OnOffState>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterIsolation [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-IsolationMode
  <VMNetworkAdapterIsolationMode>] [-AllowUntaggedTraffic <Boolean>] [-DefaultIsolationID
  <Int32>] [-MultiTenantStack <OnOffState>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterIsolation [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  [-IsolationMode <VMNetworkAdapterIsolationMode>] [-AllowUntaggedTraffic <Boolean>]
  [-DefaultIsolationID <Int32>] [-MultiTenantStack <OnOffState>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowUntaggedTraffic Boolean: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DefaultIsolationID Int32: ~
  -IsolationMode VMNetworkAdapterIsolationMode:
    values:
    - None
    - NativeVirtualSubnet
    - ExternalVirtualSubnet
    - Vlan
  -ManagementOS Switch:
    required: true
  -MultiTenantStack OnOffState:
    values:
    - On
    - Off
  -Passthru Switch: ~
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
