description: Gets the virtual network adapters of a virtual machine, snapshot, management
  operating system, or of a virtual machine and management operating system
synopses:
- Get-VMNetworkAdapter [-IsLegacy <Boolean>] [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> [[-Name] <String>]
  [<CommonParameters>]
- Get-VMNetworkAdapter [-IsLegacy <Boolean>] [-VM] <VirtualMachine[]> [[-Name] <String>]
  [<CommonParameters>]
- Get-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [[-Name] <String>] [-ManagementOS] [-SwitchName <String>] [<CommonParameters>]
- Get-VMNetworkAdapter [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [[-Name] <String>] [-All] [<CommonParameters>]
- Get-VMNetworkAdapter [[-Name] <String>] [-VMSnapshot] <VMSnapshot> [<CommonParameters>]
options:
  -All Switch:
    required: true
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -IsLegacy Boolean: ~
  -ManagementOS Switch:
    required: true
  -Name,-VMNetworkAdapterName String: ~
  -SwitchName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
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
