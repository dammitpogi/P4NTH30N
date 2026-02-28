description: Sets debugging and logging parameters
synopses:
- Set-DnsServerDiagnostics [-ComputerName <String>] [-PassThru] [-Answers <Boolean>]
  [-EventLogLevel <UInt32>] [-FullPackets <Boolean>] [-IPFilterList <IPAddress[]>]
  [-LogFilePath <String>] [-MaxMBFileSize <UInt32>] [-EnableLoggingForRemoteServerEvent
  <Boolean>] [-EnableLoggingForPluginDllEvent <Boolean>] [-UseSystemEventLog <Boolean>]
  [-EnableLogFileRollover <Boolean>] [-EnableLoggingForZoneLoadingEvent <Boolean>]
  [-EnableLoggingForLocalLookupEvent <Boolean>] [-EnableLoggingToFile <Boolean>] [-EnableLoggingForZoneDataWriteEvent
  <Boolean>] [-EnableLoggingForTombstoneEvent <Boolean>] [-EnableLoggingForRecursiveLookupEvent
  <Boolean>] [-UdpPackets <Boolean>] [-UnmatchedResponse <Boolean>] [-Updates <Boolean>]
  [-WriteThrough <Boolean>] [-SaveLogsToPersistentStorage <Boolean>] [-EnableLoggingForServerStartStopEvent
  <Boolean>] [-Notifications <Boolean>] [-Queries <Boolean>] [-QuestionTransactions
  <Boolean>] [-ReceivePackets <Boolean>] [-SendPackets <Boolean>] [-TcpPackets <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Set-DnsServerDiagnostics [-ComputerName <String>] [-PassThru] [-DebugLogging <UInt32>]
  [-OperationLogLevel2 <UInt32>] [-OperationLogLevel1 <UInt32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-DnsServerDiagnostics [-ComputerName <String>] [-PassThru] -All <Boolean> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Boolean:
    required: true
  -Answers Boolean: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DebugLogging UInt32: ~
  -EnableLogFileRollover Boolean: ~
  -EnableLoggingForLocalLookupEvent Boolean: ~
  -EnableLoggingForPluginDllEvent Boolean: ~
  -EnableLoggingForRecursiveLookupEvent Boolean: ~
  -EnableLoggingForRemoteServerEvent Boolean: ~
  -EnableLoggingForServerStartStopEvent Boolean: ~
  -EnableLoggingForTombstoneEvent Boolean: ~
  -EnableLoggingForZoneDataWriteEvent Boolean: ~
  -EnableLoggingForZoneLoadingEvent Boolean: ~
  -EnableLoggingToFile Boolean: ~
  -EventLogLevel UInt32: ~
  -FullPackets Boolean: ~
  -IPFilterList,-FilterIPAddressList IPAddress[]: ~
  -LogFilePath String: ~
  -MaxMBFileSize UInt32: ~
  -Notifications Boolean: ~
  -OperationLogLevel1 UInt32: ~
  -OperationLogLevel2 UInt32: ~
  -PassThru Switch: ~
  -Queries Boolean: ~
  -QuestionTransactions Boolean: ~
  -ReceivePackets Boolean: ~
  -SaveLogsToPersistentStorage Boolean: ~
  -SendPackets Boolean: ~
  -TcpPackets Boolean: ~
  -ThrottleLimit Int32: ~
  -UdpPackets Boolean: ~
  -UnmatchedResponse Boolean: ~
  -Updates Boolean: ~
  -UseSystemEventLog Boolean: ~
  -WhatIf,-wi Switch: ~
  -WriteThrough Boolean: ~
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
