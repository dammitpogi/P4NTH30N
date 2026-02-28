description: Generates a system health report of the Active Directory Rights Management
  Services (AD RMS) cluster
synopses:
- Get-RmsSystemHealthReport [-StartTime <DateTime>] [-EndTime <DateTime>] [-ServerName
  <String>] [-RequestType <String>] [-DomainName <String>] [-UserName <String>] -ReportType
  <ReportType> [-Path] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DomainName String: ~
  -EndTime DateTime: ~
  -Path String[]:
    required: true
  -ReportType ReportType:
    required: true
    values:
    - Server
    - Request
    - Domain
    - User
  -RequestType String: ~
  -ServerName String: ~
  -StartTime DateTime: ~
  -UserName String: ~
  -WhatIf,-wi Switch: ~
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
