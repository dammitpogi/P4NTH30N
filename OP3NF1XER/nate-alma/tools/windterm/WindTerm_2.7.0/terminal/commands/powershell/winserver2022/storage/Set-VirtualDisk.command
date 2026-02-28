description: Modifies the attributes of an existing virtual disk
synopses:
- Set-VirtualDisk [-NewFriendlyName <String>] [-Usage <Usage>] [-OtherUsageDescription
  <String>] -UniqueId <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-VirtualDisk [-InputObject] <CimInstance[]> [-IsManualAttach <Boolean>] [-StorageNodeName
  <String>] [-Access <Access>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-VirtualDisk [-InputObject] <CimInstance[]> [-NewFriendlyName <String>] [-Usage
  <Usage>] [-OtherUsageDescription <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-VirtualDisk [-NewFriendlyName <String>] [-Usage <Usage>] [-OtherUsageDescription
  <String>] -Name <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-VirtualDisk [-NewFriendlyName <String>] [-Usage <Usage>] [-OtherUsageDescription
  <String>] [-FriendlyName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-VirtualDisk -UniqueId <String> [-IsManualAttach <Boolean>] [-StorageNodeName
  <String>] [-Access <Access>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-VirtualDisk [-FriendlyName] <String> [-IsManualAttach <Boolean>] [-StorageNodeName
  <String>] [-Access <Access>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-VirtualDisk -Name <String> [-IsManualAttach <Boolean>] [-StorageNodeName <String>]
  [-Access <Access>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -Access Access:
    values:
    - Unknown
    - Readable
    - Writeable
    - ReadWrite
    - WriteOnce
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -IsManualAttach Boolean: ~
  -Name String:
    required: true
  -NewFriendlyName String: ~
  -OtherUsageDescription String: ~
  -StorageNodeName String: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String:
    required: true
  -Usage Usage:
    values:
    - Other
    - Unrestricted
    - ReservedForComputerSystem
    - ReservedForReplicationServices
    - ReservedForMigrationServices
    - LocalReplicaSource
    - RemoteReplicaSource
    - LocalReplicaTarget
    - RemoteReplicaTarget
    - LocalReplicaSourceOrTarget
    - RemoteReplicaSourceOrTarget
    - DeltaReplicaTarget
    - ElementComponent
    - ReservedAsPoolContributer
    - CompositeVolumeMember
    - CompositeVirtualDiskMember
    - ReservedForSparing
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
