description: Gets extended ACLs configured for a virtual network adapter
synopses:
- Get-VMNetworkAdapterExtendedAcl [[-VMName] <String[]>] [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [<CommonParameters>]
- Get-VMNetworkAdapterExtendedAcl [-VMSnapshot] <VMSnapshot> [<CommonParameters>]
- Get-VMNetworkAdapterExtendedAcl [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [<CommonParameters>]
- Get-VMNetworkAdapterExtendedAcl [-ManagementOS] [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [<CommonParameters>]
- Get-VMNetworkAdapterExtendedAcl [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -ManagementOS Switch:
    required: true
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
