description: Gets and writes the RSoP information for a user, a computer, or both
  to a file
synopses:
- Get-GPResultantSetOfPolicy [-Computer <String>] [-User <String>] -ReportType <ReportType>
  -Path <String> [<CommonParameters>]
options:
  -Computer String: ~
  -Path String:
    required: true
  -ReportType ReportType:
    required: true
    values:
    - Xml
    - Html
  -User String: ~
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
