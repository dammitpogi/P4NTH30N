description: Disconnects from storage subsystems on a remote computer
synopses:
- Unregister-StorageSubsystem [-ProviderName] <String[]> [-StorageSubSystemUniqueId
  <String>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Unregister-StorageSubsystem -ProviderUniqueId <String[]> [-StorageSubSystemUniqueId
  <String>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Unregister-StorageSubsystem -InputObject <CimInstance[]> [-StorageSubSystemUniqueId
  <String>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -ProviderName String[]:
    required: true
  -ProviderUniqueId,-ProviderId String[]:
    required: true
  -StorageSubSystemUniqueId,-UniqueId String: ~
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
