description: Adds a claim description to the Federation Service
synopses:
- Add-AdfsClaimDescription -Name <String> -ClaimType <String> [-ShortName <String>]
  [-IsAccepted <Boolean>] [-IsOffered <Boolean>] [-IsRequired <Boolean>] [-Notes <String>]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ClaimType String:
    required: true
  -IsAccepted Boolean: ~
  -IsOffered Boolean: ~
  -IsRequired Boolean: ~
  -Name String:
    required: true
  -Notes String: ~
  -PassThru Switch: ~
  -ShortName String: ~
  -Confirm,-cf Switch: ~
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
