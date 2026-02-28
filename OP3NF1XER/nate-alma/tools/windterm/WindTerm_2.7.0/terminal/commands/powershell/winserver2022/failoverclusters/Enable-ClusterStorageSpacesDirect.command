description: Enables Storage Spaces Direct on a Fail-Over Cluster
synopses:
- Enable-ClusterStorageSpacesDirect [-PoolFriendlyName <String>] [-Autoconfig <Boolean>]
  [-CacheState <CacheStateType>] [-CacheMetadataReserveBytes <UInt64>] [-CachePageSizeKBytes
  <UInt32>] [-SkipEligibilityChecks] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-ClusterStorageSpacesDirect [-PoolFriendlyName <String>] [-Autoconfig <Boolean>]
  [-CacheState <CacheStateType>] [-CacheMetadataReserveBytes <UInt64>] [-CachePageSizeKBytes
  <UInt32>] [-SkipEligibilityChecks] -XML <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Enable-ClusterStorageSpacesDirect [-PoolFriendlyName <String>] [-Autoconfig <Boolean>]
  [-CacheState <CacheStateType>] [-CacheMetadataReserveBytes <UInt64>] [-CachePageSizeKBytes
  <UInt32>] [-SkipEligibilityChecks] -CacheDeviceModel <String[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Autoconfig Boolean: ~
  -CacheDeviceModel String[]:
    required: true
  -CacheMetadataReserveBytes UInt64: ~
  -CachePageSizeKBytes UInt32:
    values:
    - '8'
    - '16'
    - '32'
    - '64'
  -CacheState CacheStateType:
    values:
    - Disabled
    - Enabled
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -PoolFriendlyName String: ~
  -SkipEligibilityChecks Switch: ~
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
  -XML String:
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
