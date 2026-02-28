description: Exports a virtual machine to disk
synopses:
- Export-VM [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Name] <String[]> [-Path] <String> [-AsJob] [-Passthru] [-CaptureLiveState <CaptureLiveState>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Export-VM [-VM] <VirtualMachine[]> [-Path] <String> [-AsJob] [-Passthru] [-CaptureLiveState
  <CaptureLiveState>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CaptureLiveState CaptureLiveState:
    values:
    - CaptureCrashConsistentState
    - CaptureSavedState
    - CaptureDataConsistentState
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -Name,-VMName String[]:
    required: true
  -Passthru Switch: ~
  -Path String:
    required: true
  -VM VirtualMachine[]:
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
