description: Configures a virtual DVD drive
synopses:
- Set-VMDvdDrive [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String> [[-ControllerNumber] <Int32>] [[-ControllerLocation]
  <Int32>] [-ToControllerNumber <Int32>] [-ToControllerLocation <Int32>] [[-Path]
  <String>] [-ResourcePoolName <String>] [-AllowUnverifiedPaths] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMDvdDrive [-VMDvdDrive] <DvdDrive[]> [-ToControllerNumber <Int32>] [-ToControllerLocation
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
  -ToControllerLocation Int32: ~
  -ToControllerNumber Int32: ~
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
