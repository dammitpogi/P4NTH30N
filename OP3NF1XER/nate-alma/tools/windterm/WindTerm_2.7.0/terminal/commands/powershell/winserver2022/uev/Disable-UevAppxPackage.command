description: Disables UE-V synchronization of Windows 8 apps
synopses:
- Disable-UevAppxPackage [-CurrentComputerUser] [-PackageFamilyName] <String[]> [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Disable-UevAppxPackage [-Computer] [-PackageFamilyName] <String[]> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
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
