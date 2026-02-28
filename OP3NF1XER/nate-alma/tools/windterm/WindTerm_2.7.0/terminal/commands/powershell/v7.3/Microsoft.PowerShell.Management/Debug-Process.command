description: Debugs one or more processes running on the local computer
synopses:
- Debug-Process [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Debug-Process [-Id] <Int32[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Debug-Process -InputObject <Process[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Id,-PID,-ProcessId System.Int32[]:
    required: true
  -InputObject System.Diagnostics.Process[]:
    required: true
  -Name,-ProcessName System.String[]:
    required: true
  -Confirm,-cf Switch: ~
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
