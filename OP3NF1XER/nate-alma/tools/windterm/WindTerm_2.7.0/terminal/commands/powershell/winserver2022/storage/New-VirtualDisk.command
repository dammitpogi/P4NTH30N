description: Creates a new virtual disk in the specified storage pool
synopses:
- New-VirtualDisk [-StoragePoolFriendlyName] <String[]> -FriendlyName <String> [-Usage
  <Usage>] [-OtherUsageDescription <String>] [-ResiliencySettingName <String>] [-Size
  <UInt64>] [-UseMaximumSize] [-ProvisioningType <ProvisioningType>] [-AllocationUnitSize
  <UInt64>] [-MediaType <MediaType>] [-IsEnclosureAware <Boolean>] [-FaultDomainAwareness
  <FaultDomainType>] [-ColumnIsolation <FaultDomainType>] [-PhysicalDisksToUse <CimInstance[]>]
  [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfColumns
  <UInt16>] [-AutoNumberOfColumns] [-NumberOfGroups <UInt16>] [-Interleave <UInt64>]
  [-StorageTiers <CimInstance[]>] [-StorageTierSizes <UInt64[]>] [-WriteCacheSize
  <UInt64>] [-AutoWriteCacheSize] [-ReadCacheSize <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-VirtualDisk -StoragePoolUniqueId <String[]> -FriendlyName <String> [-Usage <Usage>]
  [-OtherUsageDescription <String>] [-ResiliencySettingName <String>] [-Size <UInt64>]
  [-UseMaximumSize] [-ProvisioningType <ProvisioningType>] [-AllocationUnitSize <UInt64>]
  [-MediaType <MediaType>] [-IsEnclosureAware <Boolean>] [-FaultDomainAwareness <FaultDomainType>]
  [-ColumnIsolation <FaultDomainType>] [-PhysicalDisksToUse <CimInstance[]>] [-PhysicalDiskRedundancy
  <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfColumns <UInt16>] [-AutoNumberOfColumns]
  [-NumberOfGroups <UInt16>] [-Interleave <UInt64>] [-StorageTiers <CimInstance[]>]
  [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-AutoWriteCacheSize]
  [-ReadCacheSize <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-VirtualDisk -StoragePoolName <String[]> -FriendlyName <String> [-Usage <Usage>]
  [-OtherUsageDescription <String>] [-ResiliencySettingName <String>] [-Size <UInt64>]
  [-UseMaximumSize] [-ProvisioningType <ProvisioningType>] [-AllocationUnitSize <UInt64>]
  [-MediaType <MediaType>] [-IsEnclosureAware <Boolean>] [-FaultDomainAwareness <FaultDomainType>]
  [-ColumnIsolation <FaultDomainType>] [-PhysicalDisksToUse <CimInstance[]>] [-PhysicalDiskRedundancy
  <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfColumns <UInt16>] [-AutoNumberOfColumns]
  [-NumberOfGroups <UInt16>] [-Interleave <UInt64>] [-StorageTiers <CimInstance[]>]
  [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-AutoWriteCacheSize]
  [-ReadCacheSize <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-VirtualDisk -InputObject <CimInstance[]> -FriendlyName <String> [-Usage <Usage>]
  [-OtherUsageDescription <String>] [-ResiliencySettingName <String>] [-Size <UInt64>]
  [-UseMaximumSize] [-ProvisioningType <ProvisioningType>] [-AllocationUnitSize <UInt64>]
  [-MediaType <MediaType>] [-IsEnclosureAware <Boolean>] [-FaultDomainAwareness <FaultDomainType>]
  [-ColumnIsolation <FaultDomainType>] [-PhysicalDisksToUse <CimInstance[]>] [-PhysicalDiskRedundancy
  <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfColumns <UInt16>] [-AutoNumberOfColumns]
  [-NumberOfGroups <UInt16>] [-Interleave <UInt64>] [-StorageTiers <CimInstance[]>]
  [-StorageTierSizes <UInt64[]>] [-WriteCacheSize <UInt64>] [-AutoWriteCacheSize]
  [-ReadCacheSize <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AllocationUnitSize UInt64: ~
  -AsJob Switch: ~
  -AutoNumberOfColumns Switch: ~
  -AutoWriteCacheSize Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ColumnIsolation FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FaultDomainAwareness FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FriendlyName,-VirtualDiskFriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Interleave UInt64: ~
  -IsEnclosureAware Boolean: ~
  -MediaType MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -NumberOfColumns UInt16: ~
  -NumberOfDataCopies UInt16: ~
  -NumberOfGroups UInt16: ~
  -OtherUsageDescription,-VirtualDiskOtherUsageDescription String: ~
  -PhysicalDiskRedundancy UInt16: ~
  -PhysicalDisksToUse CimInstance[]: ~
  -ProvisioningType ProvisioningType:
    values:
    - Unknown
    - Thin
    - Fixed
  -ReadCacheSize UInt64: ~
  -ResiliencySettingName String: ~
  -Size UInt64: ~
  -StoragePoolFriendlyName String[]:
    required: true
  -StoragePoolName String[]:
    required: true
  -StoragePoolUniqueId,-StoragePoolId String[]:
    required: true
  -StorageTierSizes UInt64[]: ~
  -StorageTiers CimInstance[]: ~
  -ThrottleLimit Int32: ~
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
  -UseMaximumSize Switch: ~
  -WriteCacheSize UInt64: ~
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
