description: Creates a storage report on the server
synopses:
- New-FsrmStorageReport [-Name] <String> -Namespace <String[]> [-Interactive] -ReportType
  <StorageReportReportTypeEnum[]> [-FileScreenAuditDaysSince <UInt32>] [-FileScreenAuditUser
  <String[]>] [-FileGroupIncluded <String[]>] [-FileOwnerUser <String[]>] [-FileOwnerFilePattern
  <String>] [-PropertyName <String>] [-FolderPropertyName <String>] [-PropertyFilePattern
  <String>] [-LargeFileMinimum <UInt64>] [-LargeFilePattern <String>] [-LeastAccessedMinimum
  <UInt32>] [-LeastAccessedFilePattern <String>] [-MostAccessedMaximum <UInt32>] [-MostAccessedFilePattern
  <String>] [-QuotaMinimumUsage <UInt32>] [-ReportFormat <StorageReportReportFormatsEnum[]>]
  [-MailTo <String>] [-Schedule <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -FileGroupIncluded String[]: ~
  -FileOwnerFilePattern String: ~
  -FileOwnerUser String[]: ~
  -FileScreenAuditDaysSince UInt32: ~
  -FileScreenAuditUser String[]: ~
  -FolderPropertyName String: ~
  -Interactive Switch: ~
  -LargeFileMinimum UInt64: ~
  -LargeFilePattern String: ~
  -LeastAccessedFilePattern String: ~
  -LeastAccessedMinimum UInt32: ~
  -MailTo String: ~
  -MostAccessedFilePattern String: ~
  -MostAccessedMaximum UInt32: ~
  -Name String:
    required: true
  -Namespace String[]:
    required: true
  -PropertyFilePattern String: ~
  -PropertyName String: ~
  -QuotaMinimumUsage UInt32: ~
  -ReportFormat StorageReportReportFormatsEnum[]:
    values:
    - DHtml
    - Html
    - Text
    - Csv
    - XML
  -ReportType StorageReportReportTypeEnum[]:
    required: true
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
    - FoldersByProperty
  -Schedule CimInstance: ~
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
