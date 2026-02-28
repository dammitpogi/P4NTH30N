description: Modifies a network event session
synopses:
- Set-NetEventSession [[-Name] <String[]>] [-CaptureMode <CaptureModes>] [-LocalFilePath
  <String>] [-MaxFileSize <UInt32>] [-MaxNumberOfBuffers <Byte>] [-TraceBufferSize
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventSession [-AssociatedEventProvider <CimInstance>] [-CaptureMode <CaptureModes>]
  [-LocalFilePath <String>] [-MaxFileSize <UInt32>] [-MaxNumberOfBuffers <Byte>] [-TraceBufferSize
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetEventSession -InputObject <CimInstance[]> [-CaptureMode <CaptureModes>] [-LocalFilePath
  <String>] [-MaxFileSize <UInt32>] [-MaxNumberOfBuffers <Byte>] [-TraceBufferSize
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedEventProvider CimInstance: ~
  -CaptureMode,-cm CaptureModes:
    values:
    - RealtimeRPC
    - SaveToFile
    - RealtimeLocal
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -LocalFilePath,-lfp String: ~
  -MaxFileSize UInt32: ~
  -MaxNumberOfBuffers Byte: ~
  -Name String[]: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -TraceBufferSize UInt32: ~
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
