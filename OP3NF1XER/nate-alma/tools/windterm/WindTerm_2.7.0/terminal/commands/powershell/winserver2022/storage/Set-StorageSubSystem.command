description: Modifies the properties of a StorageSubSystem object
synopses:
- Set-StorageSubSystem [-Description <String>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem [-InputObject] <CimInstance[]> [-AutomaticClusteringEnabled
  <Boolean>] [-FaultDomainAwarenessDefault <FaultDomainType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem [-InputObject] <CimInstance[]> [-Description <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem [-Description <String>] -Name <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem [-Description <String>] [-FriendlyName] <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem -UniqueId <String> [-AutomaticClusteringEnabled <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem [-FriendlyName] <String> [-AutomaticClusteringEnabled <Boolean>]
  [-FaultDomainAwarenessDefault <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-StorageSubSystem -Name <String> [-AutomaticClusteringEnabled <Boolean>] [-FaultDomainAwarenessDefault
  <FaultDomainType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AutomaticClusteringEnabled Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -Description String: ~
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
  -Name String:
    required: true
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
