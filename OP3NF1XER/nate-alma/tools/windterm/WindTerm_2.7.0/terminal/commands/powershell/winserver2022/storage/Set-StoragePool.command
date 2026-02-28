description: Modifies the properties of the specified storage pool
synopses:
- Set-StoragePool [-NewFriendlyName <String>] [-ClearOnDeallocate <Boolean>] [-IsPowerProtected
  <Boolean>] [-RepairPolicy <RepairPolicy>] [-RetireMissingPhysicalDisks <RetireMissingPhysicalDisks>]
  [-Usage <Usage>] [-OtherUsageDescription <String>] [-ThinProvisioningAlertThresholds
  <UInt16[]>] -UniqueId <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-StoragePool [-InputObject] <CimInstance[]> [-IsReadOnly <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool [-InputObject] <CimInstance[]> [-ProvisioningTypeDefault <ProvisioningType>]
  [-MediaTypeDefault <MediaType>] [-ResiliencySettingNameDefault <String>] [-EnclosureAwareDefault
  <Boolean>] [-FaultDomainAwarenessDefault <FaultDomainType>] [-WriteCacheSizeDefault
  <UInt64>] [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool [-InputObject] <CimInstance[]> [-NewFriendlyName <String>] [-ClearOnDeallocate
  <Boolean>] [-IsPowerProtected <Boolean>] [-RepairPolicy <RepairPolicy>] [-RetireMissingPhysicalDisks
  <RetireMissingPhysicalDisks>] [-Usage <Usage>] [-OtherUsageDescription <String>]
  [-ThinProvisioningAlertThresholds <UInt16[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool [-NewFriendlyName <String>] [-ClearOnDeallocate <Boolean>] [-IsPowerProtected
  <Boolean>] [-RepairPolicy <RepairPolicy>] [-RetireMissingPhysicalDisks <RetireMissingPhysicalDisks>]
  [-Usage <Usage>] [-OtherUsageDescription <String>] [-ThinProvisioningAlertThresholds
  <UInt16[]>] [-FriendlyName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool [-NewFriendlyName <String>] [-ClearOnDeallocate <Boolean>] [-IsPowerProtected
  <Boolean>] [-RepairPolicy <RepairPolicy>] [-RetireMissingPhysicalDisks <RetireMissingPhysicalDisks>]
  [-Usage <Usage>] [-OtherUsageDescription <String>] [-ThinProvisioningAlertThresholds
  <UInt16[]>] -Name <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-StoragePool -UniqueId <String> [-IsReadOnly <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool -UniqueId <String> [-ProvisioningTypeDefault <ProvisioningType>]
  [-MediaTypeDefault <MediaType>] [-ResiliencySettingNameDefault <String>] [-EnclosureAwareDefault
  <Boolean>] [-FaultDomainAwarenessDefault <FaultDomainType>] [-WriteCacheSizeDefault
  <UInt64>] [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool -Name <String> [-IsReadOnly <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool -Name <String> [-ProvisioningTypeDefault <ProvisioningType>] [-MediaTypeDefault
  <MediaType>] [-ResiliencySettingNameDefault <String>] [-EnclosureAwareDefault <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-WriteCacheSizeDefault <UInt64>]
  [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Set-StoragePool [-FriendlyName] <String> [-IsReadOnly <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StoragePool [-FriendlyName] <String> [-ProvisioningTypeDefault <ProvisioningType>]
  [-MediaTypeDefault <MediaType>] [-ResiliencySettingNameDefault <String>] [-EnclosureAwareDefault
  <Boolean>] [-FaultDomainAwarenessDefault <FaultDomainType>] [-WriteCacheSizeDefault
  <UInt64>] [-AutoWriteCacheSize <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutoWriteCacheSize Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -ClearOnDeallocate Boolean: ~
  -EnclosureAwareDefault Boolean: ~
  -FaultDomainAwarenessDefault FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -IsPowerProtected Boolean: ~
  -IsReadOnly Boolean: ~
  -MediaTypeDefault MediaType:
    values:
    - Unspecified
    - HDD
    - SSD
    - SCM
  -Name String:
    required: true
  -NewFriendlyName String: ~
  -OtherUsageDescription,-NewOtherUsageDescription String: ~
  -ProvisioningTypeDefault ProvisioningType:
    values:
    - Unknown
    - Thin
    - Fixed
  -RepairPolicy RepairPolicy:
    values:
    - Sequential
    - Parallel
  -ResiliencySettingNameDefault String: ~
  -RetireMissingPhysicalDisks RetireMissingPhysicalDisks:
    values:
    - Auto
    - Always
    - Never
  -ThinProvisioningAlertThresholds UInt16[]: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String:
    required: true
  -Usage,-NewUsage Usage:
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
