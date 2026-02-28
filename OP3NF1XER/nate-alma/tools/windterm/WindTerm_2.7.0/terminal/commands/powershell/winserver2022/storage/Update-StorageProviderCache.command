description: Updates the cache of the service for a particular provider and associated
  child objects
synopses:
- Update-StorageProviderCache [[-Name] <String[]>] [-Manufacturer <String[]>] [-DiscoveryLevel
  <DiscoveryLevel>] [-RootObject <PSReference>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Update-StorageProviderCache [-UniqueId <String[]>] [-DiscoveryLevel <DiscoveryLevel>]
  [-RootObject <PSReference>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
- Update-StorageProviderCache [-Manufacturer <String[]>] [-URI <Uri[]>] [-DiscoveryLevel
  <DiscoveryLevel>] [-RootObject <PSReference>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Update-StorageProviderCache [-StorageSubSystem <CimInstance>] [-DiscoveryLevel <DiscoveryLevel>]
  [-RootObject <PSReference>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
- Update-StorageProviderCache -InputObject <CimInstance[]> [-DiscoveryLevel <DiscoveryLevel>]
  [-RootObject <PSReference>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DiscoveryLevel DiscoveryLevel:
    values:
    - Level0
    - Level1
    - Level2
    - Level3
    - Full
  -InputObject CimInstance[]:
    required: true
  -Manufacturer String[]: ~
  -Name String[]: ~
  -PassThru Switch: ~
  -RootObject PSReference: ~
  -StorageSubSystem CimInstance: ~
  -ThrottleLimit Int32: ~
  -URI Uri[]: ~
  -UniqueId,-Id String[]: ~
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
