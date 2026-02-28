description: Waits for the processes to be stopped before accepting more input
synopses:
- Wait-Process [-Name] <String[]> [[-Timeout] <Int32>] [<CommonParameters>]
- Wait-Process [-Id] <Int32[]> [[-Timeout] <Int32>] [<CommonParameters>]
- Wait-Process [[-Timeout] <Int32>] -InputObject <Process[]> [<CommonParameters>]
options:
  -Id,-PID,-ProcessId System.Int32[]:
    required: true
  -InputObject System.Diagnostics.Process[]:
    required: true
  -Name,-ProcessName System.String[]:
    required: true
  -Timeout,-TimeoutSec System.Int32: ~
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
