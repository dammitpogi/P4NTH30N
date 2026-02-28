description: Gets the DVD drives attached to a virtual machine or snapshot
synopses:
- Get-VMDvdDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-ControllerLocation <Int32>] [-ControllerNumber
  <Int32>] [<CommonParameters>]
- Get-VMDvdDrive [-VM] <VirtualMachine[]> [-ControllerLocation <Int32>] [-ControllerNumber
  <Int32>] [<CommonParameters>]
- Get-VMDvdDrive [-ControllerLocation <Int32>] [-ControllerNumber <Int32>] [-VMSnapshot]
  <VMSnapshot> [<CommonParameters>]
- Get-VMDvdDrive [-ControllerLocation <Int32>] [-VMDriveController] <VMDriveController[]>
  [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -ControllerLocation Int32: ~
  -ControllerNumber Int32: ~
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
