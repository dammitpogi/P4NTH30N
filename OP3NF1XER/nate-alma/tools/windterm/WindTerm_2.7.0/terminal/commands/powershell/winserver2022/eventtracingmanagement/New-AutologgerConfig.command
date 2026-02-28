description: Creates an Autologger session configuration in the registry
synopses:
- New-AutologgerConfig -Name <String> [-BufferSize <UInt32>] [-ClockType <ClockType>]
  [-DisableRealtimePersistence <UInt32>] [-FileCount <UInt32>] [-LocalFilePath <String>]
  [-FileMax <UInt32>] [-FlushTimer <UInt32>] [-Guid <String>] [-LogFileMode <UInt32>]
  [-MaximumFileSize <UInt32>] [-MaximumBuffers <UInt32>] [-MinimumBuffers <UInt32>]
  [-Start <Enabled>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -DisableRealtimePersistence UInt32: ~
  -FileCount UInt32: ~
  -FileMax UInt32: ~
  -FlushTimer UInt32: ~
  -Guid String: ~
  -LocalFilePath String: ~
  -LogFileMode UInt32: ~
  -MaximumBuffers UInt32: ~
  -MaximumFileSize UInt32: ~
  -MinimumBuffers UInt32: ~
  -Name String:
    required: true
  -Start Enabled:
    values:
    - Disabled
    - Enabled
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
