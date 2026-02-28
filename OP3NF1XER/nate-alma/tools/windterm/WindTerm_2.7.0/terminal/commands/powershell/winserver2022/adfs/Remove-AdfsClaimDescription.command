description: Removes a claim description from the Federation Service
synopses:
- Remove-AdfsClaimDescription [-TargetName] <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsClaimDescription [-TargetShortName] <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsClaimDescription [-TargetClaimType] <String> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsClaimDescription [-TargetClaimDescription] <ClaimDescription> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -PassThru Switch: ~
  -TargetClaimDescription ClaimDescription:
    required: true
  -TargetClaimType String:
    required: true
  -TargetName String:
    required: true
  -TargetShortName String:
    required: true
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
