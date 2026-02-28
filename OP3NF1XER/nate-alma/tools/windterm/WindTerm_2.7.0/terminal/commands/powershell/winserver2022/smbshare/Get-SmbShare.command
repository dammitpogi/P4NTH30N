description: Retrieves the SMB shares on the computer
synopses:
- Get-SmbShare [[-Name] <String[]>] [[-ScopeName] <String[]>] [-Scoped <Boolean[]>]
  [-Special <Boolean[]>] [-ContinuouslyAvailable <Boolean[]>] [-ShareState <ShareState[]>]
  [-FolderEnumerationMode <FolderEnumerationMode[]>] [-CachingMode <CachingMode[]>]
  [-LeasingMode <LeasingMode[]>] [-ConcurrentUserLimit <UInt32[]>] [-AvailabilityType
  <AvailabilityType[]>] [-CaTimeout <UInt32[]>] [-EncryptData <Boolean[]>] [-CompressData
  <Boolean[]>] [-IncludeHidden] [-SmbInstance <SmbInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AvailabilityType AvailabilityType[]:
    values:
    - NonClustered
    - Clustered
    - ScaleOut
    - CSV
    - DFS
  -CaTimeout UInt32[]: ~
  -CachingMode CachingMode[]:
    values:
    - None
    - Manual
    - Documents
    - Programs
    - BranchCache
    - Unknown
  -CimSession,-Session CimSession[]: ~
  -CompressData Boolean[]: ~
  -ConcurrentUserLimit UInt32[]: ~
  -ContinuouslyAvailable Boolean[]: ~
  -EncryptData Boolean[]: ~
  -FolderEnumerationMode FolderEnumerationMode[]:
    values:
    - AccessBased
    - Unrestricted
  -IncludeHidden Switch: ~
  -LeasingMode LeasingMode[]: ~
  -Name String[]: ~
  -ScopeName String[]: ~
  -Scoped Boolean[]: ~
  -ShareState ShareState[]:
    values:
    - Pending
    - Online
    - Offline
  -SmbInstance SmbInstance:
    values:
    - Default
    - CSV
    - SBL
    - SR
  -Special Boolean[]: ~
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
