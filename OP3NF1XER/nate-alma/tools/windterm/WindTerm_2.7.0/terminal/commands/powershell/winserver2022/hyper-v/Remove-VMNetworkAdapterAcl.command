description: Removes an ACL applied to the traffic through a virtual network adapter
synopses:
- Remove-VMNetworkAdapterAcl [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> -Action
  <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection> [-LocalIPAddress
  <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>] [-RemoteMacAddress
  <String[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterAcl [-VMNetworkAdapter] <VMNetworkAdapterBase[]> -Action
  <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection> [-LocalIPAddress
  <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>] [-RemoteMacAddress
  <String[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterAcl [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] -Action
  <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection> [-LocalIPAddress
  <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>] [-RemoteMacAddress
  <String[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterAcl [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  -Action <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection> [-LocalIPAddress
  <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>] [-RemoteMacAddress
  <String[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterAcl [-InputObject] <VMNetworkAdapterAclSetting[]> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action VMNetworkAdapterAclAction:
    required: true
    values:
    - Allow
    - Deny
    - Meter
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Direction VMNetworkAdapterAclDirection:
    required: true
    values:
    - Inbound
    - Outbound
    - Both
  -InputObject VMNetworkAdapterAclSetting[]:
    required: true
  -LocalIPAddress String[]: ~
  -LocalMacAddress String[]: ~
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
  -RemoteIPAddress String[]: ~
  -RemoteMacAddress String[]: ~
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
