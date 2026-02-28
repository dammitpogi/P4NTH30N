description: Starts an ETW session with the specified name and settings
synopses:
- Start-EtwTraceSession [-Name] <String> [-LogFileMode <UInt32>] [-LocalFilePath <String>]
  [-MaximumFileSize <UInt32>] [-BufferSize <UInt32>] [-MinimumBuffers <UInt32>] [-MaximumBuffers
  <UInt32>] [-FlushTimer <UInt32>] [-ClockType <String>] [-FileMode <String>] [-Compress]
  [-RealTime] [-NonPaged] [-CimSession <CimSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BufferSize UInt32: ~
  -CimSession CimSession: ~
  -ClockType String:
    values:
    - Performance
    - System
    - Cycle
  -Compress Switch: ~
  -Confirm,-cf Switch: ~
  -FileMode String:
    values:
    - File
    - Buffering
    - Sequential
    - Circular
  -FlushTimer UInt32: ~
  -LocalFilePath String: ~
  -LogFileMode UInt32: ~
  -MaximumBuffers UInt32: ~
  -MaximumFileSize UInt32: ~
  -MinimumBuffers UInt32: ~
  -Name String:
    required: true
  -NonPaged Switch: ~
  -RealTime Switch: ~
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
