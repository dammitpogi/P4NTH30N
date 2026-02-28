description: Creates a fragment for Unattend.xml with post-install commands
synopses:
- New-SbecUnattendFragment [-CollectorIp] <String> [-CollectorPort] <UInt32> [-Key]
  <String> [[-BusParameters] <String>] [[-Logger] <String[]>] [[-PermLogger] <String[]>]
  [-NoDefaultLoggers] [[-LogDbgMask] <UInt32>] [[-FirstOrder] <UInt32>] [<CommonParameters>]
options:
  -BusParameters,-BusParams String: ~
  -CollectorIp String:
    required: true
  -CollectorPort UInt32:
    required: true
  -FirstOrder UInt32: ~
  -Key String:
    required: true
  -LogDbgMask UInt32: ~
  -Logger String[]: ~
  -NoDefaultLoggers Switch: ~
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
