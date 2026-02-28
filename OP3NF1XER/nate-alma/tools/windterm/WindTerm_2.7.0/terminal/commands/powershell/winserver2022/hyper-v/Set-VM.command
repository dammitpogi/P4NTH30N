description: Configures a virtual machine
synopses:
- Set-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Name] <String[]> [-GuestControlledCacheTypes <Boolean>] [-LowMemoryMappedIoSpace
  <UInt32>] [-HighMemoryMappedIoSpace <UInt64>] [-ProcessorCount <Int64>] [-DynamicMemory]
  [-StaticMemory] [-MemoryMinimumBytes <Int64>] [-MemoryMaximumBytes <Int64>] [-MemoryStartupBytes
  <Int64>] [-AutomaticStartAction <StartAction>] [-AutomaticStopAction <StopAction>]
  [-AutomaticStartDelay <Int32>] [-AutomaticCriticalErrorAction <CriticalErrorAction>]
  [-AutomaticCriticalErrorActionTimeout <Int32>] [-AutomaticCheckpointsEnabled <Boolean>]
  [-LockOnDisconnect <OnOffState>] [-Notes <String>] [-NewVMName <String>] [-SnapshotFileLocation
  <String>] [-SmartPagingFilePath <String>] [-CheckpointType <CheckpointType>] [-Passthru]
  [-AllowUnverifiedPaths] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VM [-VM] <VirtualMachine[]> [-GuestControlledCacheTypes <Boolean>] [-LowMemoryMappedIoSpace
  <UInt32>] [-HighMemoryMappedIoSpace <UInt64>] [-ProcessorCount <Int64>] [-DynamicMemory]
  [-StaticMemory] [-MemoryMinimumBytes <Int64>] [-MemoryMaximumBytes <Int64>] [-MemoryStartupBytes
  <Int64>] [-AutomaticStartAction <StartAction>] [-AutomaticStopAction <StopAction>]
  [-AutomaticStartDelay <Int32>] [-AutomaticCriticalErrorAction <CriticalErrorAction>]
  [-AutomaticCriticalErrorActionTimeout <Int32>] [-AutomaticCheckpointsEnabled <Boolean>]
  [-LockOnDisconnect <OnOffState>] [-Notes <String>] [-NewVMName <String>] [-SnapshotFileLocation
  <String>] [-SmartPagingFilePath <String>] [-CheckpointType <CheckpointType>] [-Passthru]
  [-AllowUnverifiedPaths] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowUnverifiedPaths Switch: ~
  -AutomaticCheckpointsEnabled Boolean: ~
  -AutomaticCriticalErrorAction CriticalErrorAction:
    values:
    - None
    - Pause
  -AutomaticCriticalErrorActionTimeout Int32: ~
  -AutomaticStartAction StartAction:
    values:
    - Nothing
    - StartIfRunning
    - Start
  -AutomaticStartDelay Int32: ~
  -AutomaticStopAction StopAction:
    values:
    - TurnOff
    - Save
    - ShutDown
  -CheckpointType CheckpointType:
    values:
    - Disabled
    - Production
    - ProductionOnly
    - Standard
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DynamicMemory Switch: ~
  -GuestControlledCacheTypes Boolean: ~
  -HighMemoryMappedIoSpace UInt64: ~
  -LockOnDisconnect OnOffState:
    values:
    - On
    - Off
  -LowMemoryMappedIoSpace UInt32: ~
  -MemoryMaximumBytes Int64: ~
  -MemoryMinimumBytes Int64: ~
  -MemoryStartupBytes Int64: ~
  -Name,-VMName String[]:
    required: true
  -NewVMName String: ~
  -Notes String: ~
  -Passthru Switch: ~
  -ProcessorCount Int64: ~
  -SmartPagingFilePath String: ~
  -SnapshotFileLocation String: ~
  -StaticMemory Switch: ~
  -VM VirtualMachine[]:
    required: true
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
