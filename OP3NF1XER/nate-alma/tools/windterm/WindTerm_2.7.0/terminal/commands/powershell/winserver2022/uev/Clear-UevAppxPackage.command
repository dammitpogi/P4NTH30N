description: Clears a setting in the computer or user sections of the registry
synopses:
- Clear-UevAppxPackage [-CurrentComputerUser] [-PackageFamilyName] <String[]> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Clear-UevAppxPackage [-Computer] [-PackageFamilyName] <String[]> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Clear-UevAppxPackage [-Computer] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
- Clear-UevAppxPackage [-CurrentComputerUser] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch:
    required: true
  -Computer Switch:
    required: true
  -Confirm,-cf Switch: ~
  -CurrentComputerUser Switch: ~
  -PackageFamilyName String[]:
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
