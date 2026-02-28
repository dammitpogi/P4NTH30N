description: Gets Storage diagnostic information
synopses:
- Get-StorageDiagnosticInfo -InputObject <CimInstance> -DestinationPath <String> [-TimeSpan
  <UInt32>] [-ActivityId <String>] [-ExcludeOperationalLog] [-ExcludeDiagnosticLog]
  [-IncludeLiveDump] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StorageDiagnosticInfo [-StorageSubSystemFriendlyName] <String> -DestinationPath
  <String> [-TimeSpan <UInt32>] [-ActivityId <String>] [-ExcludeOperationalLog] [-ExcludeDiagnosticLog]
  [-IncludeLiveDump] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StorageDiagnosticInfo -StorageSubSystemName <String> -DestinationPath <String>
  [-TimeSpan <UInt32>] [-ActivityId <String>] [-ExcludeOperationalLog] [-ExcludeDiagnosticLog]
  [-IncludeLiveDump] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-StorageDiagnosticInfo -StorageSubSystemUniqueId <String> -DestinationPath <String>
  [-TimeSpan <UInt32>] [-ActivityId <String>] [-ExcludeOperationalLog] [-ExcludeDiagnosticLog]
  [-IncludeLiveDump] [-CimSession <CimSession>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -ActivityId String: ~
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -DestinationPath,-Path String:
    required: true
  -ExcludeDiagnosticLog Switch: ~
  -ExcludeOperationalLog Switch: ~
  -IncludeLiveDump Switch: ~
  -InputObject CimInstance:
    required: true
  -StorageSubSystemFriendlyName String:
    required: true
  -StorageSubSystemName String:
    required: true
  -StorageSubSystemUniqueId,-StorageSubSystemId String:
    required: true
  -ThrottleLimit Int32: ~
  -TimeSpan UInt32: ~
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
