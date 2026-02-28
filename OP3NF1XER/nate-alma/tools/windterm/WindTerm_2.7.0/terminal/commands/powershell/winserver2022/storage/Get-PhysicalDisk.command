description: Gets a list of all PhysicalDisk objects visible across any available
  Storage Management Providers, or optionally a filtered list
synopses:
- Get-PhysicalDisk [-UniqueId <String>] [-Usage <PhysicalDiskUsage>] [-Description
  <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>] [-HealthStatus
  <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk [-ObjectId <String>] [-Usage <PhysicalDiskUsage>] [-Description
  <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>] [-HealthStatus
  <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk [[-FriendlyName] <String>] [[-SerialNumber] <String>] [-Usage <PhysicalDiskUsage>]
  [-Description <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>]
  [-HealthStatus <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -InputObject <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -StorageSubsystem <CimInstance> [-Usage <PhysicalDiskUsage>] [-Description
  <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>] [-HealthStatus
  <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -StorageEnclosure <CimInstance> [-Usage <PhysicalDiskUsage>] [-Description
  <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>] [-HealthStatus
  <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -StorageNode <CimInstance> [-PhysicallyConnected] [-Usage <PhysicalDiskUsage>]
  [-Description <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>]
  [-HealthStatus <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -StoragePool <CimInstance> [-Usage <PhysicalDiskUsage>] [-Description
  <String>] [-Manufacturer <String>] [-Model <String>] [-CanPool <Boolean>] [-HealthStatus
  <PhysicalDiskHealthStatus>] [-CimSession <CimSession>] [<CommonParameters>]
- Get-PhysicalDisk -VirtualDisk <CimInstance> [-VirtualRangeMin <UInt64>] [-VirtualRangeMax
  <UInt64>] [-HasAllocations <Boolean>] [-SelectedForUse <Boolean>] [-NoRedundancy]
  [-Usage <PhysicalDiskUsage>] [-Description <String>] [-Manufacturer <String>] [-Model
  <String>] [-CanPool <Boolean>] [-HealthStatus <PhysicalDiskHealthStatus>] [-CimSession
  <CimSession>] [<CommonParameters>]
options:
  -CanPool Boolean: ~
  -CimSession CimSession: ~
  -Description String: ~
  -FriendlyName String: ~
  -HasAllocations Boolean: ~
  -HealthStatus PhysicalDiskHealthStatus:
    values:
    - Healthy
    - Warning
    - Unhealthy
    - Unknown
  -InputObject CimInstance:
    required: true
  -Manufacturer String: ~
  -Model String: ~
  -NoRedundancy Switch: ~
  -ObjectId,-PhysicalDiskObjectId String: ~
  -PhysicallyConnected Switch: ~
  -SelectedForUse Boolean: ~
  -SerialNumber String: ~
  -StorageEnclosure CimInstance:
    required: true
  -StorageNode CimInstance:
    required: true
  -StoragePool CimInstance:
    required: true
  -StorageSubsystem CimInstance:
    required: true
  -UniqueId,-Id String: ~
  -Usage PhysicalDiskUsage:
    values:
    - Unknown
    - AutoSelect
    - ManualSelect
    - HotSpare
    - Retired
    - Journal
  -VirtualDisk CimInstance:
    required: true
  -VirtualRangeMax UInt64: ~
  -VirtualRangeMin UInt64: ~
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
