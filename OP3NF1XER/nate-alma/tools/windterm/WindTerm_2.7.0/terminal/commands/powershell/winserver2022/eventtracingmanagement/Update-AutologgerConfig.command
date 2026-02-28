description: Modifies an existing AutoLogger session configuration
synopses:
- Update-AutologgerConfig [-Name] <String[]> [-BufferSize <UInt32>] [-ClockType <ClockType>]
  [-DisableRealtimePersistence <UInt32>] [-LocalFilePath <String>] [-FileMax <UInt32>]
  [-FlushTimer <UInt32>] [-Guid <String>] [-LogFileMode <UInt32>] [-MaximumFileSize
  <UInt32>] [-MaximumBuffers <UInt32>] [-MinimumBuffers <UInt32>] [-Start <UInt32>]
  [-InitStatus <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-AutologgerConfig -InputObject <CimInstance[]> [-BufferSize <UInt32>] [-ClockType
  <ClockType>] [-DisableRealtimePersistence <UInt32>] [-LocalFilePath <String>] [-FileMax
  <UInt32>] [-FlushTimer <UInt32>] [-Guid <String>] [-LogFileMode <UInt32>] [-MaximumFileSize
  <UInt32>] [-MaximumBuffers <UInt32>] [-MinimumBuffers <UInt32>] [-Start <UInt32>]
  [-InitStatus <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BufferSize UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -ClockType ClockType:
    values:
    - Performance
    - System
    - Cycle
  -DisableRealtimePersistence UInt32: ~
  -FileMax UInt32: ~
  -FlushTimer UInt32: ~
  -Guid String: ~
  -InitStatus UInt32: ~
  -InputObject CimInstance[]:
    required: true
  -LocalFilePath String: ~
  -LogFileMode UInt32: ~
  -MaximumBuffers UInt32: ~
  -MaximumFileSize UInt32: ~
  -MinimumBuffers UInt32: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -Start UInt32: ~
  -ThrottleLimit Int32: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
