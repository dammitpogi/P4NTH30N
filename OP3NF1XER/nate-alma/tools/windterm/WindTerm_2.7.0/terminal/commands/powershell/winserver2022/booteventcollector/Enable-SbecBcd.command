description: Enables and configures the event forwarding mode in the BCD settings
synopses:
- Enable-SbecBcd -Path <String[]> -CollectorIp <String> -CollectorPort <String> -Key
  <String> [-Id <String>] [-BusParameters <String>] [-DismLogPath <String>] [<CommonParameters>]
- Enable-SbecBcd -ComputerName <String[]> [-Credential <PSCredential>] -CollectorIp
  <String> -CollectorPort <String> -Key <String> [-Id <String>] [-BusParameters <String>]
  [<CommonParameters>]
- Enable-SbecBcd -Session <PSSession[]> -CollectorIp <String> -CollectorPort <String>
  -Key <String> [-Id <String>] [-BusParameters <String>] [<CommonParameters>]
- Enable-SbecBcd [-Local] [-BcdStore <String>] [-CreateEventSettings] -CollectorIp
  <String> -CollectorPort <String> -Key <String> [-Id <String>] [-BusParameters <String>]
  [<CommonParameters>]
options:
  -BcdStore String: ~
  -BusParameters,-BusParams String: ~
  -CollectorIp String:
    required: true
  -CollectorPort String:
    required: true
  -ComputerName String[]:
    required: true
  -CreateEventSettings Switch: ~
  -Credential PSCredential: ~
  -DismLogPath String: ~
  -Id String: ~
  -Key String:
    required: true
  -Local Switch:
    required: true
  -Path String[]:
    required: true
  -Session PSSession[]:
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
