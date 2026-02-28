description: Gets appx volumes for the computer
synopses:
- Get-AppxVolume [[-Path] <String>] [<CommonParameters>]
- Get-AppxVolume [[-Path] <String>] [-Online] [<CommonParameters>]
- Get-AppxVolume [[-Path] <String>] [-Offline] [<CommonParameters>]
options:
  -Offline Switch:
    required: true
  -Online Switch:
    required: true
  -Path String: ~
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
