description: Removes the action(s) associated with a capability
synopses:
- Remove-InsightsCapabilityAction [-Name] <String> [-AllActions] [[-ComputerName]
  <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-InsightsCapabilityAction [-Name] <String> [-Type] <PredictionStatus> [[-ComputerName]
  <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllActions Switch:
    required: true
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Name,-N String:
    required: true
  -Type PredictionStatus:
    required: true
    values:
    - None
    - Ok
    - Warning
    - Error
    - Critical
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
