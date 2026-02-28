description: Returns an FSRM action object
synopses:
- New-FsrmAction [-Type] <ActionTypeEnum> [-MailTo <String>] [-MailCC <String>] [-MailBCC
  <String>] [-Subject <String>] [-Body <String>] [-EventType <ActionEventTypeEnum>]
  [-Command <String>] [-WorkingDirectory <String>] [-CommandParameters <String>] [-SecurityLevel
  <ActionSecurityLevelEnum>] [-KillTimeOut <Int32>] [-ShouldLogError] [-ReportTypes
  <ActionReportTypeEnum[]>] [-RunLimitInterval <Int32>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -Body String: ~
  -CimSession,-Session CimSession[]: ~
  -Command String: ~
  -CommandParameters String: ~
  -Confirm,-cf Switch: ~
  -EventType ActionEventTypeEnum:
    values:
    - None
    - Information
    - Warning
    - Error
  -KillTimeOut Int32: ~
  -MailBCC String: ~
  -MailCC String: ~
  -MailTo String: ~
  -ReportTypes ActionReportTypeEnum[]:
    values:
    - LargeFiles
    - FilesByFileGroup
    - LeastRecentlyAccessed
    - MostRecentlyAccessed
    - QuotaUsage
    - FilesByOwner
    - DuplicateFiles
    - FileScreenAuditFiles
    - FilesByProperty
  -RunLimitInterval Int32: ~
  -SecurityLevel ActionSecurityLevelEnum:
    values:
    - None
    - NetworkService
    - LocalService
    - LocalSystem
  -ShouldLogError Switch: ~
  -Subject String: ~
  -ThrottleLimit Int32: ~
  -Type ActionTypeEnum:
    required: true
    values:
    - Event
    - Email
    - Command
    - Report
  -WhatIf,-wi Switch: ~
  -WorkingDirectory String: ~
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
