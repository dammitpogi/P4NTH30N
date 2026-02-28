description: Adds a DVD drive to a virtual machine
synopses:
- Add-VMDvdDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [[-ControllerNumber] <Int32>] [[-ControllerLocation]
  <Int32>] [[-Path] <String>] [-ResourcePoolName <String>] [-AllowUnverifiedPaths]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMDvdDrive [-VM] <VirtualMachine[]> [[-ControllerNumber] <Int32>] [[-ControllerLocation]
  <Int32>] [[-Path] <String>] [-ResourcePoolName <String>] [-AllowUnverifiedPaths]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VMDvdDrive [-VMDriveController] <VMDriveController[]> [[-ControllerLocation]
  <Int32>] [[-Path] <String>] [-ResourcePoolName <String>] [-AllowUnverifiedPaths]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowUnverifiedPaths Switch: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ControllerLocation Int32: ~
  -ControllerNumber Int32: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -Path String: ~
  -ResourcePoolName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMDriveController VMDriveController[]:
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
