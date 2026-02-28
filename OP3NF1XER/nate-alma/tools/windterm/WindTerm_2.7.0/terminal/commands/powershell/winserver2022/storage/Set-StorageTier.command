description: Modifies a storage tier
synopses:
- Set-StorageTier [-NewFriendlyName <String>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier -InputObject <CimInstance[]> [-Description <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier -InputObject <CimInstance[]> [-MediaType <MediaType>] [-FaultDomainAwareness
  <FaultDomainType>] [-ColumnIsolation <FaultDomainType>] [-ResiliencySettingName
  <String>] [-PhysicalDiskRedundancy <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfGroups
  <UInt16>] [-NumberOfColumns <UInt16>] [-Interleave <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier -InputObject <CimInstance[]> [-NewFriendlyName <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier [-NewFriendlyName <String>] [-FriendlyName] <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier [-MediaType <MediaType>] [-FaultDomainAwareness <FaultDomainType>]
  [-ColumnIsolation <FaultDomainType>] [-ResiliencySettingName <String>] [-PhysicalDiskRedundancy
  <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfGroups <UInt16>] [-NumberOfColumns
  <UInt16>] [-Interleave <UInt64>] [-FriendlyName] <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier [-MediaType <MediaType>] [-FaultDomainAwareness <FaultDomainType>]
  [-ColumnIsolation <FaultDomainType>] [-ResiliencySettingName <String>] [-PhysicalDiskRedundancy
  <UInt16>] [-NumberOfDataCopies <UInt16>] [-NumberOfGroups <UInt16>] [-NumberOfColumns
  <UInt16>] [-Interleave <UInt64>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier [-Description <String>] [-FriendlyName] <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageTier [-Description <String>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
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
  -FriendlyName String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Interleave UInt64: ~
  -MediaType MediaType:
    values:
    - HDD
    - SSD
    - SCM
  -NewFriendlyName String: ~
  -NumberOfColumns UInt16: ~
  -NumberOfDataCopies UInt16: ~
  -NumberOfGroups UInt16: ~
  -PhysicalDiskRedundancy UInt16: ~
  -ResiliencySettingName String: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String:
    required: true
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
