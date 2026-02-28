description: Closes an application
synopses:
- Close-WmsApp [-SessionId] <UInt32> [-ProcessId] <UInt32> [-WindowId] <UInt64> [-CreateTime]
  <UInt64> [-Server <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -CreateTime UInt64:
    required: true
  -ProcessId UInt32:
    required: true
  -Server,-ComputerName String: ~
  -SessionId UInt32:
    required: true
  -WhatIf,-wi Switch: ~
  -WindowId UInt64:
    required: true
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
