description: Changes configuration settings for access denied remediation
synopses:
- Set-FsrmAdrSetting [-Event] <FsrmAdrEventEnum[]> [-Enabled] [-DisplayMessage <String>]
  [-EmailMessage <String>] [-AllowRequests] [-MailToOwner] [-MailCCAdmin] [-MailTo
  <String>] [-IncludeDeviceClaims] [-IncludeUserClaims] [-EventLog] [-DeviceTroubleshooting]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-FsrmAdrSetting -InputObject <CimInstance[]> [-Enabled] [-DisplayMessage <String>]
  [-EmailMessage <String>] [-AllowRequests] [-MailToOwner] [-MailCCAdmin] [-MailTo
  <String>] [-IncludeDeviceClaims] [-IncludeUserClaims] [-EventLog] [-DeviceTroubleshooting]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AllowRequests Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeviceTroubleshooting Switch: ~
  -DisplayMessage String: ~
  -EmailMessage String: ~
  -Enabled Switch: ~
  -Event FsrmAdrEventEnum[]:
    required: true
    values:
    - AccessDenied
    - FileNotFound
  -EventLog Switch: ~
  -IncludeDeviceClaims Switch: ~
  -IncludeUserClaims Switch: ~
  -InputObject CimInstance[]:
    required: true
  -MailCCAdmin Switch: ~
  -MailTo String: ~
  -MailToOwner Switch: ~
  -PassThru Switch: ~
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
