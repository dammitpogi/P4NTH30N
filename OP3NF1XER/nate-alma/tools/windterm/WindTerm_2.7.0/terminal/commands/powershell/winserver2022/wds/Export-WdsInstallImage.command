description: Exports an existing install image from an image store
synopses:
- Export-WdsInstallImage -Destination <String> [-NewImageName <String>] [-NewDescription
  <String>] [-Append] [-Force] -ImageName <String> [-ImageGroup <String>] [-FileName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Append Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Destination String:
    required: true
  -FileName String: ~
  -Force Switch: ~
  -ImageGroup String: ~
  -ImageName String:
    required: true
  -NewDescription String: ~
  -NewImageName String: ~
  -ThrottleLimit Int32: ~
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
