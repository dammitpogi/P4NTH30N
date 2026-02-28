description: Creates a new transaction in a Transaction Manager on the local computer
synopses:
- New-DtcDiagnosticTransaction [[-Timeout] <Int32>] [[-IsolationLevel] <IsolationLevel>]
  [<CommonParameters>]
options:
  -IsolationLevel IsolationLevel:
    values:
    - Serializable
    - RepeatableRead
    - ReadCommitted
    - ReadUncommitted
    - Snapshot
    - Chaos
    - Unspecified
  -Timeout Int32: ~
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
