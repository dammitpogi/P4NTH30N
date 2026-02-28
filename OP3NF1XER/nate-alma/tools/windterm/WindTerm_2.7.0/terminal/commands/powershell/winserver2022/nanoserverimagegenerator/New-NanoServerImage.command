description: Creates a Nano Server installation image
synopses:
- New-NanoServerImage [-DeploymentType] <String> {Host | Guest} [-Edition] <String>
  {Standard | Datacenter} -TargetPath <String> -AdministratorPassword <SecureString>
  [-MediaPath <String>] [-BasePath <String>] [-MaxSize <UInt64>] [-Storage] [-Compute]
  [-Defender] [-Clustering] [-OEMDrivers] [-Containers] [-SetupUI <String[]>] [-Package
  <String[]>] [-ServicingPackagePath <String[]>] [-ComputerName <String>] [-UnattendPath
  <String>] [-DomainName <String>] [-DomainBlobPath <String>] [-ReuseDomainNode] [-DriverPath
  <String[]>] [-InterfaceNameOrIndex <String>] [-Ipv6Address <String>] [-Ipv6Dns <String[]>]
  [-Ipv4Address <String>] [-Ipv4SubnetMask <String>] [-Ipv4Gateway <String>] [-Ipv4Dns
  <String[]>] [-DebugMethod <String> {Serial | Net | 1394 | USB}] [-DebugBaudRate
  <UInt32>] [-DebugBusParams <String>] [-DebugChannel <UInt16>] [-DebugCOMPort <Byte>]
  [-DebugKey <String>] [-DebugPort <UInt16>] [-DebugRemoteIP <String>] [-DebugTargetName
  <String>] [-EnableEMS] [-EMSPort <Byte>] [-EMSBaudRate <UInt32>] [-EnableRemoteManagementPort]
  [-CopyPath <Object>] [-SetupCompleteCommand <String[]>] [-Development] [-LogPath
  <String>] [-OfflineScriptPath <String[]>] [-OfflineScriptArgument <Hashtable>] [-Internal
  <String>] [<CommonParameters>]
options:
  -AdministratorPassword SecureString:
    required: true
  -BasePath String: ~
  -Clustering Switch: ~
  -Compute Switch: ~
  -ComputerName String: ~
  -Containers Switch: ~
  -CopyPath Object: ~
  -DebugBaudRate UInt32: ~
  -DebugBusParams String: ~
  -DebugChannel UInt16:
    required: true
  -DebugCOMPort Byte: ~
  -DebugKey String: ~
  -DebugMethod String:
    values:
    - Serial
    - Net
    - '1394'
    - USB
  -DebugPort UInt16:
    required: true
  -DebugRemoteIP String:
    required: true
  -DebugTargetName String:
    required: true
  -Defender Switch: ~
  -DeploymentType String:
    required: true
    values:
    - Host
    - Guest
  -Development Switch: ~
  -DomainBlobPath String: ~
  -DomainName String: ~
  -DriverPath String[]: ~
  -Edition String:
    required: true
    values:
    - Standard
    - Datacenter
  -EMSBaudRate UInt32: ~
  -EMSPort Byte: ~
  -EnableEMS Switch: ~
  -EnableRemoteManagementPort Switch: ~
  -InterfaceNameOrIndex String: ~
  -Internal String: ~
  -Ipv4Address String: ~
  -Ipv4Dns String[]: ~
  -Ipv4Gateway String: ~
  -Ipv4SubnetMask String: ~
  -Ipv6Address String: ~
  -Ipv6Dns String[]: ~
  -LogPath String: ~
  -MaxSize UInt64: ~
  -MediaPath String: ~
  -OEMDrivers Switch: ~
  -OfflineScriptArgument Hashtable: ~
  -OfflineScriptPath String[]: ~
  -Package String[]: ~
  -ReuseDomainNode Switch: ~
  -ServicingPackagePath String[]: ~
  -SetupCompleteCommand String[]: ~
  -SetupUI String[]: ~
  -Storage Switch: ~
  -TargetPath String:
    required: true
  -UnattendPath String: ~
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
