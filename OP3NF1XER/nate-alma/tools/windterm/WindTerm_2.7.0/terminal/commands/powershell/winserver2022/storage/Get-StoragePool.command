description: Gets a specific storage pool, or a set of StoragePool objects either
  from all storage subsystems across all storage providers, or optionally a filtered
  subset based on specific parameters
synopses:
- Get-StoragePool [[-FriendlyName] <String[]>] [-Usage <Usage[]>] [-IsPrimordial <Boolean[]>]
  [-HealthStatus <HealthStatus[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-StoragePool [-UniqueId <String[]>] [-IsPrimordial <Boolean[]>] [-HealthStatus
  <HealthStatus[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StoragePool [-Name <String[]>] [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-Usage <Usage[]>] [-OtherUsageDescription <String[]>] [-IsPrimordial
  <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageJob
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-Volume
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageTier
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-ResiliencySetting
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-VirtualDisk
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-PhysicalDisk
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageNode
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StoragePool [-IsPrimordial <Boolean[]>] [-HealthStatus <HealthStatus[]>] [-StorageSubSystem
  <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FriendlyName String[]: ~
  -HealthStatus HealthStatus[]:
    values:
    - Healthy
    - Warning
    - Unhealthy
    - Unknown
  -IsPrimordial Boolean[]: ~
  -Name String[]: ~
  -OtherUsageDescription String[]: ~
  -PhysicalDisk CimInstance: ~
  -ResiliencySetting CimInstance: ~
  -StorageJob CimInstance: ~
  -StorageNode CimInstance: ~
  -StorageSubSystem CimInstance: ~
  -StorageTier CimInstance: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]: ~
  -Usage Usage[]:
    values:
    - Unknown
    - Other
    - Unrestricted
    - ReservedForComputerSystem
    - ReservedAsDeltaReplicaContainer
    - ReservedForMigrationServices
    - ReservedForLocalReplicationServices
    - ReservedForRemoteReplicationServices
    - ReservedForSparing
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
