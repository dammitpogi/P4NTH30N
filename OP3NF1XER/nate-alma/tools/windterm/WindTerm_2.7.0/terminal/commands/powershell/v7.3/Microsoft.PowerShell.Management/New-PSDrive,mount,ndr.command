description: Creates temporary and persistent drives that are associated with a location
  in an item data store
synopses:
- New-PSDrive [-Name] <String> [-PSProvider] <String> [-Root] <String> [-Description
  <String>] [-Scope <String>] [-Persist] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Description System.String: ~
  -Name System.String:
    required: true
  -Persist Switch: ~
  -PSProvider System.String:
    required: true
  -Root System.String:
    required: true
  -Scope System.String: ~
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
