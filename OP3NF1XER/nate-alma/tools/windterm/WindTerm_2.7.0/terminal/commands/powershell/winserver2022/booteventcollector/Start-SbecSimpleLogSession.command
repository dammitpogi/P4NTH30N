description: Starts a log session with the forwarding of events to the Collector
synopses:
- Start-SbecSimpleLogSession [-Name] <String> [[-SessionGuid] <Guid>] [[-ProviderName]
  <String[]>] [[-ProviderGuid] <Guid[]>] [[-Level] <SeverityLevel>] [[-ClockType]
  <ClientContext>] [[-BufferSize] <UInt32>] [[-MinimumBufferCount] <UInt32>] [[-MaximumBufferCount]
  <UInt32>] [[-FlushSeconds] <UInt32>] [[-LogFileMode] <LoggingMode>] [[-KernelEnableFlags]
  <EventTraceFlag>] [-PassThru] [<CommonParameters>]
options:
  -BufferSize UInt32: ~
  -ClockType ClientContext:
    values:
    - Default
    - QueryPerformanceCounter
    - SystemTime
    - CpuCycleCounter
  -FlushSeconds,-FlushTimer UInt32: ~
  -KernelEnableFlags EventTraceFlag:
    values:
    - None
    - Process
    - Thread
    - ImageLoad
    - ProcessCounters
    - ContextSwitch
    - Dpc
    - Interrupt
    - SystemCall
    - DiskIO
    - DiskFileIO
    - DiskIOInit
    - Dispatcher
    - MemoryPageFaults
    - MemoryHardFaults
    - VirtualAlloc
    - NetworkTCPIP
    - Registry
    - Alpc
    - SplitIO
    - Driver
    - FileIO
    - FileIOInit
    - Profile
  -Level SeverityLevel:
    values:
    - Undefined
    - Fatal
    - Error
    - Warning
    - Information
    - Verbose
    - All
  -LogFileMode LoggingMode:
    values:
    - None
    - FileNone
    - FileSequential
    - FileCircular
    - FileAppend
    - FileNewFile
    - Reserved0x00000010
    - FilePreallocate
    - Nonstoppable
    - Secure
    - RealTime
    - DelayOpenFile
    - Buffering
    - PrivateLogger
    - AddHeader
    - UseKilobytesForSize
    - UseGlobalSequence
    - UseLocalSequence
    - Relog
    - PrivateInProc
    - BufferInterface
    - KdFilter
    - RealtimeRelog
    - LostEventsDebug
    - StopOnHybridShutdown
    - PersistOnHybridShutdown
    - UsePagedMemory
    - SystemLogger
    - Compressed
    - IndependentSession
    - NoPerProcessorBuffering
    - Blocking
    - Reserved0x40000000
    - AddToTriageDump
  -MaximumBufferCount,-MaximumBuffers,-maxbuf UInt32: ~
  -MinimumBufferCount,-MinimumBuffers,-minbuf UInt32: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -ProviderGuid,-pg Guid[]: ~
  -ProviderName,-pn String[]: ~
  -SessionGuid Guid: ~
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
