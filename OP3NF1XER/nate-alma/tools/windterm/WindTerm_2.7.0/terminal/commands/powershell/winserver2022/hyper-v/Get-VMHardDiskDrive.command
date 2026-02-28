description: Gets the virtual hard disk drives attached to one or more virtual machines
synopses:
- Get-VMHardDiskDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-ControllerLocation <Int32>] [-ControllerNumber
  <Int32>] [-ControllerType <ControllerType>] [<CommonParameters>]
- Get-VMHardDiskDrive [-VM] <VirtualMachine[]> [-ControllerLocation <Int32>] [-ControllerNumber
  <Int32>] [-ControllerType <ControllerType>] [<CommonParameters>]
- Get-VMHardDiskDrive [-VMSnapshot] <VMSnapshot> [-ControllerLocation <Int32>] [-ControllerNumber
  <Int32>] [-ControllerType <ControllerType>] [<CommonParameters>]
- Get-VMHardDiskDrive [-ControllerLocation <Int32>] [-VMDriveController] <VMDriveController[]>
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -ControllerLocation Int32: ~
  -ControllerNumber Int32: ~
  -ControllerType ControllerType:
    values:
    - IDE
    - SCSI
  -Credential PSCredential[]: ~
  -VM VirtualMachine[]:
    required: true
  -VMDriveController VMDriveController[]:
    required: true
  -VMName String[]:
    required: true
  -VMSnapshot,-VMCheckpoint VMSnapshot:
    required: true
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
