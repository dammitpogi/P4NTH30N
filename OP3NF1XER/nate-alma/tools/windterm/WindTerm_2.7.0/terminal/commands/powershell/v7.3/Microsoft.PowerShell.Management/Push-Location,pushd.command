description: Adds the current location to the top of a location stack
synopses:
- Push-Location [[-Path] <String>] [-PassThru] [-StackName <String>] [<CommonParameters>]
- Push-Location [-LiteralPath <String>] [-PassThru] [-StackName <String>] [<CommonParameters>]
options:
  -LiteralPath,-PSPath,-LP System.String: ~
  -PassThru Switch: ~
  -Path System.String: ~
  -StackName System.String: ~
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
