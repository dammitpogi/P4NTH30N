description: Deletes a DVD drive from a virtual machine
synopses:
- Remove-VMDvdDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [-ControllerNumber] <Int32> [-ControllerLocation]
  <Int32> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMDvdDrive [-VMDvdDrive] <DvdDrive[]> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ControllerLocation Int32:
    required: true
  -ControllerNumber Int32:
    required: true
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -VMDvdDrive DvdDrive[]:
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
