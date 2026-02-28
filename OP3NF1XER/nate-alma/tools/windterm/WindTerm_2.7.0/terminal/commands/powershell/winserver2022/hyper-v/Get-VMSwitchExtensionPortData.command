description: Retrieves the status of a virtual switch extension feature applied to
  a virtual network adapter
synopses:
- Get-VMSwitchExtensionPortData [-VMName] <String[]> [-VMNetworkAdapterName <String>]
  [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-FeatureName <String[]>] [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>]
  [-ExtensionName <String[]>] [<CommonParameters>]
- Get-VMSwitchExtensionPortData [-VMNetworkAdapter] <VMNetworkAdapterBase[]> [-FeatureName
  <String[]>] [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>] [-ExtensionName
  <String[]>] [<CommonParameters>]
- Get-VMSwitchExtensionPortData [-ManagementOS] [-VMNetworkAdapterName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-FeatureName
  <String[]>] [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>] [-ExtensionName
  <String[]>] [<CommonParameters>]
- Get-VMSwitchExtensionPortData [-ExternalPort] [-SwitchName <String>] [-CimSession
  <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>] [-FeatureName
  <String[]>] [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>] [-ExtensionName
  <String[]>] [<CommonParameters>]
- Get-VMSwitchExtensionPortData [-VMNetworkAdapterName <String>] [-VM] <VirtualMachine[]>
  [-FeatureName <String[]>] [-FeatureId <Guid[]>] [-Extension <VMSwitchExtension[]>]
  [-ExtensionName <String[]>] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Extension VMSwitchExtension[]: ~
  -ExtensionName String[]: ~
  -ExternalPort Switch:
    required: true
  -FeatureId Guid[]: ~
  -FeatureName String[]: ~
  -ManagementOS Switch:
    required: true
  -SwitchName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMName String[]:
    required: true
  -VMNetworkAdapter VMNetworkAdapterBase[]:
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
