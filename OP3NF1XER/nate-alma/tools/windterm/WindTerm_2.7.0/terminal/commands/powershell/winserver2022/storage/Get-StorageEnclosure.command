description: Gets storage enclosures
synopses:
- Get-StorageEnclosure [-UniqueId <String[]>] [-Manufacturer <String[]>] [-Model <String[]>]
  [-HealthStatus <HealthStatus[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-StorageEnclosure [[-FriendlyName] <String[]>] [[-SerialNumber] <String[]>] [-Manufacturer
  <String[]>] [-Model <String[]>] [-HealthStatus <HealthStatus[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageEnclosure [-Manufacturer <String[]>] [-Model <String[]>] [-HealthStatus
  <HealthStatus[]>] [-PhysicalDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageEnclosure [-Manufacturer <String[]>] [-Model <String[]>] [-HealthStatus
  <HealthStatus[]>] [-StorageNode <CimInstance>] [-PhysicallyConnected] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageEnclosure [-Manufacturer <String[]>] [-Model <String[]>] [-HealthStatus
  <HealthStatus[]>] [-StorageSubSystem <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
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
  -Manufacturer String[]: ~
  -Model String[]: ~
  -PhysicalDisk CimInstance: ~
  -PhysicallyConnected Switch: ~
  -SerialNumber String[]: ~
  -StorageNode CimInstance: ~
  -StorageSubSystem CimInstance: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]: ~
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
