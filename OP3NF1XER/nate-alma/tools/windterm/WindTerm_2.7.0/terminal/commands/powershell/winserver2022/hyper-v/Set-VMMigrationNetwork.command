description: Sets the subnet, subnet mask, and/or priority of a migration network
synopses:
- Set-VMMigrationNetwork [-ComputerName <String[]>] [-Credential <PSCredential[]>]
  [-Subnet] <String> [[-NewSubnet] <String>] [-NewPriority <UInt32>] [-Passthru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-VMMigrationNetwork [-CimSession <CimSession[]>] [-Subnet] <String> [[-NewSubnet]
  <String>] [-NewPriority <UInt32>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -NewPriority UInt32: ~
  -NewSubnet String: ~
  -Passthru Switch: ~
  -Subnet String:
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
