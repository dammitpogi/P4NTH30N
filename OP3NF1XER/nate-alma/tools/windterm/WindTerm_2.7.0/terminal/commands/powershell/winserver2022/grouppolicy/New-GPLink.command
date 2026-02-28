description: Links a GPO to a site, domain, or OU
synopses:
- New-GPLink -Guid <Guid> -Target <String> [-LinkEnabled <EnableLink>] [-Order <Int32>]
  [-Domain <String>] [-Server <String>] [-Enforced <EnforceLink>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-GPLink [-Name] <String> -Target <String> [-LinkEnabled <EnableLink>] [-Order
  <Int32>] [-Domain <String>] [-Server <String>] [-Enforced <EnforceLink>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Domain,-DomainName String: ~
  -Enforced EnforceLink:
    values:
    - Unspecified
    - No
    - Yes
  -Guid,-ID Guid:
    required: true
  -LinkEnabled EnableLink:
    values:
    - Unspecified
    - No
    - Yes
  -Name,-DisplayName String:
    required: true
  -Order Int32: ~
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
