description: Removes a feature from a virtual network adapter
synopses:
- Remove-VMSwitchExtensionPortFeature -VMSwitchExtensionFeature <VMSwitchExtensionPortFeature[]>
  [-Passthru] [-VMName <String[]>] [-VMNetworkAdapter <VMNetworkAdapterBase[]>] [-ManagementOS]
  [-ExternalPort] [-SwitchName <String>] [-VMNetworkAdapterName <String>] [-ComputerName
  <String[]>] [-VM <VirtualMachine[]>] [-CimSession <CimSession[]>] [-Credential <PSCredential[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -ExternalPort Switch: ~
  -ManagementOS Switch: ~
  -Passthru Switch: ~
  -SwitchName String: ~
  -VM VirtualMachine[]: ~
  -VMName String[]: ~
  -VMNetworkAdapter VMNetworkAdapterBase[]: ~
  -VMNetworkAdapterName String: ~
  -VMSwitchExtensionFeature VMSwitchExtensionPortFeature[]:
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
