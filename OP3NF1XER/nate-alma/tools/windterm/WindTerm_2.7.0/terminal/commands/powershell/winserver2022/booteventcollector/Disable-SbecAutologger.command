description: Disables the forwarding of events to the Setup and Boot Event Collector
  in the AutoLogger settings
synopses:
- Disable-SbecAutologger -Path <String[]> [-Logger <String[]>] [-NoDefaultLoggers]
  [-DismLogPath <String>] [<CommonParameters>]
- Disable-SbecAutologger -ComputerName <String[]> [-Credential <PSCredential>] [-Logger
  <String[]>] [-NoDefaultLoggers] [<CommonParameters>]
- Disable-SbecAutologger -Session <PSSession[]> [-Logger <String[]>] [-NoDefaultLoggers]
  [<CommonParameters>]
- Disable-SbecAutologger [-Local] [-SystemHive <String>] [-ControlSet <String>] [-Logger
  <String[]>] [-NoDefaultLoggers] [<CommonParameters>]
options:
  -ComputerName String[]:
    required: true
  -ControlSet String: ~
  -Credential PSCredential: ~
  -DismLogPath String: ~
  -Local Switch:
    required: true
  -Logger String[]: ~
  -NoDefaultLoggers Switch: ~
  -Path String[]:
    required: true
  -Session PSSession[]:
    required: true
  -SystemHive String: ~
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
