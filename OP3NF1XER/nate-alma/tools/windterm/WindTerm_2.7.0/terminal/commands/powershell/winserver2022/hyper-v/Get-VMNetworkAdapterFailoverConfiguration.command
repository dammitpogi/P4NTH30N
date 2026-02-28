description: Gets the IP address of a virtual network adapter configured to be used
  when a virtual machine fails over
synopses:
- Get-VMNetworkAdapterFailoverConfiguration [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-VMName] <String[]> [-VMNetworkAdapterName
  <String>] [<CommonParameters>]
- Get-VMNetworkAdapterFailoverConfiguration [-VM] <VirtualMachine[]> [-VMNetworkAdapterName
  <String>] [<CommonParameters>]
- Get-VMNetworkAdapterFailoverConfiguration [-VMNetworkAdapter] <VMNetworkAdapter[]>
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapter[]:
    required: true
  -VMNetworkAdapterName String: ~
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
