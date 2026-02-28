description: Stops and removes a diagnostic Resource Manager job
synopses:
- Stop-DtcDiagnosticResourceManager [[-Job] <DtcDiagnosticResourceManagerJob>] [<CommonParameters>]
- Stop-DtcDiagnosticResourceManager [[-Name] <String>] [<CommonParameters>]
- Stop-DtcDiagnosticResourceManager [[-InstanceId] <Guid>] [<CommonParameters>]
options:
  -InstanceId Guid: ~
  -Job DtcDiagnosticResourceManagerJob: ~
  -Name String: ~
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
