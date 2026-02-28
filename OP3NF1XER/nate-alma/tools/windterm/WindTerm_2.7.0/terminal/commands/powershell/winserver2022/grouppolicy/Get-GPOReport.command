description: Generates a report either in XML or HTML format for a specified GPO or
  for all GPOs in a domain
synopses:
- Get-GPOReport [-Guid] <Guid> [-ReportType] <ReportType> [[-Path] <String>] [[-Domain]
  <String>] [[-Server] <String>] [<CommonParameters>]
- Get-GPOReport [-Name] <String> [-ReportType] <ReportType> [[-Path] <String>] [[-Domain]
  <String>] [[-Server] <String>] [<CommonParameters>]
- Get-GPOReport [-ReportType] <ReportType> [[-Path] <String>] [[-Domain] <String>]
  [[-Server] <String>] [-All] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Domain,-DomainName String: ~
  -Guid,-Id Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Path String: ~
  -ReportType ReportType:
    required: true
    values:
    - Xml
    - Html
  -Server,-DC String: ~
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
