description: Updates the settings for a log session
synopses:
- Set-SbecLogSession -Session <TraceSessionInfo[]> [-Path <Object>] [-ClockType <Object>]
  [-BufferSize <Object>] [-MinimumBufferCount <UInt32>] [-MaximumBufferCount <UInt32>]
  [-MaximumFileSize <Object>] [-FlushSeconds <UInt32>] [-LogFileMode <Object>] [-KernelEnableFlags
  <Object>] [-EnableKd] [-DisableKd] [-SimulateError <Int32>] [<CommonParameters>]
- Set-SbecLogSession -Name <String[]> [-Path <Object>] [-ClockType <Object>] [-BufferSize
  <Object>] [-MinimumBufferCount <UInt32>] [-MaximumBufferCount <UInt32>] [-MaximumFileSize
  <Object>] [-FlushSeconds <UInt32>] [-LogFileMode <Object>] [-KernelEnableFlags <Object>]
  [-EnableKd] [-DisableKd] [-SimulateError <Int32>] [<CommonParameters>]
options:
  -BufferSize Object: ~
  -ClockType Object: ~
  -DisableKd Switch: ~
  -EnableKd Switch: ~
  -FlushSeconds,-FlushTimer UInt32: ~
  -KernelEnableFlags Object: ~
  -LogFileMode Object: ~
  -MaximumBufferCount,-MaximumBuffers,-maxbuf UInt32: ~
  -MaximumFileSize Object: ~
  -MinimumBufferCount,-MinimumBuffers,-minbuf UInt32: ~
  -Name String[]:
    required: true
  -Path Object: ~
  -Session TraceSessionInfo[]:
    required: true
  -SimulateError Int32: ~
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
