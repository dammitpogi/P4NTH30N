description: Gets one or more StorageSubSystem objects
synopses:
- Get-StorageSubSystem [[-FriendlyName] <String[]>] [-HealthStatus <HealthStatus[]>]
  [-Manufacturer <String[]>] [-Model <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-UniqueId <String[]>] [-HealthStatus <HealthStatus[]>] [-Manufacturer
  <String[]>] [-Model <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-Name <String[]>] [-HealthStatus <HealthStatus[]>] [-Manufacturer
  <String[]>] [-Model <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-StorageFaultDomain <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-FileServer <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-Volume <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-Partition <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-Disk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-OffloadDataTransferSetting <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-InitiatorId <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-TargetPortal <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-TargetPort <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-MaskingSet <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-VirtualDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-StoragePool <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-StorageNode <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageSubSystem [-HealthStatus <HealthStatus[]>] [-Manufacturer <String[]>]
  [-Model <String[]>] [-StorageProvider <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Disk CimInstance: ~
  -FileServer CimInstance: ~
  -FriendlyName String[]: ~
  -HealthStatus HealthStatus[]:
    values:
    - Healthy
    - Warning
    - Unhealthy
  -InitiatorId CimInstance: ~
  -Manufacturer String[]: ~
  -MaskingSet CimInstance: ~
  -Model String[]: ~
  -Name String[]: ~
  -OffloadDataTransferSetting CimInstance: ~
  -Partition CimInstance: ~
  ? -StorageFaultDomain,-PhysicalDisk,-StorageEnclosure,-StorageScaleUnit,-StorageChassis,-StorageRack,-StorageSite
    CimInstance
  : ~
  -StorageNode CimInstance: ~
  -StoragePool CimInstance: ~
  -StorageProvider CimInstance: ~
  -TargetPort CimInstance: ~
  -TargetPortal CimInstance: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]: ~
  -VirtualDisk CimInstance: ~
  -Volume CimInstance: ~
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
