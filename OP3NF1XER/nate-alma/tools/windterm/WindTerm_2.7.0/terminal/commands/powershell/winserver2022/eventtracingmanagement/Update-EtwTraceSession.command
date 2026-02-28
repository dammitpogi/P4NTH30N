description: Modifies an existing ETW session
synopses:
- Update-EtwTraceSession [-Name] <String[]> [-LogFileMode <UInt32>] [-LocalFilePath
  <String>] [-MaximumFileSize <UInt32>] [-BufferSize <UInt32>] [-MaximumBuffers <UInt32>]
  [-FlushTimer <UInt32>] [-ClockType <ClockType>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-EtwTraceSession -InputObject <CimInstance[]> [-LogFileMode <UInt32>] [-LocalFilePath
  <String>] [-MaximumFileSize <UInt32>] [-BufferSize <UInt32>] [-MaximumBuffers <UInt32>]
  [-FlushTimer <UInt32>] [-ClockType <ClockType>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BufferSize UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -ClockType ClockType:
    values:
    - Performance
    - System
    - Cycle
  -Confirm,-cf Switch: ~
  -FlushTimer UInt32: ~
  -InputObject CimInstance[]:
    required: true
  -LocalFilePath String: ~
  -LogFileMode UInt32: ~
  -MaximumBuffers UInt32: ~
  -MaximumFileSize UInt32: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
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
