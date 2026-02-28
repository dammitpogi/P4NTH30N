description: Configures the virtual LAN settings for the traffic through a virtual
  network adapter
synopses:
- Set-VMNetworkAdapterVlan [-VMNetworkAdapterName <String>] [-CimSession <CimSession[]>]
  [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> [-Untagged]
  [-Access] [-VlanId <Int32>] [-Trunk] [-NativeVlanId <Int32>] [-AllowedVlanIdList
  <String>] [-Isolated] [-Community] [-Promiscuous] [-PrimaryVlanId <Int32>] [-SecondaryVlanId
  <Int32>] [-SecondaryVlanIdList <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterVlan [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [-Untagged]
  [-Access] [-VlanId <Int32>] [-Trunk] [-NativeVlanId <Int32>] [-AllowedVlanIdList
  <String>] [-Isolated] [-Community] [-Promiscuous] [-PrimaryVlanId <Int32>] [-SecondaryVlanId
  <Int32>] [-SecondaryVlanIdList <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterVlan [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-Untagged]
  [-Access] [-VlanId <Int32>] [-Trunk] [-NativeVlanId <Int32>] [-AllowedVlanIdList
  <String>] [-Isolated] [-Community] [-Promiscuous] [-PrimaryVlanId <Int32>] [-SecondaryVlanId
  <Int32>] [-SecondaryVlanIdList <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterVlan [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  [-Untagged] [-Access] [-VlanId <Int32>] [-Trunk] [-NativeVlanId <Int32>] [-AllowedVlanIdList
  <String>] [-Isolated] [-Community] [-Promiscuous] [-PrimaryVlanId <Int32>] [-SecondaryVlanId
  <Int32>] [-SecondaryVlanIdList <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Access,-a Switch: ~
  -AllowedVlanIdList String: ~
  -CimSession CimSession[]: ~
  -Community,-c Switch: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Isolated,-i Switch: ~
  -ManagementOS Switch:
    required: true
  -NativeVlanId Int32: ~
  -Passthru Switch: ~
  -PrimaryVlanId Int32: ~
  -Promiscuous,-p Switch: ~
  -SecondaryVlanId Int32: ~
  -SecondaryVlanIdList String: ~
  -Trunk,-t Switch: ~
  -Untagged,-u Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
    required: true
  -VMNetworkAdapterName String: ~
  -VlanId,-AccessVlanId Int32: ~
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
