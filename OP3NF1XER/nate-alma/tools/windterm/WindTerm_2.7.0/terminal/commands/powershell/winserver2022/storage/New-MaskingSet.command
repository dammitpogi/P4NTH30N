description: Creates a new masking set
synopses:
- New-MaskingSet [-StorageSubSystemFriendlyName] <String[]> [-FriendlyName <String>]
  [-VirtualDiskNames <String[]>] [-InitiatorAddresses <String[]>] [-TargetPortAddresses
  <String[]>] [-DeviceNumbers <String[]>] [-DeviceAccesses <DeviceAccess[]>] [-HostType
  <HostMode>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-MaskingSet -StorageSubSystemUniqueId <String[]> [-FriendlyName <String>] [-VirtualDiskNames
  <String[]>] [-InitiatorAddresses <String[]>] [-TargetPortAddresses <String[]>] [-DeviceNumbers
  <String[]>] [-DeviceAccesses <DeviceAccess[]>] [-HostType <HostMode>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-MaskingSet -StorageSubSystemName <String[]> [-FriendlyName <String>] [-VirtualDiskNames
  <String[]>] [-InitiatorAddresses <String[]>] [-TargetPortAddresses <String[]>] [-DeviceNumbers
  <String[]>] [-DeviceAccesses <DeviceAccess[]>] [-HostType <HostMode>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-MaskingSet -InputObject <CimInstance[]> [-FriendlyName <String>] [-VirtualDiskNames
  <String[]>] [-InitiatorAddresses <String[]>] [-TargetPortAddresses <String[]>] [-DeviceNumbers
  <String[]>] [-DeviceAccesses <DeviceAccess[]>] [-HostType <HostMode>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DeviceAccesses DeviceAccess[]:
    values:
    - Unknown
    - ReadWrite
    - ReadOnly
    - NoAccess
  -DeviceNumbers String[]: ~
  -FriendlyName,-MaskingSetFriendlyName String: ~
  -HostType HostMode:
    values:
    - Unknown
    - Other
    - Standard
    - Solaris
    - HPUX
    - OpenVMS
    - Tru64
    - Netware
    - Sequent
    - AIX
    - DGUX
    - Dynix
    - Irix
    - CiscoISCSIStorageRouter
    - Linux
    - MicrosoftWindows
    - OS400
    - TRESPASS
    - HIUX
    - VMwareESXi
    - MicrosoftWindowsServer2008
    - MicrosoftWindowsServer2003
  -InitiatorAddresses String[]: ~
  -InputObject CimInstance[]:
    required: true
  -StorageSubSystemFriendlyName String[]:
    required: true
  -StorageSubSystemName String[]:
    required: true
  -StorageSubSystemUniqueId,-StorageSubsystemId String[]:
    required: true
  -TargetPortAddresses String[]: ~
  -ThrottleLimit Int32: ~
  -VirtualDiskNames String[]: ~
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
