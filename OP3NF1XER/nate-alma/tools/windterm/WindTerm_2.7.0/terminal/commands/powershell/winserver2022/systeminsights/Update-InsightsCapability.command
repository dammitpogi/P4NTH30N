description: Updates an existing System Insights capability. Updating a capability
  will preserve all of the custom configuration information associated with a capability
synopses:
- Update-InsightsCapability [-Name] <String> [-Library] <String> [[-ComputerName]
  <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Library String:
    required: true
  -Name,-N String:
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
