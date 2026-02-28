description: Sets a breakpoint on a line, command, or variable
synopses:
- Set-PSBreakpoint [-Action <ScriptBlock>] [[-Column] <Int32>] [-Line] <Int32[]> [-Script]
  <String[]> [-Runspace <Runspace>] [<CommonParameters>]
- Set-PSBreakpoint [-Action <ScriptBlock>] -Command <String[]> [[-Script] <String[]>]
  [-Runspace <Runspace>] [<CommonParameters>]
- Set-PSBreakpoint [-Action <ScriptBlock>] [[-Script] <String[]>] -Variable <String[]>
  [-Mode <VariableAccessMode>] [-Runspace <Runspace>] [<CommonParameters>]
options:
  -Action System.Management.Automation.ScriptBlock: ~
  -Column System.Int32: ~
  -Command,-C System.String[]:
    required: true
  -Line System.Int32[]:
    required: true
  -Mode System.Management.Automation.VariableAccessMode:
    values:
    - Read
    - Write
    - ReadWrite
  -Runspace Runspace: ~
  -Script System.String[]: ~
  -Variable,-V System.String[]:
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
