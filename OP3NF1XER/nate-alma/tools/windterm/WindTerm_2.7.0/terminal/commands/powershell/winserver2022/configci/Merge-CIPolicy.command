description: Combines the rules in several Code Integrity policy files
synopses:
- Merge-CIPolicy [-OutputFilePath] <String> [-PolicyPaths] <String[]> [-Rules <Rule[]>]
  [-AppIdTaggingPolicy] [<CommonParameters>]
options:
  -AppIdTaggingPolicy Switch: ~
  -OutputFilePath,-o String:
    required: true
  -PolicyPaths,-p String[]:
    required: true
  -Rules,-r Rule[]: ~
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
