description: Enlists a diagnostic Resource Manager for a transaction object
synopses:
- Join-DtcDiagnosticResourceManager [-Transaction] <DtcDiagnosticTransaction> [[-ComputerName]
  <String>] [[-Port] <Int32>] [-Volatile] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Port Int32: ~
  -Transaction DtcDiagnosticTransaction:
    required: true
  -Volatile Switch: ~
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
