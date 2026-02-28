description: Tests whether a string is a valid JSON document
synopses:
- Test-Json [-Json] <String> [<CommonParameters>]
- Test-Json [-Json] <String> [[-Schema] <String>] [<CommonParameters>]
- Test-Json [-Json] <String> [-SchemaFile <String>] [<CommonParameters>]
options:
  -Json System.String:
    required: true
  -Schema System.String: ~
  -SchemaFile System.String: ~
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
