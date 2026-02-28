description: Stops a running compute system in the Hyper-V Host Compute Service
synopses:
- Stop-ComputeProcess [-Id] <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Stop-ComputeProcess -ComputeProcess <ComputeProcess[]> [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -ComputeProcess ComputeProcess[]:
    required: true
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -Id String:
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
