description: Returns a notification action object for file management jobs
synopses:
- New-FsrmFmjNotificationAction [-Type] <FmjNotificationActionTypeEnum> [-MailTo <String>]
  [-MailCC <String>] [-MailBCC <String>] [-Subject <String>] [-Body <String>] [-AttachmentFileListSize
  <UInt32>] [-EventType <FmjNotificationActionEventTypeEnum>] [-Command <String>]
  [-WorkingDirectory <String>] [-CommandParameters <String>] [-SecurityLevel <FmjNotificationActionSecurityLevelEnum>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AttachmentFileListSize UInt32: ~
  -Body String: ~
  -CimSession,-Session CimSession[]: ~
  -Command String: ~
  -CommandParameters String: ~
  -Confirm,-cf Switch: ~
  -EventType FmjNotificationActionEventTypeEnum:
    values:
    - None
    - Information
    - Warning
    - Error
  -MailBCC String: ~
  -MailCC String: ~
  -MailTo String: ~
  -SecurityLevel FmjNotificationActionSecurityLevelEnum:
    values:
    - None
    - NetworkService
    - LocalService
    - LocalSystem
  -Subject String: ~
  -ThrottleLimit Int32: ~
  -Type FmjNotificationActionTypeEnum:
    required: true
    values:
    - Event
    - Email
    - Command
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
