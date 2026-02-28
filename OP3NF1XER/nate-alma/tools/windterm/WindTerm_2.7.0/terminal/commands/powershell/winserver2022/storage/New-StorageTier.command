description: Creates a storage tier
synopses:
- New-StorageTier [-StoragePoolFriendlyName] <String[]> -FriendlyName <String> [-MediaType
  <MediaType>] [-FaultDomainAwareness <FaultDomainType>] [-ColumnIsolation <FaultDomainType>]
  [-ResiliencySettingName <String>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies
  <UInt16>] [-NumberOfGroups <UInt16>] [-NumberOfColumns <UInt16>] [-Interleave <UInt64>]
  [-Description <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- New-StorageTier -StoragePoolUniqueId <String[]> -FriendlyName <String> [-MediaType
  <MediaType>] [-FaultDomainAwareness <FaultDomainType>] [-ColumnIsolation <FaultDomainType>]
  [-ResiliencySettingName <String>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies
  <UInt16>] [-NumberOfGroups <UInt16>] [-NumberOfColumns <UInt16>] [-Interleave <UInt64>]
  [-Description <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- New-StorageTier -StoragePoolName <String[]> -FriendlyName <String> [-MediaType <MediaType>]
  [-FaultDomainAwareness <FaultDomainType>] [-ColumnIsolation <FaultDomainType>] [-ResiliencySettingName
  <String>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfGroups
  <UInt16>] [-NumberOfColumns <UInt16>] [-Interleave <UInt64>] [-Description <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-StorageTier -InputObject <CimInstance[]> -FriendlyName <String> [-MediaType
  <MediaType>] [-FaultDomainAwareness <FaultDomainType>] [-ColumnIsolation <FaultDomainType>]
  [-ResiliencySettingName <String>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies
  <UInt16>] [-NumberOfGroups <UInt16>] [-NumberOfColumns <UInt16>] [-Interleave <UInt64>]
  [-Description <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ColumnIsolation FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -Description String: ~
  -FaultDomainAwareness FaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
  -FriendlyName,-StorageTierFriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Interleave UInt64: ~
  -MediaType MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -NumberOfColumns UInt16: ~
  -NumberOfDataCopies UInt16: ~
  -NumberOfGroups UInt16: ~
  -PhysicalDiskRedundancy UInt16: ~
  -ResiliencySettingName String: ~
  -StoragePoolFriendlyName String[]:
    required: true
  -StoragePoolName String[]:
    required: true
  -StoragePoolUniqueId,-StoragePoolId String[]:
    required: true
  -ThrottleLimit Int32: ~
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
