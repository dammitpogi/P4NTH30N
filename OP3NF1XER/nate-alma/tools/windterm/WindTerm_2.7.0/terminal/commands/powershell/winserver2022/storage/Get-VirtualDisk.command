description: Returns a list of VirtualDisk objects, across all storage pools, across
  all providers, or optionally a filtered subset based on provided criteria
synopses:
- Get-VirtualDisk [[-FriendlyName] <String[]>] [-Usage <Usage[]>] [-OtherUsageDescription
  <String[]>] [-IsSnapshot <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-UniqueId <String[]>] [-Usage <Usage[]>] [-OtherUsageDescription
  <String[]>] [-IsSnapshot <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Name <String[]>] [-Usage <Usage[]>] [-OtherUsageDescription <String[]>]
  [-IsSnapshot <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageJob <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-TargetVirtualDisk <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-SourceVirtualDisk <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-TargetPort <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-InitiatorId <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-MaskingSet <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-InitiatorPort <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-Disk <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageTier <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-PhysicalDisk <CimInstance>] [-PhysicalRangeMin
  <UInt64>] [-PhysicalRangeMax <UInt64>] [-NoRedundancy] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StoragePool <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageNode <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDisk [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsSnapshot
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageSubSystem <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Disk CimInstance: ~
  -FriendlyName String[]: ~
  -HealthStatus HealthStatus[]:
    values:
    - Healthy
    - Warning
    - Unhealthy
    - Unknown
  -InitiatorId CimInstance: ~
  -InitiatorPort CimInstance: ~
  -IsSnapshot Boolean[]: ~
  -MaskingSet CimInstance: ~
  -Name String[]: ~
  -NoRedundancy Switch: ~
  -OtherUsageDescription String[]: ~
  -PhysicalDisk CimInstance: ~
  -PhysicalRangeMax UInt64: ~
  -PhysicalRangeMin UInt64: ~
  -SourceVirtualDisk CimInstance: ~
  -StorageJob CimInstance: ~
  -StorageNode CimInstance: ~
  -StoragePool CimInstance: ~
  -StorageSubSystem CimInstance: ~
  -StorageTier CimInstance: ~
  -TargetPort CimInstance: ~
  -TargetVirtualDisk CimInstance: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]: ~
  -Usage Usage[]:
    values:
    - Unknown
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
