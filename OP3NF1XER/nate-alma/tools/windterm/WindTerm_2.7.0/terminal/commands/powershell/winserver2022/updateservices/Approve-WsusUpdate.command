description: Approves an update to be applied to clients
synopses:
- powershell Approve-WsusUpdate -Update <WsusUpdate> -Action <UpdateApprovalAction>
  -TargetGroupName <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Action UpdateApprovalAction:
    required: true
    values:
    - Install
    - Uninstall
    - NotApproved
    - All
  -Confirm,-cf Switch: ~
  -TargetGroupName String:
    required: true
  -Update WsusUpdate:
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
