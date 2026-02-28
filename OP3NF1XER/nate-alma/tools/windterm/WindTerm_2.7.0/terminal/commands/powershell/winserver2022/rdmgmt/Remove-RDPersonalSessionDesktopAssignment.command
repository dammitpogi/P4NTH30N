description: Removes the association between a personal session desktop assignment
  and a user
synopses:
- Remove-RDPersonalSessionDesktopAssignment [-CollectionName] <String> [-User] <String>
  [-ConnectionBroker <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-RDPersonalSessionDesktopAssignment [-CollectionName] <String> [-Name] <String>
  [-ConnectionBroker <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -Confirm,-cf Switch: ~
  -ConnectionBroker String: ~
  -Force Switch: ~
  -Name String:
    required: true
  -User String:
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
