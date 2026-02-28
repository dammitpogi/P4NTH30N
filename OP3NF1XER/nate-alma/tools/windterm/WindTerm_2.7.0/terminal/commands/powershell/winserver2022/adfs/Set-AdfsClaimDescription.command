description: Modifies the properties of a claim description
synopses:
- Set-AdfsClaimDescription [-IsAccepted <Boolean>] [-IsOffered <Boolean>] [-IsRequired
  <Boolean>] [-Notes <String>] [-Name <String>] [-ClaimType <String>] [-ShortName
  <String>] [-TargetName] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsClaimDescription [-IsAccepted <Boolean>] [-IsOffered <Boolean>] [-IsRequired
  <Boolean>] [-Notes <String>] [-Name <String>] [-ClaimType <String>] [-ShortName
  <String>] [-TargetShortName] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsClaimDescription [-IsAccepted <Boolean>] [-IsOffered <Boolean>] [-IsRequired
  <Boolean>] [-Notes <String>] [-Name <String>] [-ClaimType <String>] [-ShortName
  <String>] [-TargetClaimType] <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsClaimDescription [-IsAccepted <Boolean>] [-IsOffered <Boolean>] [-IsRequired
  <Boolean>] [-Notes <String>] [-Name <String>] [-ClaimType <String>] [-ShortName
  <String>] [-TargetClaimDescription] <ClaimDescription> [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -ClaimType String: ~
  -IsAccepted Boolean: ~
  -IsOffered Boolean: ~
  -IsRequired Boolean: ~
  -Name String: ~
  -Notes String: ~
  -PassThru Switch: ~
  -ShortName String: ~
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
