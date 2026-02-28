description: Removes an AD FS access control policy
synopses:
- Remove-AdfsAccessControlPolicy [-TargetName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-AdfsAccessControlPolicy [-TargetIdentifier] <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-AdfsAccessControlPolicy [-TargetAccessControlPolicy] <AdfsAccessControlPolicy>
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -TargetAccessControlPolicy AdfsAccessControlPolicy:
    required: true
  -TargetIdentifier String:
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
