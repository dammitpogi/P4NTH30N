description: Combines a path and a child path into a single path
synopses:
- Join-Path [-Path] <String[]> [-ChildPath] <String> [[-AdditionalChildPath] <String[]>]
  [-Resolve] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -AdditionalChildPath System.String[]: ~
  -ChildPath System.String:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -Path,-PSPath System.String[]:
    required: true
  -Resolve Switch: ~
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
