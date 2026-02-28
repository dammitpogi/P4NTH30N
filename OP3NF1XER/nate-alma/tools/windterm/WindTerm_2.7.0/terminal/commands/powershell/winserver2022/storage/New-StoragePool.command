description: Creates a new storage pool using a group of physical disks
synopses:
- New-StoragePool [-StorageSubSystemFriendlyName] <String[]> -FriendlyName <String>
  [-Usage <Usage>] [-OtherUsageDescription <String>] -PhysicalDisks <CimInstance[]>
  [-ProvisioningTypeDefault <ProvisioningType>] [-MediaTypeDefault <MediaType>] [-EnclosureAwareDefault
  <Boolean>] [-FaultDomainAwarenessDefault <FaultDomainType>] [-ResiliencySettingNameDefault
  <String>] [-LogicalSectorSizeDefault <UInt64>] [-WriteCacheSizeDefault <UInt64>]
  [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-StoragePool -StorageSubSystemUniqueId <String[]> -FriendlyName <String> [-Usage
  <Usage>] [-OtherUsageDescription <String>] -PhysicalDisks <CimInstance[]> [-ProvisioningTypeDefault
  <ProvisioningType>] [-MediaTypeDefault <MediaType>] [-EnclosureAwareDefault <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-ResiliencySettingNameDefault
  <String>] [-LogicalSectorSizeDefault <UInt64>] [-WriteCacheSizeDefault <UInt64>]
  [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-StoragePool -StorageSubSystemName <String[]> -FriendlyName <String> [-Usage
  <Usage>] [-OtherUsageDescription <String>] -PhysicalDisks <CimInstance[]> [-ProvisioningTypeDefault
  <ProvisioningType>] [-MediaTypeDefault <MediaType>] [-EnclosureAwareDefault <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-ResiliencySettingNameDefault
  <String>] [-LogicalSectorSizeDefault <UInt64>] [-WriteCacheSizeDefault <UInt64>]
  [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-StoragePool -InputObject <CimInstance[]> -FriendlyName <String> [-Usage <Usage>]
  [-OtherUsageDescription <String>] -PhysicalDisks <CimInstance[]> [-ProvisioningTypeDefault
  <ProvisioningType>] [-MediaTypeDefault <MediaType>] [-EnclosureAwareDefault <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-ResiliencySettingNameDefault
  <String>] [-LogicalSectorSizeDefault <UInt64>] [-WriteCacheSizeDefault <UInt64>]
  [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoWriteCacheSize Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -EnclosureAwareDefault Boolean: ~
  -FaultDomainAwarenessDefault FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FriendlyName,-StoragePoolFriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -LogicalSectorSizeDefault UInt64: ~
  -MediaTypeDefault MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -OtherUsageDescription,-StoragePoolOtherUsageDescription String: ~
  -PhysicalDisks CimInstance[]:
    required: true
  -ProvisioningTypeDefault ProvisioningType:
    values:
    - Unknown
    - Thin
    - Fixed
  -ResiliencySettingNameDefault String: ~
  -StorageSubSystemFriendlyName String[]:
    required: true
  -StorageSubSystemName String[]:
    required: true
  -StorageSubSystemUniqueId,-StorageSubsystemId String[]:
    required: true
  -ThrottleLimit Int32: ~
  -Usage,-StoragePoolUsage Usage:
    values:
    - Other
    - Unrestricted
    - ReservedForComputerSystem
    - ReservedAsDeltaReplicaContainer
    - ReservedForMigrationServices
    - ReservedForLocalReplicationServices
    - ReservedForRemoteReplicationServices
    - ReservedForSparing
  -WriteCacheSizeDefault UInt64: ~
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
