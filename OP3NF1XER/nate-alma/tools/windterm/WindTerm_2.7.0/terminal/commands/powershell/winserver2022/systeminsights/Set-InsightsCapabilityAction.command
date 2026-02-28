description: Sets a remediation action that is tied to a prediction result
synopses:
- Set-InsightsCapabilityAction [-Name] <String> [-Type] <PredictionStatus> [-Action]
  <String> [-ActionCredential] <PSCredential> [[-ComputerName] <String>] [-Credential
  <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action String:
    required: true
  -ActionCredential PSCredential:
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
