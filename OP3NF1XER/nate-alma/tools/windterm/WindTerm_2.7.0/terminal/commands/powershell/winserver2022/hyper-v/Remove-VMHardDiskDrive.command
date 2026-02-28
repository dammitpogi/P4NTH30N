description: Deletes a hard disk drive from a virtual machine
synopses:
- Remove-VMHardDiskDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-ControllerType] <ControllerType> [-ControllerNumber]
  <Int32> [-ControllerLocation] <Int32> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMHardDiskDrive [-VMHardDiskDrive] <HardDiskDrive[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ControllerLocation Int32:
    required: true
  -ControllerNumber Int32:
    required: true
  -ControllerType ControllerType:
    required: true
    values:
    - IDE
    - SCSI
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -VMHardDiskDrive HardDiskDrive[]:
    required: true
  -VMName String:
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
