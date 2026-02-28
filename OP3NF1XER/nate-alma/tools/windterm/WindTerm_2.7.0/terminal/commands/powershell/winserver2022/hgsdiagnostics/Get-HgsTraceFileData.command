description: Gets metadata about and the contents of HGS Diagnostic trace files recorded
  in a trace manifest
synopses:
- Get-HgsTraceFileData -File <String> -Manifest <String> -StartByte <Int64> [<CommonParameters>]
- Get-HgsTraceFileData -File <String> -Manifest <String> [-Length] [<CommonParameters>]
options:
  -File String:
    required: true
  -Length Switch:
    required: true
  -Manifest String:
    required: true
  -StartByte Int64:
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
