description: Configures web limiting for standard user sessions
synopses:
- Set-WmsWebLimiting [-Allow] [-Sites] <String[]> [-Server <String>] [<CommonParameters>]
- Set-WmsWebLimiting [-Block] [-Sites] <String[]> [-Server <String>] [<CommonParameters>]
options:
  -Allow Switch:
    required: true
  -Block Switch:
    required: true
  -Server,-ComputerName String: ~
  -Sites String[]:
    required: true
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
