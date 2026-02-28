description: Starts Storage diagnostic logging
synopses:
- Start-StorageDiagnosticLog [-StorageSubSystemFriendlyName] <String[]> [-Level <Level>]
  [-MaxLogSize <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Start-StorageDiagnosticLog -StorageSubSystemUniqueId <String[]> [-Level <Level>]
  [-MaxLogSize <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Start-StorageDiagnosticLog -StorageSubSystemName <String[]> [-Level <Level>] [-MaxLogSize
  <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [<CommonParameters>]
- Start-StorageDiagnosticLog -InputObject <CimInstance[]> [-Level <Level>] [-MaxLogSize
  <UInt64>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InputObject CimInstance[]:
    required: true
  -Level Level:
    values:
    - Critical
    - Error
    - Warning
    - Informational
    - Verbose
  -MaxLogSize UInt64: ~
  -PassThru Switch: ~
  -StorageSubSystemFriendlyName String[]:
    required: true
  -StorageSubSystemName String[]:
    required: true
  -StorageSubSystemUniqueId,-StorageSubsystemId String[]:
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
