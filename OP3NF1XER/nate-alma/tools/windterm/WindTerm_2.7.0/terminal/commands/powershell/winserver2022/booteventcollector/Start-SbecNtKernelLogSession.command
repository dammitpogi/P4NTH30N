description: Starts an NT Kernel Logger log session with forwarding of events to the
  Collector
synopses:
- Start-SbecNtKernelLogSession [[-ClockType] <ClientContext>] [[-BufferSize] <UInt32>]
  [[-MinimumBufferCount] <UInt32>] [[-MaximumBufferCount] <UInt32>] [[-FlushSeconds]
  <UInt32>] [[-KernelEnableFlags] <EventTraceFlag>] [-PassThru] [<CommonParameters>]
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
  -MaximumBufferCount,-MaximumBuffers,-maxbuf UInt32: ~
  -MinimumBufferCount,-MinimumBuffers,-minbuf UInt32: ~
  -PassThru Switch: ~
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
