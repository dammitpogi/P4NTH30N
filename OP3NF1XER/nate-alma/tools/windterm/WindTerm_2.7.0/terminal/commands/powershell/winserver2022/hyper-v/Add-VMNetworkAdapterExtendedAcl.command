description: Creates an extended ACL for a virtual network adapter
synopses:
- Add-VMNetworkAdapterExtendedAcl [-Action] <VMNetworkAdapterExtendedAclAction> [-Direction]
  <VMNetworkAdapterExtendedAclDirection> [[-LocalIPAddress] <String>] [[-RemoteIPAddress]
  <String>] [[-LocalPort] <String>] [[-RemotePort] <String>] [[-Protocol] <String>]
  [-Weight] <Int32> [-Stateful <Boolean>] [-IdleSessionTimeout <Int32>] [-IsolationID
  <Int32>] [-Passthru] [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterExtendedAcl [-Action] <VMNetworkAdapterExtendedAclAction> [-Direction]
  <VMNetworkAdapterExtendedAclDirection> [[-LocalIPAddress] <String>] [[-RemoteIPAddress]
  <String>] [[-LocalPort] <String>] [[-RemotePort] <String>] [[-Protocol] <String>]
  [-Weight] <Int32> [-Stateful <Boolean>] [-IdleSessionTimeout <Int32>] [-IsolationID
  <Int32>] [-Passthru] [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-VMNetworkAdapterExtendedAcl [-Action] <VMNetworkAdapterExtendedAclAction> [-Direction]
  <VMNetworkAdapterExtendedAclDirection> [[-LocalIPAddress] <String>] [[-RemoteIPAddress]
  <String>] [[-LocalPort] <String>] [[-RemotePort] <String>] [[-Protocol] <String>]
  [-Weight] <Int32> [-Stateful <Boolean>] [-IdleSessionTimeout <Int32>] [-IsolationID
  <Int32>] [-Passthru] [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterExtendedAcl [-Action] <VMNetworkAdapterExtendedAclAction> [-Direction]
  <VMNetworkAdapterExtendedAclDirection> [[-LocalIPAddress] <String>] [[-RemoteIPAddress]
  <String>] [[-LocalPort] <String>] [[-RemotePort] <String>] [[-Protocol] <String>]
  [-Weight] <Int32> [-Stateful <Boolean>] [-IdleSessionTimeout <Int32>] [-IsolationID
  <Int32>] [-Passthru] [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Action VMNetworkAdapterExtendedAclAction:
    required: true
    values:
    - Allow
    - Deny
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Direction VMNetworkAdapterExtendedAclDirection:
    required: true
    values:
    - Inbound
    - Outbound
  -IdleSessionTimeout Int32: ~
  -IsolationID Int32: ~
  -LocalIPAddress String: ~
  -LocalPort String: ~
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
  -Protocol String: ~
  -RemoteIPAddress String: ~
  -RemotePort String: ~
  -Stateful Boolean: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
    required: true
  -VMNetworkAdapterName String: ~
  -Weight Int32:
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
