description: Gets an IIS configuration element
synopses:
- Get-WebConfiguration [-Recurse] [-Metadata] [-Clr <String>] [-Location <String[]>]
  [-Filter] <String[]> [[-PSPath] <String[]>] [<CommonParameters>]
options:
  -Clr String: ~
  -Filter String[]:
    required: true
  -Location String[]: ~
  -Metadata Switch: ~
  -PSPath String[]: ~
  -Recurse Switch: ~
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
