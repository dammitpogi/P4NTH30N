description: Adds a hard disk drive to a virtual machine
synopses:
- Add-VMHardDiskDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [[-ControllerType] <ControllerType>] [[-ControllerNumber]
  <Int32>] [[-ControllerLocation] <Int32>] [[-Path] <String>] [-DiskNumber <UInt32>]
  [-ResourcePoolName <String>] [-SupportPersistentReservations] [-AllowUnverifiedPaths]
  [-MaximumIOPS <UInt64>] [-MinimumIOPS <UInt64>] [-QoSPolicyID <String>] [-QoSPolicy
  <CimInstance>] [-Passthru] [-OverrideCacheAttributes <CacheAttributes>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-VMHardDiskDrive [-VM] <VirtualMachine[]> [[-ControllerType] <ControllerType>]
  [[-ControllerNumber] <Int32>] [[-ControllerLocation] <Int32>] [[-Path] <String>]
  [-DiskNumber <UInt32>] [-ResourcePoolName <String>] [-SupportPersistentReservations]
  [-AllowUnverifiedPaths] [-MaximumIOPS <UInt64>] [-MinimumIOPS <UInt64>] [-QoSPolicyID
  <String>] [-QoSPolicy <CimInstance>] [-Passthru] [-OverrideCacheAttributes <CacheAttributes>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMHardDiskDrive [-VMDriveController] <VMDriveController> [[-ControllerLocation]
  <Int32>] [[-Path] <String>] [-DiskNumber <UInt32>] [-ResourcePoolName <String>]
  [-SupportPersistentReservations] [-AllowUnverifiedPaths] [-MaximumIOPS <UInt64>]
  [-MinimumIOPS <UInt64>] [-QoSPolicyID <String>] [-QoSPolicy <CimInstance>] [-Passthru]
  [-OverrideCacheAttributes <CacheAttributes>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowUnverifiedPaths Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName,-PSComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ControllerLocation Int32: ~
  -ControllerNumber Int32: ~
  -ControllerType ControllerType:
    values:
    - IDE
    - SCSI
  -Credential PSCredential[]: ~
  -DiskNumber,-Number UInt32: ~
  -MaximumIOPS UInt64: ~
  -MinimumIOPS UInt64: ~
  -OverrideCacheAttributes CacheAttributes:
    values:
    - Default
    - WriteCacheEnabled
    - WriteCacheAndFUAEnabled
    - WriteCacheDisabled
  -Passthru Switch: ~
  -Path String: ~
  -QoSPolicy CimInstance: ~
  -QoSPolicyID String: ~
  -ResourcePoolName String: ~
  -SupportPersistentReservations,-ShareVirtualDisk Switch: ~
  -VM VirtualMachine[]:
    required: true
  -VMDriveController VMDriveController:
    required: true
  -VMName String[]:
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
