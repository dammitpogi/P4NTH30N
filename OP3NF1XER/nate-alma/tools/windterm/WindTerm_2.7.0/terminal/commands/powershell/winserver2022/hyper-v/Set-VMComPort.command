description: Configures the COM port of a virtual machine
synopses:
- Set-VMComPort [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> -Number <Int32> [[-Path] <String>] [-DebuggerMode
  <OnOffState>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMComPort [-VM] <VirtualMachine[]> -Number <Int32> [[-Path] <String>] [-DebuggerMode
  <OnOffState>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMComPort [-VMComPort] <VMComPort[]> [[-Path] <String>] [-DebuggerMode <OnOffState>]
  [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -DebuggerMode OnOffState:
    values:
    - On
    - Off
  -Number Int32:
    required: true
  -Passthru Switch: ~
  -Path String: ~
  -VM VirtualMachine[]:
    required: true
  -VMComPort VMComPort[]:
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
