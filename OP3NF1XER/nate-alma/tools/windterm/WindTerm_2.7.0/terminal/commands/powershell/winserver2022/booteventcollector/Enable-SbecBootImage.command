description: Enables AutoLogger settings in offline WinPE Setup images
synopses:
- Enable-SbecBootImage [-Path] <String[]> [[-Logger] <String[]>] [[-PermLogger] <String[]>]
  [-NoDefaultLoggers] [[-DismLogPath] <String>] [<CommonParameters>]
options:
  -DismLogPath String: ~
  -Logger String[]: ~
  -NoDefaultLoggers Switch: ~
  -Path String[]:
    required: true
  -PermLogger String[]: ~
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
