description: Finds problems with a storage subsystem and recommends solutions
synopses:
- Debug-StorageSubSystem [-StorageSubSystemFriendlyName] <String[]> [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Debug-StorageSubSystem -StorageSubSystemUniqueId <String[]> [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Debug-StorageSubSystem -StorageSubSystemName <String[]> [-CimSession <CimSession>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Debug-StorageSubSystem -InputObject <CimInstance> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -InputObject CimInstance:
    required: true
  -StorageSubSystemFriendlyName String[]:
    required: true
  -StorageSubSystemName String[]:
    required: true
  -StorageSubSystemUniqueId String[]:
    required: true
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
