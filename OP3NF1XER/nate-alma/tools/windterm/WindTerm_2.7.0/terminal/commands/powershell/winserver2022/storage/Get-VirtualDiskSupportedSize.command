description: Returns all sizes supported by a storage pool for virtual disk creation
  based on the specified resiliency setting name
synopses:
- Get-VirtualDiskSupportedSize [-StoragePoolFriendlyName] <String[]> [-ResiliencySettingName
  <String>] [-FaultDomainAwareness <FaultDomainType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDiskSupportedSize -StoragePoolUniqueId <String[]> [-ResiliencySettingName
  <String>] [-FaultDomainAwareness <FaultDomainType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDiskSupportedSize -StoragePoolName <String[]> [-ResiliencySettingName
  <String>] [-FaultDomainAwareness <FaultDomainType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-VirtualDiskSupportedSize -InputObject <CimInstance[]> [-ResiliencySettingName
  <String>] [-FaultDomainAwareness <FaultDomainType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
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
  -InputObject CimInstance[]:
    required: true
  -ResiliencySettingName,-Name String: ~
  -StoragePoolFriendlyName,-FriendlyName String[]:
    required: true
  -StoragePoolName String[]:
    required: true
  -StoragePoolUniqueId,-StoragePoolId,-UniqueId String[]:
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
