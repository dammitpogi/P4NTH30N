description: Gets the breakpoints that are set in the current session
synopses:
- Get-PSBreakpoint [[-Script] <String[]>] [-Runspace <Runspace>] [<CommonParameters>]
- Get-PSBreakpoint [[-Script] <String[]>] -Command <String[]> [-Runspace <Runspace>]
  [<CommonParameters>]
- Get-PSBreakpoint [[-Script] <String[]>] -Variable <String[]> [-Runspace <Runspace>]
  [<CommonParameters>]
- Get-PSBreakpoint [[-Script] <String[]>] [-Type] <BreakpointType[]> [-Runspace <Runspace>]
  [<CommonParameters>]
- Get-PSBreakpoint [-Id] <Int32[]> [-Runspace <Runspace>] [<CommonParameters>]
options:
  -Command System.String[]:
    required: true
  -Id System.Int32[]:
    required: true
  -Runspace Runspace: ~
  -Script System.String[]: ~
  -Type Microsoft.PowerShell.Commands.BreakpointType[]:
    required: true
    values:
    - Line
    - Variable
    - Command
  -Variable System.String[]:
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
