description: Removes a GPO
synopses:
- Remove-GPO -Guid <Guid> [-Domain <String>] [-Server <String>] [-KeepLinks] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Remove-GPO [-Name] <String> [-Domain <String>] [-Server <String>] [-KeepLinks] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-ID,-GPOID Guid:
    required: true
  -KeepLinks Switch: ~
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
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
