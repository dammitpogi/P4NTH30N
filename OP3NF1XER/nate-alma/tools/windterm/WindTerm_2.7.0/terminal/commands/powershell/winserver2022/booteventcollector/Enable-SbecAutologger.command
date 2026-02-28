description: Enables the forwarding of the events to the Setup and Boot Event Collector
  in the AutoLogger settings
synopses:
- Enable-SbecAutologger -Path <String[]> [-Logger <String[]>] [-PermLogger <String[]>]
  [-NoDefaultLoggers] [-ForceLogger] [-DismLogPath <String>] [<CommonParameters>]
- Enable-SbecAutologger -ComputerName <String[]> [-Credential <PSCredential>] [-Logger
  <String[]>] [-PermLogger <String[]>] [-NoDefaultLoggers] [-ForceLogger] [<CommonParameters>]
- Enable-SbecAutologger -Session <PSSession[]> [-Logger <String[]>] [-PermLogger <String[]>]
  [-NoDefaultLoggers] [-ForceLogger] [<CommonParameters>]
- Enable-SbecAutologger [-Local] [-SystemHive <String>] [-ControlSet <String>] [-Logger
  <String[]>] [-PermLogger <String[]>] [-NoDefaultLoggers] [-ForceLogger] [<CommonParameters>]
options:
  -ComputerName String[]:
    required: true
  -ControlSet String: ~
  -Credential PSCredential: ~
  -DismLogPath String: ~
  -ForceLogger Switch: ~
  -Local Switch:
    required: true
  -Logger String[]: ~
  -NoDefaultLoggers Switch: ~
  -Path String[]:
    required: true
  -PermLogger String[]: ~
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
