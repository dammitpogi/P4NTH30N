description: Gets the server features on a managed node
synopses:
- Get-SMServerFeature [-FilterFlag <FeatureFilterFlag>] [-BatchSize <UInt32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BatchSize UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -FilterFlag FeatureFilterFlag:
    values:
    - Available
    - Installed
    - UninstallPending
    - InstallPending
    - NotPresent
    - Removed
    - Unknown
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
