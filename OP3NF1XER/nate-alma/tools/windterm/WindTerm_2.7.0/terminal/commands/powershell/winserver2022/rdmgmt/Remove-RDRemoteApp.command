description: Removes a RemoteApp program
synopses:
- Remove-RDRemoteApp [-CollectionName] <String> -Alias <String> [-ConnectionBroker
  <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Alias String:
    required: true
  -CollectionName String:
    required: true
  -Confirm,-cf Switch: ~
  -ConnectionBroker String: ~
  -Force Switch: ~
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
