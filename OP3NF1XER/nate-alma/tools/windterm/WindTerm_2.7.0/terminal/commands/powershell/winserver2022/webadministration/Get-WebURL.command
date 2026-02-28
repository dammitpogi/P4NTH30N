description: Gets information about the URL associated with a website
synopses:
- Get-WebURL [[-PSPath] <String[]>] [-Accept <String>] [-ResponseHeaders] [-Content]
  [<CommonParameters>]
- Get-WebURL [[-Url] <Uri[]>] [-Accept <String>] [-ResponseHeaders] [-Content] [<CommonParameters>]
options:
  -Accept String: ~
  -Content Switch: ~
  -PSPath String[]: ~
  -ResponseHeaders Switch: ~
  -Url Uri[]: ~
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
