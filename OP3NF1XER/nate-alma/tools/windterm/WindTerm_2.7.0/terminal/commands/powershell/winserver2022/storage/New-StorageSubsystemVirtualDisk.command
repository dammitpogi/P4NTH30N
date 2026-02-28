description: Allows the creation of a VirtualDisk object on a storage subsystem that
  does not support creation of storage pools
synopses:
- New-StorageSubsystemVirtualDisk [-StorageSubSystemFriendlyName] <String[]> [-FriendlyName
  <String>] [-Usage <Usage>] [-OtherUsageDescription <String>] [-Size <UInt64>] [-UseMaximumSize]
  [-Interleave <UInt64>] [-NumberOfColumns <UInt16>] [-PhysicalDiskRedundancy <UInt16>]
  [-NumberOfDataCopies <UInt16>] [-ParityLayout <ParityLayout>] [-RequestNoSinglePointOfFailure
  <Boolean>] [-ProvisioningType <ProvisioningType>] [-IsEnclosureAware] [-FaultDomainAwareness
  <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- New-StorageSubsystemVirtualDisk -StorageSubSystemUniqueId <String[]> [-FriendlyName
  <String>] [-Usage <Usage>] [-OtherUsageDescription <String>] [-Size <UInt64>] [-UseMaximumSize]
  [-Interleave <UInt64>] [-NumberOfColumns <UInt16>] [-PhysicalDiskRedundancy <UInt16>]
  [-NumberOfDataCopies <UInt16>] [-ParityLayout <ParityLayout>] [-RequestNoSinglePointOfFailure
  <Boolean>] [-ProvisioningType <ProvisioningType>] [-IsEnclosureAware] [-FaultDomainAwareness
  <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- New-StorageSubsystemVirtualDisk -StorageSubSystemName <String[]> [-FriendlyName
  <String>] [-Usage <Usage>] [-OtherUsageDescription <String>] [-Size <UInt64>] [-UseMaximumSize]
  [-Interleave <UInt64>] [-NumberOfColumns <UInt16>] [-PhysicalDiskRedundancy <UInt16>]
  [-NumberOfDataCopies <UInt16>] [-ParityLayout <ParityLayout>] [-RequestNoSinglePointOfFailure
  <Boolean>] [-ProvisioningType <ProvisioningType>] [-IsEnclosureAware] [-FaultDomainAwareness
  <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- New-StorageSubsystemVirtualDisk -InputObject <CimInstance[]> [-FriendlyName <String>]
  [-Usage <Usage>] [-OtherUsageDescription <String>] [-Size <UInt64>] [-UseMaximumSize]
  [-Interleave <UInt64>] [-NumberOfColumns <UInt16>] [-PhysicalDiskRedundancy <UInt16>]
  [-NumberOfDataCopies <UInt16>] [-ParityLayout <ParityLayout>] [-RequestNoSinglePointOfFailure
  <Boolean>] [-ProvisioningType <ProvisioningType>] [-IsEnclosureAware] [-FaultDomainAwareness
  <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FaultDomainAwareness FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FriendlyName,-VirtualDiskFriendlyName String: ~
  -InputObject CimInstance[]:
    required: true
  -Interleave UInt64: ~
  -IsEnclosureAware Switch: ~
  -NumberOfColumns UInt16: ~
  -NumberOfDataCopies UInt16: ~
  -OtherUsageDescription String: ~
  -ParityLayout ParityLayout:
    values:
    - NonRotatedParity
    - RotatedParity
  -PhysicalDiskRedundancy UInt16: ~
  -ProvisioningType ProvisioningType:
    values:
    - Unknown
    - Thin
    - Fixed
  -RequestNoSinglePointOfFailure Boolean: ~
  -Size UInt64: ~
  -StorageSubSystemFriendlyName String[]:
    required: true
  -StorageSubSystemName String[]:
    required: true
  -StorageSubSystemUniqueId,-StorageSubsystemId String[]:
    required: true
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
