description: Creates an ACL to apply to the traffic through a virtual machine network
  adapter
synopses:
- Add-VMNetworkAdapterAcl -Action <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection>
  [-LocalIPAddress <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>]
  [-RemoteMacAddress <String[]>] [-Passthru] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName]
  <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterAcl -Action <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection>
  [-LocalIPAddress <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>]
  [-RemoteMacAddress <String[]>] [-Passthru] [-VMNetworkAdapter] <VMNetworkAdapterBase[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterAcl -Action <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection>
  [-LocalIPAddress <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>]
  [-RemoteMacAddress <String[]>] [-Passthru] [-ManagementOS] [-VMNetworkAdapterName
  <String>] [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMNetworkAdapterAcl -Action <VMNetworkAdapterAclAction> -Direction <VMNetworkAdapterAclDirection>
  [-LocalIPAddress <String[]>] [-LocalMacAddress <String[]>] [-RemoteIPAddress <String[]>]
  [-RemoteMacAddress <String[]>] [-Passthru] [-VMNetworkAdapterName <String>] [-VM]
  <VirtualMachine[]> [-WhatIf] [-Confirm] [<CommonParameters>]
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
