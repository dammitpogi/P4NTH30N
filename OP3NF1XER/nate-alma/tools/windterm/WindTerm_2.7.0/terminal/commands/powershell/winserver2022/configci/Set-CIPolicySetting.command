description: Modifies the SecureSettings within the Code Integrity policy
synopses:
- Set-CIPolicySetting [-FilePath] <String> -Provider <String> -Key <String> -ValueName
  <String> -ValueType <String> -Value <String> [<CommonParameters>]
- Set-CIPolicySetting [-FilePath] <String> -Provider <String> -Key <String> -ValueName
  <String> [-Delete] [<CommonParameters>]
options:
  -Delete,-d Switch:
    required: true
  -FilePath,-f String:
    required: true
  -Key,-k String:
    required: true
  -Provider,-p String:
    required: true
  -Value,-v String:
    required: true
  -ValueName,-vn String:
    required: true
  -ValueType,-vt String:
    required: true
    values:
    - Boolean
    - DWord
    - Binary
    - String
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
