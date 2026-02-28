description: Removes a GPO link from a site, domain or OU
synopses:
- Remove-GPLink -Guid <Guid> -Target <String> [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-GPLink [-Name] <String> -Target <String> [-Domain <String>] [-Server <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Guid,-ID,-GPOID Guid:
    required: true
  -Name,-DisplayName String:
    required: true
  -Server,-DC String: ~
  -Target String:
    required: true
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
