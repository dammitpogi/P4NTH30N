description: Removes an extended ACL for a virtual network adapter
synopses:
- Remove-VMNetworkAdapterExtendedAcl [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-VMName]
  <String[]> -Weight <Int32> -Direction <VMNetworkAdapterExtendedAclDirection> [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterExtendedAcl [-VMNetworkAdapter] <VMNetworkAdapterBase[]>
  -Weight <Int32> -Direction <VMNetworkAdapterExtendedAclDirection> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterExtendedAcl [-ManagementOS] [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  -Weight <Int32> -Direction <VMNetworkAdapterExtendedAclDirection> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterExtendedAcl [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  -Weight <Int32> -Direction <VMNetworkAdapterExtendedAclDirection> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-VMNetworkAdapterExtendedAcl [-InputObject] <VMNetworkAdapterExtendedAclSetting[]>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Direction VMNetworkAdapterExtendedAclDirection:
    required: true
    values:
    - Inbound
    - Outbound
  -InputObject VMNetworkAdapterExtendedAclSetting[]:
    required: true
  -ManagementOS Switch:
    required: true
  -Passthru Switch: ~
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
