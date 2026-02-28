description: Creates an ETW trace session
synopses:
- New-EtwTraceSession [-Name] <String> [-LogFileMode <UInt32>] [-LocalFilePath <String>]
  [-MaximumFileSize <UInt32>] [-BufferSize <UInt32>] [-MinimumBuffers <UInt32>] [-MaximumBuffers
  <UInt32>] [-FlushTimer <UInt32>] [-ClockType <ClockType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -LocalFilePath String: ~
  -LogFileMode UInt32: ~
  -MaximumBuffers UInt32: ~
  -MaximumFileSize UInt32: ~
  -MinimumBuffers UInt32: ~
  -Name String:
    required: true
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
