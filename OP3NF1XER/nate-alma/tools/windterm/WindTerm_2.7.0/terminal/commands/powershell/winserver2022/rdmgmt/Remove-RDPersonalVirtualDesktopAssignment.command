description: Removes the association between a personal virtual desktop and a user
synopses:
- powershell Remove-RDPersonalVirtualDesktopAssignment [-CollectionName] <String>
  [-User] <String> [-ConnectionBroker <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Remove-RDPersonalVirtualDesktopAssignment [-CollectionName] <String>
  [-VirtualDesktopName] <String> [-ConnectionBroker <String>] [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -Confirm,-cf Switch: ~
  -ConnectionBroker String: ~
  -Force Switch: ~
  -User String:
    required: true
  -VirtualDesktopName String:
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
