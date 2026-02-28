description: Modifies whether to enable the SMP provider cache
synopses:
- Set-StorageProvider [-ProviderName] <String[]> [-RemoteSubsystemCacheMode <RemoteSubsystemCacheMode>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-StorageProvider -ProviderUniqueId <String[]> [-RemoteSubsystemCacheMode <RemoteSubsystemCacheMode>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Set-StorageProvider -InputObject <CimInstance[]> [-RemoteSubsystemCacheMode <RemoteSubsystemCacheMode>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -ProviderName String[]:
    required: true
  -ProviderUniqueId,-ProviderId String[]:
    required: true
  -RemoteSubsystemCacheMode RemoteSubsystemCacheMode:
    values:
    - Disabled
    - ManualDiscovery
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
