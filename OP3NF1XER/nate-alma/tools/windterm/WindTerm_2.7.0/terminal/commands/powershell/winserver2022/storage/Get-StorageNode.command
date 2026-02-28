description: Gets storage nodes
synopses:
- Get-StorageNode [-Name <String[]>] [-OperationalStatus <OperationalStatus[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-UniqueId <String[]>] [-OperationalStatus <OperationalStatus[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-ObjectId <String[]>] [-OperationalStatus <OperationalStatus[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-Volume <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-VirtualDisk <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-PhysicalDisk <CimInstance>]
  [-PhysicallyConnected] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-StoragePool <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-StorageEnclosure <CimInstance>]
  [-PhysicallyConnected] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-StorageSubSystem <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageNode [-OperationalStatus <OperationalStatus[]>] [-Disk <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Disk CimInstance: ~
  -Name String[]: ~
  -ObjectId,-StorageNodeObjectId String[]: ~
  -OperationalStatus OperationalStatus[]:
    values:
    - Unknown
    - Up
    - Down
    - Joining
    - Paused
  -PhysicalDisk CimInstance: ~
  -PhysicallyConnected Switch: ~
  -StorageEnclosure CimInstance: ~
  -StoragePool CimInstance: ~
  -StorageSubSystem CimInstance: ~
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
