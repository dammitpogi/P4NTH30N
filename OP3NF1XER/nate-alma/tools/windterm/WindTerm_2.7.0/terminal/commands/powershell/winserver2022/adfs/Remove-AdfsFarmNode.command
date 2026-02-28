description: The Remove-AdfsFarmNode cmdlet is deprecated. Instead, use the Uninstall-WindowsFeature
  cmdlet
synopses:
- Remove-AdfsFarmNode -ServiceAccountCredential <PSCredential> [<CommonParameters>]
- Remove-AdfsFarmNode -GroupServiceAccountIdentifier <String> [-Credential <PSCredential>]
  [<CommonParameters>]
options:
  -Credential PSCredential: ~
  -GroupServiceAccountIdentifier String:
    required: true
  -ServiceAccountCredential PSCredential:
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
