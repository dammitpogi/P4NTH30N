description: Exports an existing boot image from an image store
synopses:
- Export-WdsBootImage [-NewDescription <String>] -Destination <String> [-NewImageName
  <String>] [-Force] -ImageName <String> -Architecture <Architecture> [-FileName <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Architecture Architecture:
    required: true
    values:
    - X86
    - Ia64
    - X64
    - Arm
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Destination String:
    required: true
  -FileName String: ~
  -Force Switch: ~
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
