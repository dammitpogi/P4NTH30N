description: Modifies an application group
synopses:
- Set-AdfsApplicationGroup [-TargetApplicationGroupIdentifier] <String> [-Name <String>]
  [-ApplicationGroupIdentifier <String>] [-Description <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationGroup [-TargetName] <String> [-Name <String>] [-ApplicationGroupIdentifier
  <String>] [-Description <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-AdfsApplicationGroup [-TargetApplicationGroup] <ApplicationGroup> [-Name <String>]
  [-ApplicationGroupIdentifier <String>] [-Description <String>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -ApplicationGroupIdentifier String: ~
  -Description String: ~
  -Name String: ~
  -PassThru Switch: ~
  -TargetApplicationGroup ApplicationGroup:
    required: true
  -TargetApplicationGroupIdentifier String:
    required: true
  -TargetName String:
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
