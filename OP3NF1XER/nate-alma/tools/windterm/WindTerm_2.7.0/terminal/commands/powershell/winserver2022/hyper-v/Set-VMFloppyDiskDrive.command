description: Configures a virtual floppy disk drive
synopses:
- Set-VMFloppyDiskDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [[-Path] <String>] [-ResourcePoolName <String>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFloppyDiskDrive [-VM] <VirtualMachine[]> [[-Path] <String>] [-ResourcePoolName
  <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFloppyDiskDrive [-VMFloppyDiskDrive] <VMFloppyDiskDrive[]> [[-Path] <String>]
  [-ResourcePoolName <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Passthru Switch: ~
  -Path,-FullName String: ~
  -ResourcePoolName String: ~
  -VM VirtualMachine[]:
    required: true
  -VMFloppyDiskDrive VMFloppyDiskDrive[]:
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
