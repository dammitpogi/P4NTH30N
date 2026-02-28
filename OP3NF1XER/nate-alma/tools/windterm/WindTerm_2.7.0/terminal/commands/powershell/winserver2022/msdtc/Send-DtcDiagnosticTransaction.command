description: Propagates a transaction to a specified diagnostic Resource Manager
synopses:
- Send-DtcDiagnosticTransaction [-Transaction] <DtcDiagnosticTransaction> [[-ComputerName]
  <String>] [[-Port] <Int32>] [[-PropagationMethod] <DtcTransactionPropagation>] [<CommonParameters>]
options:
  -ComputerName String: ~
  -Port Int32: ~
  -PropagationMethod DtcTransactionPropagation:
    values:
    - Pull
    - Push
  -Transaction DtcDiagnosticTransaction:
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
