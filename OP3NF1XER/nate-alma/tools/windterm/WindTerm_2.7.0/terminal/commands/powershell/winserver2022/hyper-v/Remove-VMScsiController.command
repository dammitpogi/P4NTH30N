description: Removes a SCSI controller from a virtual machine
synopses:
- Remove-VMScsiController [-CimSession <CimSession[]>] [-ComputerName <String[]>]
  [-Credential <PSCredential[]>] [-VMName] <String[]> [-ControllerNumber] <Int32>
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-VMScsiController [-VMScsiController] <VMScsiController[]> [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ControllerNumber Int32:
    required: true
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -VMName String[]:
    required: true
  -VMScsiController VMScsiController[]:
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
