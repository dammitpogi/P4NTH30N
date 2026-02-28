description: Enables the BCD settings in the offline boot images imported into the
  WDS server
synopses:
- Enable-SbecWdsBcd -BcdPath <String[]> -CollectorIp <String> -CollectorPort <UInt32>
  -Key <String> [-BusParameters <String>] [-WdsRoot <String>] [-SkipNotifyWds] [<CommonParameters>]
- Enable-SbecWdsBcd [-Image <Array>] -CollectorIp <String> -CollectorPort <UInt32>
  -Key <String> [-BusParameters <String>] [-WdsRoot <String>] [-SkipNotifyWds] [<CommonParameters>]
options:
  -BcdPath String[]:
    required: true
  -BusParameters,-BusParams String: ~
  -CollectorIp String:
    required: true
  -CollectorPort UInt32:
    required: true
  -Image Array: ~
  -Key String:
    required: true
  -SkipNotifyWds Switch: ~
  -WdsRoot String: ~
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
