description: Enables the breakpoints in the current console
synopses:
- Enable-PSBreakpoint [-PassThru] [-Breakpoint] <Breakpoint[]> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Enable-PSBreakpoint [-PassThru] [-Id] <Int32[]> [-Runspace <Runspace>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Breakpoint System.Management.Automation.Breakpoint[]:
    required: true
  -Id System.Int32[]:
    required: true
  -PassThru Switch: ~
  -Runspace,-RunspaceId Runspace: ~
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
