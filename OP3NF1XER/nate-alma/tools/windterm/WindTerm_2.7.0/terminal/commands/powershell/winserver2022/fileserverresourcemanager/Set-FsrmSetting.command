description: Changes global FSRM settings for the computer
synopses:
- Set-FsrmSetting [-InputObject <CimInstance[]>] [-SmtpServer <String>] [-FromEmailAddress
  <String>] [-AdminEmailAddress <String>] [-EmailNotificationLimit <Int32>] [-EventNotificationLimit
  <Int32>] [-CommandNotificationLimit <Int32>] [-ReportNotificationLimit <Int32>]
  [-ReportLimitMaxFile <Int32>] [-ReportLimitMaxFileGroup <Int32>] [-ReportLimitMaxOwner
  <Int32>] [-ReportLimitMaxFilesPerFileGroup <Int32>] [-ReportLimitMaxFilesPerOwner
  <Int32>] [-ReportLimitMaxFilesPerDuplicateGroup <Int32>] [-ReportLimitMaxDuplicateGroup
  <Int32>] [-ReportLimitMaxQuota <Int32>] [-ReportLimitMaxFileScreenEvent <Int32>]
  [-ReportLimitMaxPropertyValue <Int32>] [-ReportLimitMaxFilesPerPropertyValue <Int32>]
  [-ReportLocationIncident <String>] [-ReportLocationScheduled <String>] [-ReportLocationOnDemand
  <String>] [-ReportFileScreenAuditDaysSince <Int32>] [-ReportFileScreenAuditUser
  <String[]>] [-ReportFileGroupIncluded <String[]>] [-ReportFileOwnerUser <String[]>]
  [-ReportFileOwnerFilePattern <String>] [-ReportPropertyName <String>] [-ReportPropertyFilePattern
  <String>] [-ReportLargeFileMinimum <UInt64>] [-ReportLargeFilePattern <String>]
  [-ReportLeastAccessedMinimum <Int32>] [-ReportLeastAccessedFilePattern <String>]
  [-ReportMostAccessedMaximum <Int32>] [-ReportMostAccessedFilePattern <String>] [-ReportQuotaMinimumUsage
  <Int32>] [-ReportFileScreenAuditEnable] [-ReportClassificationFormat <FsrmReportClassificationFormatEnum[]>]
  [-ReportClassificationMailTo <String>] [-ReportClassificationLog <FsrmReportClassificationLogEnum[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AdminEmailAddress String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CommandNotificationLimit Int32: ~
  -Confirm,-cf Switch: ~
  -EmailNotificationLimit Int32: ~
  -EventNotificationLimit Int32: ~
  -FromEmailAddress String: ~
  -InputObject CimInstance[]: ~
  -PassThru Switch: ~
  -ReportClassificationFormat FsrmReportClassificationFormatEnum[]:
    values:
    - DHtml
    - Html
    - Text
    - Csv
    - Xml
  -ReportClassificationLog FsrmReportClassificationLogEnum[]:
    values:
    - ClassificationsInLogFile
    - ErrorsInLogFile
    - ClassificationsInSystemLog
    - ErrorsInSystemLog
  -ReportClassificationMailTo String: ~
  -ReportFileGroupIncluded String[]: ~
  -ReportFileOwnerFilePattern String: ~
  -ReportFileOwnerUser String[]: ~
  -ReportFileScreenAuditDaysSince Int32: ~
  -ReportFileScreenAuditEnable Switch: ~
  -ReportFileScreenAuditUser String[]: ~
  -ReportLargeFileMinimum UInt64: ~
  -ReportLargeFilePattern String: ~
  -ReportLeastAccessedFilePattern String: ~
  -ReportLeastAccessedMinimum Int32: ~
  -ReportLimitMaxDuplicateGroup Int32: ~
  -ReportLimitMaxFile Int32: ~
  -ReportLimitMaxFileGroup Int32: ~
  -ReportLimitMaxFileScreenEvent Int32: ~
  -ReportLimitMaxFilesPerDuplicateGroup Int32: ~
  -ReportLimitMaxFilesPerFileGroup Int32: ~
  -ReportLimitMaxFilesPerOwner Int32: ~
  -ReportLimitMaxFilesPerPropertyValue Int32: ~
  -ReportLimitMaxOwner Int32: ~
  -ReportLimitMaxPropertyValue Int32: ~
  -ReportLimitMaxQuota Int32: ~
  -ReportLocationIncident String: ~
  -ReportLocationOnDemand String: ~
  -ReportLocationScheduled String: ~
  -ReportMostAccessedFilePattern String: ~
  -ReportMostAccessedMaximum Int32: ~
  -ReportNotificationLimit Int32: ~
  -ReportPropertyFilePattern String: ~
  -ReportPropertyName String: ~
  -ReportQuotaMinimumUsage Int32: ~
  -SmtpServer String: ~
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
