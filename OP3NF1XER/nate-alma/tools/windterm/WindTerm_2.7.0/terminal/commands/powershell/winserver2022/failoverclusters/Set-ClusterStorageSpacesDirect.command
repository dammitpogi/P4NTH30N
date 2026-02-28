description: Sets S2D cache parameters
synopses:
- Set-ClusterStorageSpacesDirect [-CacheState <CacheStateType>] [-CacheModeHDD <CacheModeType>]
  [-CacheModeSSD <CacheModeType>] [-Nodes <String[]>] [-SkipEligibilityChecks] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CacheModeHDD CacheModeType:
    values:
    - ReadOnly
    - WriteOnly
    - ReadWrite
  -CacheModeSSD CacheModeType:
    values:
    - ReadOnly
    - WriteOnly
    - ReadWrite
  -CacheState CacheStateType:
    values:
    - Disabled
    - Enabled
  -CimSession,-Session CimSession[]: ~
  -Nodes String[]: ~
  -SkipEligibilityChecks Switch: ~
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
