description: Removes the list of virtual machines from the backup policy
synopses:
- Remove-WBVirtualMachine [-Policy] <WBPolicy> [[-VirtualMachine] <WBVirtualMachine[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-WBVirtualMachine [-Policy] <WBPolicy> [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -Confirm,-cf Switch: ~
  -Policy WBPolicy:
    required: true
  -VirtualMachine WBVirtualMachine[]: ~
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
