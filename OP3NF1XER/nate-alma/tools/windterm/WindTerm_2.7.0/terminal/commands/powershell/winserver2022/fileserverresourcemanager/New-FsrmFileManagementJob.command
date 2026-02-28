description: Creates a file management job
synopses:
- New-FsrmFileManagementJob [-Name] <String> [-Description <String>] -Namespace <String[]>
  [-Disabled] [-Condition <CimInstance[]>] -Action <CimInstance> [-ReportFormat <FmjReportFormatsEnum[]>]
  [-ReportLog <FmjReportLogsEnum[]>] [-MailTo <String>] [-Notification <CimInstance[]>]
  -Schedule <CimInstance> [-Continuous] [-ContinuousLog] [-ContinuousLogSize <UInt64>]
  [-Parameters <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action CimInstance:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Condition CimInstance[]: ~
  -Confirm,-cf Switch: ~
  -Continuous Switch: ~
  -ContinuousLog Switch: ~
  -ContinuousLogSize UInt64: ~
  -Description String: ~
  -Disabled Switch: ~
  -MailTo String: ~
  -Name String:
    required: true
  -Namespace String[]:
    required: true
  -Notification CimInstance[]: ~
  -Parameters String[]: ~
  -ReportFormat FmjReportFormatsEnum[]:
    values:
    - DHtml
    - Html
    - Text
    - Csv
    - XML
  -ReportLog FmjReportLogsEnum[]:
    values:
    - Error
    - Information
    - Audit
  -Schedule CimInstance:
    required: true
  -ThrottleLimit Int32: ~
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
