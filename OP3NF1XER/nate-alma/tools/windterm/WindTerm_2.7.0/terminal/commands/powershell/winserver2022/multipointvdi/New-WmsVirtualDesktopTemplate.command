description: Create a virtual desktop template
synopses:
- New-WmsVirtualDesktopTemplate -InputFilePath <String> [-VhdLocation <String>] -TemplatePrefix
  <String> -AdministratorUser <String> -AdministratorPassword <String> [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-WmsVirtualDesktopTemplate -InputFilePath <String> [-VhdLocation <String>] -TemplatePrefix
  <String> -AdministratorUser <String> -Domain <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdministratorPassword String:
    required: true
  -AdministratorUser String:
    required: true
  -Confirm,-cf Switch: ~
  -Domain String:
    required: true
  -InputFilePath String:
    required: true
  -TemplatePrefix String:
    required: true
  -VhdLocation String: ~
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
