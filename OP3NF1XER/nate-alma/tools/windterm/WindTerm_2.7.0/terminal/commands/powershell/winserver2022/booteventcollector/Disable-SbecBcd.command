description: Disables the event forwarding mode in BCD settings
synopses:
- Disable-SbecBcd -Path <String[]> [-Id <String>] [-DismLogPath <String>] [<CommonParameters>]
- Disable-SbecBcd -ComputerName <String[]> [-Credential <PSCredential>] [-Id <String>]
  [<CommonParameters>]
- Disable-SbecBcd -Session <PSSession[]> [-Id <String>] [<CommonParameters>]
- Disable-SbecBcd [-Local] [-BcdStore <String>] [-Id <String>] [<CommonParameters>]
options:
  -BcdStore String: ~
  -ComputerName String[]:
    required: true
  -Credential PSCredential: ~
  -DismLogPath String: ~
  -Id String: ~
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
