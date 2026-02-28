description: Deactivates a capability, which stops data collection for that capability
  and prevents the capability from being invoked
synopses:
- Disable-InsightsCapability [-Name] <String> [[-ComputerName] <String>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
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
