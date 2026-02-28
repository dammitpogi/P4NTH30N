description: Returns information about long-running Storage module jobs, such as a
  repair task
synopses:
- Get-StorageJob [<CommonParameters>]
- Get-StorageJob [-UniqueId <String[]>] [-JobState <JobState[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageJob [-Name <String[]>] [-JobState <JobState[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageJob [-Name <String[]>] [-JobState <JobState[]>] [-StoragePool <CimInstance>]
  [-VirtualDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-StorageJob [-JobState <JobState[]>] [-Volume <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageJob [-JobState <JobState[]>] [-Disk <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-StorageJob [-JobState <JobState[]>] [-StorageSubsystem <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Disk CimInstance: ~
  -JobState JobState[]:
    values:
    - New
    - Starting
    - Running
    - Suspended
    - ShuttingDown
    - Completed
    - Terminated
    - Killed
    - Exception
    - Service
    - QueryPending
  -Name String[]: ~
  -StoragePool CimInstance: ~
  -StorageSubsystem CimInstance: ~
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
