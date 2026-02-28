description: Fetches historical Windows Diagnostic Data uploaded by this machine
synopses:
- Get-DiagnosticData [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-RecordCount]
  <Int32>] [-DiagnosticDataType <Int32>] [-BasicTelemetryOnly] [<CommonParameters>]
options:
  -StartTime,-st,-start DateTime: ~
  -EndTime,-et,-end DateTime: ~
  -RecordCount,-rc,-recCount,-c,-count Int32: ~
  -DiagnosticDataType,-ddt,-dt Int32: ~
  -BasicTelemetryOnly,-basic,-basicOnly Switch: ~
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
