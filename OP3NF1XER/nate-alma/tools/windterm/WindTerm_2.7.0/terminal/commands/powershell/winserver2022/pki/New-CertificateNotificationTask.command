description: Creates a new task in the Task Scheduler that will be triggered when
  a certificate is replaced, expired, or about to expired
synopses:
- New-CertificateNotificationTask -Type <CertificateNotificationType> [-RunTaskForExistingCertificates]
  -PSScript <String> -Name <String> -Channel <NotificationChannel> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Channel NotificationChannel:
    required: true
    values:
    - System
    - User
  -Confirm,-cf Switch: ~
  -Name String:
    required: true
  -PSScript String:
    required: true
  -RunTaskForExistingCertificates Switch: ~
  -Type CertificateNotificationType:
    required: true
    values:
    - Replace
    - Expire
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
